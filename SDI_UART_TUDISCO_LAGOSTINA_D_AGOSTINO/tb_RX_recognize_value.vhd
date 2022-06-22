library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RX_recognize_value is
end tb_RX_recognize_value;


architecture beh of tb_RX_recognize_value is


component RX_recognize_value is
port (
	INPUT_DATA : in std_logic_vector(2 downto 0);
	RES : out std_logic
);
end component;

signal INPUT_DATA : std_logic_vector(2 downto 0);
signal res : std_logic;


begin

UUT: RX_recognize_value port map(
INPUT_DATA => INPUT_DATA,
RES => RES
);

SIGNAL_GEN: process
	begin
	for i in 0 to 7 loop
		INPUT_DATA <= std_logic_vector(to_unsigned(i, 3));
		wait for 10 ns;
	end loop;
	wait;
end process;
end beh;
