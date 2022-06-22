library ieee;
use ieee.std_logic_1164.all;


entity shift_register_piso_8bit is
port ( 
	S_OUT : out STD_LOGIC;
--	VAL_REG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	clear_piso : in std_logic;
	SHIFT : in STD_LOGIC;
	LOAD : in STD_LOGIC;
	CLK : in STD_LOGIC;
	P_IN : in STD_LOGIC_VECTOR (7 downto 0)
);
end shift_register_piso_8bit;

architecture beh of shift_register_piso_8bit is

signal VAL_REG: STD_LOGIC_VECTOR (7 downto 0);
begin

process (CLK) is
variable temp : std_logic_vector (7 downto 0);

begin
if (clk'EVENT AND clk = '1') then
	if (clear_piso='1') then
		temp := (others => '0');
else
	if (LOAD='1') then
		temp := P_IN;
		S_OUT <= temp(0);
	else
		if SHIFT = '1' then
			temp :=  '0' & temp(7 downto 1);
			S_OUT <= temp(0);
		end if;
	end if;
end if;
 VAL_REG <= temp;

end if;

end process;

end beh;

--&