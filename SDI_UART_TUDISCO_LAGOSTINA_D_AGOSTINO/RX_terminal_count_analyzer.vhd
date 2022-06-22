library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RX_terminal_count_analyzer is
generic (N: positive;
	VALUE_MAX : positive);
port (
	DATA_TO_ANALYZE : in UNSIGNED(N -1 downto 0);
	TC : out STD_LOGIC
);
end RX_terminal_count_analyzer;

architecture beh of RX_terminal_count_analyzer is

begin
	process(DATA_TO_ANALYZE)
	begin
		if (to_integer(DATA_TO_ANALYZE) = VALUE_MAX) then
			TC <= '1';
		else
			TC <= '0';
		end if;
	end process;
end beh;


