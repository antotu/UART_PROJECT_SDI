library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;


entity tb_RX_terminal_count_analyzer is
	end tb_RX_terminal_count_analyzer;

architecture beh of tb_RX_terminal_count_analyzer is
constant N : positive := 5;
constant VAL_MAX : positive := 17;

component RX_terminal_count_analyzer is
generic (N: positive;
	VALUE_MAX : positive);
port (
	DATA_TO_ANALYZE : in UNSIGNED(N -1 downto 0);
	TC : out STD_LOGIC
);
end component;

signal DATA_TO_ANALYZE : UNSIGNED(N -1 DOWNTO 0);
signal TC : STD_LOGIC;


begin
DUT:  RX_terminal_count_analyzer
generic map ( N => N,
VALUE_MAX => VAL_MAX)
port map(
	DATA_TO_ANALYZE => DATA_TO_ANALYZE,
	TC => TC
);



	GEN_SIGNAL : process
		begin
		for i in 0 to (2 ** N - 1) loop
			DATA_TO_ANALYZE <= to_unsigned(i, N);
			wait for 10 ns;
		end loop;
		wait;
	end process;
end beh;
	
