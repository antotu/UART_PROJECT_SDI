library ieee;
use ieee.std_logic_1164.all;

entity rx_core is
port (
	--CLOCK
	CLK :in STD_LOGIC;


	-- signal to store 8xSYMBOL
	RxD : in STD_LOGIC;
	LD_SHIFT_R8: in STD_LOGIC;
	CLEAR_R8 : in STD_LOGIC;
	
	-- signal for MUX that check ERROR
	MUX_SEL_STOP_BIT : in STD_LOGIC;
	ERROR_STATUS_SIGNAL : buffer STD_LOGIC;

	-- error flip flop
	LD_ERROR : in STD_LOGIC;
	CLEAR_ERROR : in STD_LOGIC;
	ERROR : out STD_LOGIC;

	-- signal for FF BUSY
	CLEAR_BUSY : in STD_LOGIC;
	LD_BUSY : in STD_LOGIC;
	BUSY : out STD_LOGIC;
	
	-- status signal for start
	START : buffer STD_LOGIC;
	
	-- SHIFT_REGISTER_DATA_OUT
	CLEAR_DOUT : in STD_LOGIC;
	LOAD_SHIFT_DOUT : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC_VECTOR(7 DOWNTO 0);

	-- COUNTER TO WAIT NEXT SAMPLE
	EN_CNT_TIME_SAMPLE : in STD_LOGIC;
	CLEAR_CNT_TIME_SAMPLES : in STD_LOGIC;
	TC_TIME_SAMPLE : out STD_LOGIC;

	-- COUNTER 8 SAMPLES
	EN_CNT_8_SAMPLES : in STD_LOGIC;
	CLEAR_CNT_8_SAMPLES : in STD_LOGIC;
	TC_8_SAMPLES : out STD_LOGIC;
	TC_4_SAMPLES : out STD_LOGIC;

	-- COUNTER 8 SYMBOL
	EN_CNT_SYMBOLS : in STD_LOGIC;
	CLEAR_CNT_SYMBOLS : in STD_LOGIC;
	TC_SYMBOLS : out STD_LOGIC;
	
	-- FLIP FLOP DONE
	CLEAR_DONE : in STD_LOGIC;
	LD_DONE : in STD_LOGIC;
	DONE : OUT STD_LOGIC;


	-- COUNTER NOP
	EN_CNT_TIME_NOP : IN STD_LOGIC;
	CLEAR_CNT_TIME_NOP : IN STD_LOGIC;
	TC_TIME_NOP : OUT STD_LOGIC
);
end rx_core;




architecture beh of rx_core is

SIGNAL DATA_OUT_Rx8 : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL IN_VOTATORE: STD_LOGIC_VECTOR(2 downto 0);
SIGNAL OUT_MUX : STD_LOGIC;
SIGNAL OUT_VOTATORE : STD_LOGIC;
SIGNAL RXD_NEGATO : STD_LOGIC;
SIGNAL OUT_RX8_NEGATO : STD_LOGIC_VECTOR(7 downto 0);

component RX_counter_2_tc is
generic (N: positive;
	VALUE_MAX_1 : positive;
	VALUE_MAX_2 : positive);
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC1 : out STD_LOGIC;
	TC2 : out STD_LOGIC
);
end component;

component RX_SHIFT_REGISTER is
    generic (
      N: natural := 8
      );
    port (
        -- DATA INPUT
        DATA_IN : in STD_LOGIC;
        -- LOAD SHIFT
        LD_SHIFT_REG : in STD_LOGIC;
        -- CLEAR REGISTER to all 1
        CLEAR_REG : in STD_LOGIC;
        --CLOCK
        CLK : in STD_LOGIC;

        -- OUTPUT REGISTER PARALLEL
        DOUT_REG : out STD_LOGIC_VECTOR (N-1 downto 0)
      );
  end component;



component RX_recognize_start is
port(
	DATA_INPUT : in STD_LOGIC_VECTOR(7 downto 0);
	START : out STD_LOGIC
);
end component;

component RX_counter_with_tc is
generic (N: positive;
	VALUE_MAX : positive);
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC : out STD_LOGIC
);
end component;

component RX_mux2to1 is
	port (
	DATA1 : in STD_LOGIC;
	DATA2 : in STD_LOGIC;
	SEL : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC
);
end component;

component RX_flip_flop
port(
	DATA_IN : in STD_LOGIC;
	CLK : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	LD : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC
);
end component;

component RX_recognize_value is
port (
	INPUT_DATA : in std_logic_vector(2 downto 0);
	RES : out std_logic
);
end component;

component SR_FF is
	port(
		S,R,clk: in std_logic;
		Q: out std_logic);
	end component;

begin

RXD_NEGATO <= NOT (RxD);


RX8_SAMPLES :  RX_SHIFT_REGISTER 
    generic map(
      N => 8
      )
    port map(
        DATA_IN => RXD_NEGATO,
        LD_SHIFT_REG => LD_SHIFT_R8,
        CLEAR_REG => CLEAR_R8,
        CLK => CLK,
        DOUT_REG => OUT_RX8_NEGATO
      );

DATA_OUT_Rx8 <= NOT(OUT_RX8_NEGATO);
RICONOSCITORE_START: RX_recognize_start
port map(
	DATA_INPUT => DATA_OUT_Rx8,
	START => START
);

SR_BUSY : SR_FF	port map(S => LD_BUSY,R => CLEAR_BUSY, clk => CLK, Q => BUSY);

--REG_BUSY : RX_flip_flop
--port map(
--	DATA_IN => START,
--	CLK => CLK,
--	CLEAR => CLEAR_BUSY,
--	LD => LD_BUSY,
--	DATA_OUT => BUSY
--);

IN_VOTATORE <= (DATA_OUT_Rx8(5) & DATA_OUT_Rx8(4) & DATA_OUT_Rx8(3));

DECISORE_UNIT: RX_recognize_value
port map(
	INPUT_DATA => IN_VOTATORE,
	RES => OUT_VOTATORE
);



MUX_SEL_EXPECTED_VAL : RX_mux2to1
	port map(
	DATA1 => '0',
	DATA2 => '1',
	SEL => MUX_SEL_STOP_BIT,
	DATA_OUT => OUT_MUX
);

ERROR_STATUS_SIGNAL <= OUT_MUX xor OUT_VOTATORE;

SR_ERROR : SR_FF port map(S => LD_ERROR,R => CLEAR_ERROR, clk => CLK, Q => ERROR);

--REG_ERROR : RX_flip_flop
--port map(
--	DATA_IN => ERROR_STATUS_SIGNAL,
--	CLK => CLK,
--	CLEAR => CLEAR_ERROR,
--	LD => LD_ERROR,
--	DATA_OUT => ERROR
--);



REG_DATA_OUT: RX_SHIFT_REGISTER 
    generic map(
      N => 8
      )
    port map(
        DATA_IN => OUT_VOTATORE,
        LD_SHIFT_REG => LOAD_SHIFT_DOUT,
        CLEAR_REG => CLEAR_DOUT,
        CLK => CLK,
        DOUT_REG => DATA_OUT
      );


COUNTER_TIME_SAMPLES: RX_counter_with_tc
generic map (N => 5,
	VALUE_MAX => 15)
port map (
	EN_CNT => EN_CNT_TIME_SAMPLE,
	CLEAR => CLEAR_CNT_TIME_SAMPLES,
	CLK => CLK,
	TC => TC_TIME_SAMPLE
);

COUNTER_SYMBOLS: RX_counter_with_tc
generic map (N => 4,
	VALUE_MAX => 8)
port map (
	EN_CNT => EN_CNT_SYMBOLS,
	CLEAR => CLEAR_CNT_SYMBOLS,
	CLK => CLK,
	TC => TC_SYMBOLS
);

SR_DONE : SR_FF	port map(S => LD_DONE,R => CLEAR_DONE, clk => CLK, Q => DONE);

CNT_SAMPLES: RX_counter_2_tc
generic map(N => 4,
	VALUE_MAX_1 => 4,
	VALUE_MAX_2 => 8)
port map(
	EN_CNT => EN_CNT_8_SAMPLES,
	CLEAR => CLEAR_CNT_8_SAMPLES,
	CLK => CLK,
	TC1 => TC_4_SAMPLES,
	TC2 => TC_8_SAMPLES
);


CNT_TIME_NOP : RX_counter_with_tc
generic map (N => 1,
	VALUE_MAX => 1)
port map (
	EN_CNT => EN_CNT_TIME_NOP,
	CLEAR => CLEAR_CNT_TIME_NOP,
	CLK => CLK,
	TC => TC_TIME_NOP
);



end architecture;
