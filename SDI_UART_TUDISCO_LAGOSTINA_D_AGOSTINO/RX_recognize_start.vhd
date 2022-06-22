library ieee;
use ieee.std_logic_1164.all;

entity RX_recognize_start is
port(
	DATA_INPUT : in STD_LOGIC_VECTOR(7 downto 0);
	START : out STD_LOGIC
);
end RX_recognize_start;


architecture beh of RX_recognize_start is
SIGNAL ALL_ZERO : std_logic;
SIGNAL AT_LEAST_3_1 : std_logic;
begin

ALL_ZERO <= (not(DATA_INPUT(7))) and (not(DATA_INPUT(6))) and (not(DATA_INPUT(5))) and (not(DATA_INPUT(4)));

AT_LEAST_3_1 <= ((DATA_INPUT(3) and DATA_INPUT(2)) and (DATA_INPUT(1) or DATA_INPUT(0))) or ((DATA_INPUT(1) and DATA_INPUT(0)) and (DATA_INPUT(3) or DATA_INPUT(2)));

START <= ALL_ZERO and AT_LEAST_3_1;

end beh;

