library ieee;
use ieee.std_logic_1164.all;

entity FF is
	port (data_in: in std_logic;
		    CLK, reset, enable: in std_logic;
		    data_out: out std_logic);
end entity FF;

architecture beh of FF is

begin

	process(CLK)
	begin
		
		if(CLK'event and CLK = '1') then
			
			if (reset = '0') then
			   
			   data_out <= '0';
			
			elsif enable = '1' then
			
			   data_out <= data_in;
			   
			end if;
		end if;
	end process;

end architecture beh;