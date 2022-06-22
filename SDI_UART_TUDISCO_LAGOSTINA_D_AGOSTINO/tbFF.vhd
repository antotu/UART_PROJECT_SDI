library ieee;
use ieee.std_logic_1164.all;

entity tbFF is
  
end entity tbFF;

architecture behavior of tbFF is
  
  component FF is
    port (data_in: in std_logic;
		    CLK, reset, enable: in std_logic;
		    data_out: out std_logic);
  end component;
  
  signal clock, d_i, d_o, rst, en : std_logic;
  
begin
  
  clock_gen: process
  begin
    clock <= '1';
    wait for 62.5 ns;
    clock <= '0';
    wait for 62.5 ns;
  end process clock_gen;
  
  d_i <= '1';
  rst <= '0', '1' after 200 ns;
  en <= '0', '1' after 350 ns;
  
DUT: FF port map(data_in => d_i, CLK => clock, reset => rst, enable => en, data_out => d_o);
  
end behavior;