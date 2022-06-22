library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 
entity TB_RX_SHIFT_REGISTER is
 
end TB_RX_SHIFT_REGISTER;
 
 
architecture behave of TB_RX_SHIFT_REGISTER is
 constant N : positive := 8;
  -- UUT declaration
component RX_SHIFT_REGISTER is
    generic (
	N: natural);
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
        DOUT_REG : buffer STD_LOGIC_VECTOR (N-1 downto 0)
      );
  end component;
 
 
 
  signal r_DATA_IN : STD_LOGIC := '1';
  signal r_LD_SHIFT_REG : STD_LOGIC := '1';
  signal r_CLEAR_REG : STD_LOGIC := '1';
  signal w_DOUT_REG : STD_LOGIC_VECTOR (N-1 downto 0) := (others => '1');
  signal CLK : STD_LOGIC := '0';
   
begin
 CLOCK_PERIOD: process
begin
CLK <= '0';
wait for 20 ns;
CLK <= '1';
wait for 20 ns;
end process;

-- UUT instance
SHIFT_R_TO_TEST: RX_SHIFT_REGISTER
    generic map(
      N=> N)
    port map(
        -- DATA INPUT
        DATA_IN => r_DATA_IN,
        -- LOAD SHIFT
        LD_SHIFT_REG => r_LD_SHIFT_REG,
        -- CLEAR REGISTER to all 1
        CLEAR_REG => r_CLEAR_REG,
        --CLOCK
        CLK => CLK,

        -- OUTPUT REGISTER PARALLEL
        DOUT_REG => w_DOUT_REG
      );


GEN_SIGN: process
begin
r_DATA_IN <= '0';
r_LD_SHIFT_REG <= '1' ;
r_CLEAR_REG <= '1';
wait for 30 ns;
r_CLEAR_REG <= '0';
wait for 320 ns;
r_DATA_IN <= '1';
wait for 40 ns;
r_LD_SHIFT_REG <= '0';
r_DATA_IN <= '0';
wait;
end process;   
     

 
end behave;