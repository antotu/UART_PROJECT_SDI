library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity flip_flop is
port(
	D_IN : in STD_LOGIC;
	D_OUT : out STD_LOGIC;
	CLK: in STD_LOGIC;
	CLEAR: in STD_LOGIC;
	LD: in STD_LOGIC
);
end flip_flop;


architecture beh of flip_flop is
begin

process (CLK)
	begin
		if (CLK'event and CLK = '1')then
			if (CLEAR = '1')then
				D_OUT <= '0';
			else
				if(LD = '1')then
				D_OUT <= D_IN;
				end if;
			end if;
		end if;
	
end process;
end beh;