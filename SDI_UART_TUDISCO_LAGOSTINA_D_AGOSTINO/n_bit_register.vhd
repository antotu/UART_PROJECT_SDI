library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity n_bit_register is
	generic (n_bit: integer);
	port (data_in: in std_logic_vector(n_bit - 1 downto 0);
		    CLK, reset, enable: in std_logic;
		    data_out: out std_logic_vector(n_bit - 1 downto 0));
end entity n_bit_register;

architecture beh of n_bit_register is

begin

	process(CLK)
	begin
		
		if(CLK'event and CLK = '1') then
			
			if (reset = '0') then
			   
			   data_out <= (others => '0');
			
			elsif enable = '1' then
			
			   data_out <= data_in;
			   
			end if;
		end if;
	end process;

end architecture beh;