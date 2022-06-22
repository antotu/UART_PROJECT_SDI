library ieee;
use ieee.std_logic_1164.all;

entity SR_FF is
port(
	S,R,clk: in std_logic;
	Q: out std_logic);
end entity;

architecture behavioral of SR_FF is

begin

process(clk)
variable Qprev : std_logic;
begin
	if clk'event and clk = '1' then
		
		if S = '0' and R = '0' then

			Q <= Qprev;

		elsif S = '1' and R = '0' then

			Q <= '1';
			Qprev := '1';

		elsif S = '0' and R = '1' then

			Q <= '0';
			Qprev := '0';

		end if;
		
	end if;

end process;

end behavioral;
