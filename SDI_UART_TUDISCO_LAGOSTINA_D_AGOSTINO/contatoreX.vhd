library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contatoreX is
generic (N : natural);
port (
EN_CNT : in STD_LOGIC;
CLEAR : in STD_LOGIC;
CLK : in STD_LOGIC;
DOUT : buffer UNSIGNED(N-1 downto 0)
);
end contatoreX;

architecture beh of contatoreX is
	begin
		CNT: process(CLK)
			begin
				if (CLK'event and CLK = '1') then
					if (CLEAR = '1') then
						DOUT <= (others => '0');
					else
						if (EN_CNT = '1') then
							DOUT <= DOUT + 1;
						end if;
					end if;
				end if;
		end process;
end beh;
