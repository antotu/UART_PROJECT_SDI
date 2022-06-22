library ieee;
use ieee.std_logic_1164.all;

entity RX_mux2to1 is
	port (
	DATA1 : in STD_LOGIC;
	DATA2 : in STD_LOGIC;
	SEL : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC
);
end RX_mux2to1;

architecture beh of RX_mux2to1 is

begin
	with SEL SELECT
			DATA_OUT <= DATA1 when '0',
				 DATA2 when others;
end beh;  