library ieee;
use ieee.std_logic_1164.all;


entity RX_recognize_value is
port (
	INPUT_DATA : in std_logic_vector(2 downto 0);
	RES : out std_logic
);
end RX_recognize_value;


architecture beh of RX_recognize_value is

begin

RES <= (INPUT_DATA(0) and INPUT_DATA(1)) or (INPUT_DATA(2) and (INPUT_DATA(1) xor INPUT_DATA(0)));

end beh;
