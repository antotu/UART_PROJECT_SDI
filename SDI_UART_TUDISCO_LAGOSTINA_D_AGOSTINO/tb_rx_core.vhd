library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_rx_core is
end tb_rx_core;

architecture beh of tb_rx_core is


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
	DONE : OUT STD_LOGIC


);
end component;



signal CLK : STD_LOGIC;

signal RxD :  STD_LOGIC;
signal LD_SHIFT_R8:  STD_LOGIC;
signal CLEAR_R8 :  STD_LOGIC;

signal MUX_SEL_STOP_BIT :  STD_LOGIC;
signal ERROR_STATUS_SIGNAL :  STD_LOGIC;

signal LD_ERROR :  STD_LOGIC;
signal CLEAR_ERROR :  STD_LOGIC;
signal ERROR :  STD_LOGIC;

signal CLEAR_BUSY :  STD_LOGIC;
signal LD_BUSY : STD_LOGIC;
signal BUSY : STD_LOGIC;

signal START : STD_LOGIC;

signal LOAD_SHIFT_DOUT : STD_LOGIC;
signal DATA_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);

signal EN_CNT_TIME_SAMPLE : STD_LOGIC;
signal CLEAR_CNT_TIME_SAMPLES :  STD_LOGIC;
signal TC_TIME_SAMPLE :  STD_LOGIC;

signal EN_CNT_8_SAMPLES : STD_LOGIC;
signal CLEAR_CNT_8_SAMPLES : STD_LOGIC;
signal TC_8_SAMPLES :  STD_LOGIC;
signal TC_4_SAMPLES :  STD_LOGIC;

signal EN_CNT_SYMBOLS :  STD_LOGIC;
signal CLEAR_CNT_SYMBOLS :  STD_LOGIC;
signal TC_SYMBOLS :  STD_LOGIC;

signal CLEAR_DONE :  STD_LOGIC;
signal LD_DONE :  STD_LOGIC;
signal DONE :  STD_LOGIC;



begin

UUT: rx_core
port map(
--CLOCK
	CLK => CLK,


	-- signal to store 8xSYMBOL
	RxD => RxD,
	LD_SHIFT_R8 => LD_SHIFT_R8,
	CLEAR_R8 => CLEAR_R8,
	
	MUX_SEL_STOP_BIT => MUX_SEL_STOP_BIT,
	ERROR_STATUS_SIGNAL => ERROR_STATUS_SIGNAL,
	LD_ERROR => LD_ERROR,
	CLEAR_ERROR => CLEAR_ERROR,
	ERROR => ERROR,
	CLEAR_BUSY => CLEAR_BUSY,
	LD_BUSY => LD_BUSY,
	BUSY => BUSY,
	START => START,
	LOAD_SHIFT_DOUT => LOAD_SHIFT_DOUT,
	DATA_OUT => DATA_OUT,
	EN_CNT_TIME_SAMPLE => EN_CNT_TIME_SAMPLE,
	CLEAR_CNT_TIME_SAMPLES => CLEAR_CNT_TIME_SAMPLES,
	TC_TIME_SAMPLE => TC_TIME_SAMPLE,
	EN_CNT_8_SAMPLES => EN_CNT_8_SAMPLES,
	CLEAR_CNT_8_SAMPLES => CLEAR_CNT_8_SAMPLES,
	TC_8_SAMPLES => TC_8_SAMPLES,
	TC_4_SAMPLES => TC_4_SAMPLES,

	EN_CNT_SYMBOLS => EN_CNT_SYMBOLS,
	CLEAR_CNT_SYMBOLS => CLEAR_CNT_SYMBOLS,
	TC_SYMBOLS => TC_SYMBOLS,
	
	CLEAR_DONE => CLEAR_DONE,
	LD_DONE => LD_DONE,
	DONE => DONE


);

CLK_GEN: process
BEGIN
CLK <= '1';
wait for 10 ns;
CLK <= '0';
wait for 10 ns;
end process;


SIGNAL_GEN: process
BEGIN
--RESET
CLEAR_R8 <= '1';
CLEAR_DONE <= '1';
CLEAR_CNT_SYMBOLS <= '1';
CLEAR_CNT_8_SAMPLES <= '1';
CLEAR_CNT_TIME_SAMPLES <= '1';
CLEAR_BUSY <= '1';
CLEAR_ERROR <= '1';
RxD <= '0';
MUX_SEL_STOP_BIT <= '0';



wait for 30 ns;

-- PARTE A

CLEAR_R8 <= '0';
CLEAR_DONE <= '0';
CLEAR_CNT_SYMBOLS <= '0';
CLEAR_CNT_8_SAMPLES <= '0';
CLEAR_CNT_TIME_SAMPLES <= '0';
CLEAR_BUSY <= '0';
CLEAR_ERROR <= '0';
LD_SHIFT_R8 <= '1';

wait for 20 ns;

LD_SHIFT_R8 <= '0';
EN_CNT_TIME_SAMPLE <= '1';
wait for 320 ns;

-- PARTE B
for i in 0 to 1 loop
	LD_SHIFT_R8 <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	wait for 20 ns;

	LD_SHIFT_R8 <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 320 ns;

end loop;


-- PARTE C

	LD_SHIFT_R8 <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	wait for 20 ns;

	LD_SHIFT_R8 <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 20 ns;

	LD_BUSY <= '1';
	CLEAR_ERROR <= '1';
	CLEAR_DONE <= '1';
	wait for 20 ns;

	LD_BUSY <= '0';
	CLEAR_ERROR <= '0';
	CLEAR_DONE <= '0';
	wait for 280 ns;


-- PARTE D

	for i in 0 to 3 loop
	LD_SHIFT_R8 <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	EN_CNT_8_SAMPLES <= '1';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	EN_CNT_8_SAMPLES <= '0';
	wait for 320 ns;
	end loop;

-- PARTE E
	LD_ERROR <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	CLEAR_CNT_8_SAMPLES <= '1';
	wait for 20 ns;
	LD_ERROR <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	CLEAR_CNT_8_SAMPLES <= '0';
	wait for 60 ns;
	LD_SHIFT_R8 <= '1';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 320 ns;

-- PARTE F
for i in 0 to 6 loop
	LD_SHIFT_R8 <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_8_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	EN_CNT_8_SAMPLES <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 320 ns;		
end loop;

-- PARTE G
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	CLEAR_CNT_8_SAMPLES <= '1';
	LOAD_SHIFT_DOUT <= '1';
	wait for 20 ns;
	CLEAR_CNT_TIME_SAMPLES <= '0';
	CLEAR_CNT_8_SAMPLES <= '0';
	LOAD_SHIFT_DOUT <= '0';
	wait for 60 ns;
	LD_SHIFT_R8 <= '1';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 320 ns;

-- PARTE H
for i in 0 to 6 loop
	
	-- LETTURA SIMBOLO
for j in 0 to 6 loop
	LD_SHIFT_R8 <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_8_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	EN_CNT_8_SAMPLES <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 320 ns;		
end loop;

-- GESTIONE PARTE FINALE SIMBOLO
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	CLEAR_CNT_8_SAMPLES <= '1';
	LOAD_SHIFT_DOUT <= '1';
	EN_CNT_SYMBOLS <= '1';
	wait for 20 ns;
	CLEAR_CNT_TIME_SAMPLES <= '0';
	CLEAR_CNT_8_SAMPLES <= '0';
	LOAD_SHIFT_DOUT <= '0';
	EN_CNT_SYMBOLS <= '0';
	wait for 60 ns;
	LD_SHIFT_R8 <= '1';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 320 ns;



end loop;
-- STOP BIT
for j in 0 to 5 loop
	LD_SHIFT_R8 <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_8_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	EN_CNT_8_SAMPLES <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 320 ns;		
end loop;
-- ULTIMO SAMPLES
LD_SHIFT_R8 <= '1';
	CLEAR_CNT_TIME_SAMPLES <= '1';
	EN_CNT_8_SAMPLES <= '1';
	EN_CNT_TIME_SAMPLE <= '0';
	wait for 20 ns;
	LD_SHIFT_R8 <= '0';
	CLEAR_CNT_TIME_SAMPLES <= '0';
	EN_CNT_8_SAMPLES <= '0';
	EN_CNT_TIME_SAMPLE <= '1';
	wait for 40 ns;
	LD_ERROR <= '1';
	MUX_SEL_STOP_BIT <= '1';
	wait for 20 ns;
	LD_ERROR <= '0';
	CLEAR_BUSY <= '1';
	LD_DONE <= '1';
	wait for 20 ns;
	LD_DONE <= '0';
	CLEAR_BUSY <= '0';
	wait;
	
end process;

end beh;


