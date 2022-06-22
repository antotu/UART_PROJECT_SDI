library ieee;
use ieee.std_logic_1164.all;

entity RX_SHIFT_REGISTER is
    generic (
      N: natural := 8
      );
    port (
        -- DATA INPUT
        DATA_IN : in STD_LOGIC;
        -- LOAD SHIFT
        LD_SHIFT_REG : in STD_LOGIC;
        -- CLEAR REGISTER to all 1
        CLEAR_REG : in STD_LOGIC;
        --CLOCK
        CLK : in STD_LOGIC;

        -- OUTPUT REGISTER PARALLEL
        DOUT_REG : out STD_LOGIC_VECTOR (N-1 downto 0)
      );
  end RX_SHIFT_REGISTER;


  architecture beh of RX_SHIFT_REGISTER is
	component RX_flip_flop port(
	DATA_IN : in STD_LOGIC;
	CLK : in STD_LOGIC;
	CLEAR : in STD_LOGIC;
	LD : in STD_LOGIC;
	DATA_OUT : out STD_LOGIC
	);
	end component;
	SIGNAL DATA_FLIP_FLOP : STD_LOGIC_VECTOR (N downto 0);
begin

SHIFT_REG_GEN: for i in 0 to N -1 generate
	FLIP_FLOP_GEN: RX_flip_flop port map(
	DATA_IN => DATA_FLIP_FLOP(N - i),
	CLEAR => CLEAR_REG,
	CLK => CLK,
	LD => LD_SHIFT_REG,
	DATA_OUT => DATA_FLIP_FLOP(N - (i + 1))
);
end generate;

DATA_FLIP_FLOP(N) <= (DATA_IN);
DOUT_REG <= DATA_FLIP_FLOP(N - 1 downto 0);

end beh;