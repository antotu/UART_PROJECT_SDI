library ieee;
use ieee.std_logic_1164.all;

entity RX_flip_flop is
port(
	DATA_IN : in STD_LOGIC;
	CLK : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	LD : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC
);
end RX_flip_flop;

architecture beh of RX_flip_flop is
begin
process(CLK)
	begin
	if (CLK'event and CLK = '1') then
		if CLEAR = '1' then
			DATA_OUT <= '0';
		else
			if LD = '1' then
			DATA_OUT <= DATA_IN;
			end if;
		end if;
	end if;
end process;
end beh;
 
