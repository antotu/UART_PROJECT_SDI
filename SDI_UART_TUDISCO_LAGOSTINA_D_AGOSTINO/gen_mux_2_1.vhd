library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_mux_2_1 is
  generic(n: positive); 
     port(xs,ys: in std_logic_vector(n-1 downto 0);  
      sl: in std_logic;   
      ms: out std_logic_vector(n-1 downto 0));
end gen_mux_2_1;

architecture beh of gen_mux_2_1 is
    
  component mux_2_1 is  
  port(x,y,s: in std_logic;
    m: out std_logic );
  end component;
  
  begin
    
  a: for i in 0 to n-1 generate   
  muxes: mux_2_1 port map (x => xs(i), y => ys(i), s => sl, m => ms(i)); 
  
  end generate;  
    
end beh;
