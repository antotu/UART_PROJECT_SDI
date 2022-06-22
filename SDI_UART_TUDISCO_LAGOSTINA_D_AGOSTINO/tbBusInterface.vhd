library ieee;
use ieee.std_logic_1164.all;

entity tbBusInterface is
  
end entity tbBusInterface;

architecture behavioral of tbBusInterface is
  
  component BusInterface is
    port(
      resetn: in std_logic;
    --segnali scambiati con l'esterno della UART
      CLK: in std_logic;
      CS: in std_logic;
      A: in std_logic_vector(2 downto 0);
      DIN: in std_logic_vector(7 downto 0);
      DOUT: out std_logic_vector(7 downto 0);
      R_Wn, ATNACK: in std_logic;
      ATN: out std_logic;
    --segnali scambiati con RX e TX
      PRX: in std_logic_vector(7 downto 0);             --dato ottenuto da RX
      RX_DONE, RX_BUSY, RX_ERR, TX_DONE: in std_logic;  --segnali di stato
      PTX: out std_logic_vector(7 downto 0);            --dato da inviare tramite TX
      TX_EN, RX_EN, START_TX: out std_logic);
  end component;
  
  signal clock, rst, cs, rwn, atnack, atn, rxD, rxB, rxE, txD, txEN, rxEN, txST : std_logic;
  
  signal add: std_logic_vector(2 downto 0);
  signal d_i, d_o, d_rx, d_tx: std_logic_vector(7 downto 0);
  
  begin
    
    clock_gen: process
  begin
    clock <= '1';
    wait for 62.5 ns;
    clock <= '0';
    wait for 62.5 ns;
  end process clock_gen;
    
    rst <= '0', '1' after 150 ns;
    cs <= '0', '1' after 300 ns, '0' after 430 ns, '1' after 520 ns, '0' after 650 ns, '1' after 800 ns, '0' after 930 ns, '1' after 1400 ns, '0' after 1530 ns;
    add <= "000","001" after 300 ns,"010" after 520 ns, "000" after 800 ns, "011" after 1400 ns;
    rwn <= '0', '1' after 300 ns, '1' after 520 ns, '0' after 800 ns, '0' after 1400 ns;
    d_i <= "00000000","10101100" after 800 ns, "00000111" after 1400 ns;
    atnack <= '0','1' after 400 ns, '0' after 600 ns;
    d_rx <= "00110011";
    txD <= '0', '1' after 200 ns;
    rxB <= '1', '0' after 1000 ns;
    rxD <= '0', '1' after 1000 ns;
    rxE <= '0';
    
    DUT: BusInterface port map (resetn => rst, 
                  CLK => clock,
                  CS => cs,
                  A => add, 
                  DIN => d_i, 
                  DOUT => d_o, 
                  R_Wn => rwn, 
                  ATNACK => atnack, 
                  ATN => atn, 
                  PRX => d_rx, 
                  RX_DONE => rxD, 
                  RX_BUSY => rxB, 
                  RX_ERR => rxE, 
                  TX_DONE => txD, 
                  PTX => d_TX, 
                  TX_EN => txEN, 
                  RX_EN => rxEN,
                  START_TX => txST);
    
end behavioral;