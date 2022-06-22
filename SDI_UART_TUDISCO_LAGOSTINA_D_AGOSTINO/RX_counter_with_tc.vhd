library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX_counter_with_tc is
generic (N: positive;
	VALUE_MAX : positive);
port (
	EN_CNT : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	CLK : in STD_LOGIC;
	TC : out STD_LOGIC
);
end RX_counter_with_tc;

architecture beh of RX_counter_with_tc is


SIGNAL VALUE_CNT : UNSIGNED(N - 1 downto 0);

component RX_terminal_count_analyzer is
generic (N: positive;
	VALUE_MAX : positive);
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


TC_ANALYZER: RX_terminal_count_analyzer generic map (
		N => N,
		VALUE_MAX => VALUE_MAX)
		port map (
		DATA_TO_ANALYZE => VALUE_CNT,
		TC => TC
);

end beh;
