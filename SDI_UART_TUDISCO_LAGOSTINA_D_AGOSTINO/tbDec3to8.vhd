library ieee;
use ieee.std_logic_1164.all;

entity tbDec3to8 is
  
end entity tbDec3to8;

architecture behavior of tbDec3to8 is
  
  component Dec3to8 is
    port(
    in_data: in std_logic_vector(2 downto 0);
    out_data: out std_logic_vector(7 downto 0));
  end component;
  
  signal d_i: std_logic_vector(2 downto 0);
  signal d_o: std_logic_vector(7 downto 0);
  
begin 
  
  d_i <= "000", "001" after 20 ns, "010" after 30 ns, "011" after 40 ns, "100" after 50 ns, "101" after 60 ns, "110" after 70 ns, "111" after 80 ns;
  
  DUT: Dec3to8 port map(in_data => d_i, out_data => d_o);
  
end behavior;
