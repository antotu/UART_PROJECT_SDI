library ieee;
use ieee.std_logic_1164.all;

entity blocco_txd is

--segnali 
port (
	P_IN : in STD_LOGIC_VECTOR (7 downto 0);	-- 8 bit in ingresso
	LOAD : in STD_LOGIC;	-- segnale di load
	SHIFT : in STD_LOGIC;	-- segnale di shift
	clear_piso : in std_logic;
	F_0 : in STD_LOGIC;	
	F_1 : in STD_LOGIC;

	CLK : in STD_LOGIC; 	-- segnale di clock

	TXD : out STD_LOGIC	-- uscita dello shift register
);
end blocco_txd;

architecture beh of blocco_txd is

component shift_register_piso_8bit port ( 
	S_OUT : out STD_LOGIC;
--	VAL_REG : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	clear_piso : in std_logic;
	SHIFT : in STD_LOGIC;
	LOAD : in STD_LOGIC;
	CLK : in STD_LOGIC;
	P_IN : in STD_LOGIC_VECTOR (7 downto 0)
);
end component;

signal out_shift_reg : STD_LOGIC; 	--uscita shift register
signal O_1 : STD_LOGIC;			--uscita and
--signal clear_piso : STD_LOGIC;		
--signal val_reg : STD_LOGIC_VECTOR (7 downto 0);


begin

BLOCCO_SHIFT: shift_register_piso_8bit port map (
	CLK => CLK,
	P_IN => P_IN,
	clear_piso => clear_piso,
	LOAD => LOAD,
	SHIFT => SHIFT,
	S_OUT => out_shift_reg
);

O_1 <= (NOT(F_0) and out_shift_reg );
TXD <= (F_1 or  O_1);

end beh;