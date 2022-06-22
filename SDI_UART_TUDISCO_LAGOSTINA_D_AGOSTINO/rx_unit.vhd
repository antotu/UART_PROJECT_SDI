library ieee;
use ieee.std_logic_1164.all;

entity rx_unit is
port ( 
	RXD : in std_logic;
	CLK : IN STD_LOGIC;
	EN_RX : IN STD_LOGIC;
	DATA_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	ERROR : OUT STD_LOGIC;
	BUSY : OUT STD_LOGIC;
	DONE : OUT STD_LOGIC
);
END RX_UNIT;


ARCHITECTURE BEH OF RX_UNIT IS

signal ERROR_STATUS : STD_LOGIC;
signal START : STD_LOGIC;
signal TC_TIME_SAMPLE : STD_LOGIC;
signal TC_8_SAMPLES : STD_LOGIC;
signal TC_4_SAMPLES : STD_LOGIC;
signal TC_READ_ALL : STD_LOGIC;

signal CLEAR_DOUT : STD_LOGIC;
signal LD_SHIFT_R8 : STD_LOGIC;
signal CLEAR_R8 : STD_LOGIC;
signal MUX_SEL_STOP_BIT : STD_LOGIC;
signal LD_ERROR : STD_LOGIC;
signal CLEAR_ERROR : STD_LOGIC;
signal CLEAR_BUSY : STD_LOGIC;
signal LD_BUSY : STD_LOGIC;
signal LD_SHIFT_DOUT : STD_LOGIC;
signal EN_CNT_TIME_SAMPLES : STD_LOGIC;
signal CLEAR_CNT_TIME_SAMPLES : STD_LOGIC;
signal EN_CNT_8_SAMPLES : STD_LOGIC;
signal CLEAR_CNT_8_SAMPLES : STD_LOGIC;
signal EN_CNT_SYMBOL : STD_LOGIC;
signal CLEAR_CNT_SYMBOL : STD_LOGIC;
signal CLEAR_DONE : STD_LOGIC;
signal LD_DONE : STD_LOGIC;
signal EN_CNT_TIME_NOP : STD_LOGIC;
signal CLEAR_CNT_TIME_NOP : STD_LOGIC;
signal TC_TIME_NOP : STD_LOGIC;


component CU_RX is 
port (
CLK : IN STD_LOGIC;

-- INPUT
EN_RX : IN STD_LOGIC;
ERROR_STATUS : IN STD_LOGIC;
START : IN STD_LOGIC;
TC_TIME_SAMPLE : IN STD_LOGIC;
TC_8_SAMPLES : IN STD_LOGIC;
TC_4_SAMPLES : IN STD_LOGIC;
TC_READ_ALL : IN STD_LOGIC;

TC_TIME_NOP : IN STD_LOGIC;

-- OUTPUT
CLEAR_DOUT : OUT STD_LOGIC;
LD_SHIFT_R8 : OUT STD_LOGIC;
CLEAR_R8 : OUT STD_LOGIC;
MUX_SEL_STOP_BIT : OUT STD_LOGIC;
LD_ERROR : OUT STD_LOGIC;
CLEAR_ERROR : OUT STD_LOGIC;
CLEAR_BUSY : OUT STD_LOGIC;
LD_BUSY : OUT STD_LOGIC;
LD_SHIFT_DOUT : OUT STD_LOGIC;
EN_CNT_TIME_SAMPLES : OUT STD_LOGIC;
CLEAR_CNT_TIME_SAMPLES : OUT STD_LOGIC;
EN_CNT_8_SAMPLES : OUT STD_LOGIC;
CLEAR_CNT_8_SAMPLES : OUT STD_LOGIC;
EN_CNT_SYMBOL : OUT STD_LOGIC;
CLEAR_CNT_SYMBOL : OUT STD_LOGIC;
CLEAR_DONE : OUT STD_LOGIC;
LD_DONE : OUT STD_LOGIC;

EN_CNT_TIME_NOP : OUT STD_LOGIC;
CLEAR_CNT_TIME_NOP : OUT STD_LOGIC
);
 end component;



component rx_core is
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
end component;



begin

CU: CU_RX port map (
CLK => CLK,

EN_RX => EN_RX,
ERROR_STATUS => ERROR_STATUS,
START => START,
TC_TIME_SAMPLE => TC_TIME_SAMPLE,
TC_8_SAMPLES => TC_8_SAMPLES,
TC_4_SAMPLES => TC_4_SAMPLES,
TC_READ_ALL => TC_READ_ALL,
TC_TIME_NOP => TC_TIME_NOP,

CLEAR_DOUT => CLEAR_DOUT,
LD_SHIFT_R8 => LD_SHIFT_R8,
CLEAR_R8 => CLEAR_R8,
MUX_SEL_STOP_BIT => MUX_SEL_STOP_BIT,
LD_ERROR => LD_ERROR,
CLEAR_ERROR => CLEAR_ERROR,
CLEAR_BUSY => CLEAR_BUSY,
LD_BUSY => LD_BUSY,
LD_SHIFT_DOUT => LD_SHIFT_DOUT,
EN_CNT_TIME_SAMPLES => EN_CNT_TIME_SAMPLES,
CLEAR_CNT_TIME_SAMPLES => CLEAR_CNT_TIME_SAMPLES,
EN_CNT_8_SAMPLES => EN_CNT_8_SAMPLES,
CLEAR_CNT_8_SAMPLES => CLEAR_CNT_8_SAMPLES,
EN_CNT_SYMBOL => EN_CNT_SYMBOL,
CLEAR_CNT_SYMBOL => CLEAR_CNT_SYMBOL,
CLEAR_DONE => CLEAR_DONE,
LD_DONE => LD_DONE,
EN_CNT_TIME_NOP => EN_CNT_TIME_NOP,
CLEAR_CNT_TIME_NOP => CLEAR_CNT_TIME_NOP
);


UUT: rx_core
port map(
--CLOCK
	CLK => CLK,


	-- signal to store 8xSYMBOL
	RxD => RxD,
	LD_SHIFT_R8 => LD_SHIFT_R8,
	CLEAR_R8 => CLEAR_R8,
	
	MUX_SEL_STOP_BIT => MUX_SEL_STOP_BIT,
	ERROR_STATUS_SIGNAL => ERROR_STATUS,
	LD_ERROR => LD_ERROR,
	CLEAR_ERROR => CLEAR_ERROR,
	ERROR => ERROR,
	CLEAR_BUSY => CLEAR_BUSY,
	LD_BUSY => LD_BUSY,
	BUSY => BUSY,
	START => START,
	CLEAR_DOUT => CLEAR_DOUT,
	LOAD_SHIFT_DOUT => LD_SHIFT_DOUT,
	DATA_OUT => DATA_OUT,
	EN_CNT_TIME_SAMPLE => EN_CNT_TIME_SAMPLES,
	CLEAR_CNT_TIME_SAMPLES => CLEAR_CNT_TIME_SAMPLES,
	TC_TIME_SAMPLE => TC_TIME_SAMPLE,
	EN_CNT_8_SAMPLES => EN_CNT_8_SAMPLES,
	CLEAR_CNT_8_SAMPLES => CLEAR_CNT_8_SAMPLES,
	TC_8_SAMPLES => TC_8_SAMPLES,
	TC_4_SAMPLES => TC_4_SAMPLES,

	EN_CNT_SYMBOLS => EN_CNT_SYMBOL,
	CLEAR_CNT_SYMBOLS => CLEAR_CNT_SYMBOL,
	TC_SYMBOLS => TC_READ_ALL,
	
	CLEAR_DONE => CLEAR_DONE,
	LD_DONE => LD_DONE,
	DONE => DONE,

	EN_CNT_TIME_NOP => EN_CNT_TIME_NOP,
	CLEAR_CNT_TIME_NOP => CLEAR_CNT_TIME_NOP,
	TC_TIME_NOP => TC_TIME_NOP

);

end BEH;