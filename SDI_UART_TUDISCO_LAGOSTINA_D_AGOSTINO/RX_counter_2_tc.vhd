
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX_counter_2_tc is
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
end RX_counter_2_tc;

architecture beh of RX_counter_2_tc is


SIGNAL VALUE_CNT : UNSIGNED(N - 1 downto 0);

component RX_terminal_count_analyzer is
generic (N: positive;
	VALUE_MAX : positive
);
port (
	DATA_TO_ANALYZE : in UNSIGNED(N -1 downto 0);
	TC : out STD_LOGIC
);
end component;



component RX_contatore is
generic (N : natural);
port (
EN_CNT : in STD_LOGIC;
CLEAR : in STD_LOGIC;
CLK : in STD_LOGIC;
DOUT : buffer UNSIGNED(N-1 downto 0)
);
end component;


begin

COUNTER: RX_contatore generic map (N => N) port map (
	EN_CNT => EN_CNT,
	CLK => CLK,
	CLEAR => CLEAR,
	DOUT => VALUE_CNT
);


TC_ANALYZER_1: RX_terminal_count_analyzer generic map (
		N => N,
		VALUE_MAX => VALUE_MAX_1)
		port map (
		DATA_TO_ANALYZE => VALUE_CNT,
		TC => TC1
);

TC_ANALYZER_2: RX_terminal_count_analyzer generic map (
		N => N,
		VALUE_MAX => VALUE_MAX_2)
		port map (
		DATA_TO_ANALYZE => VALUE_CNT,
		TC => TC2
);
end beh;