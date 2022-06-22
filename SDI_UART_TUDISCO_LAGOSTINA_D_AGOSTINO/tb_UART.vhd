library ieee;
use ieee.std_logic_1164.all;

entity tb_UART is
  
end entity tb_UART;

architecture behavioral of tb_UART is
  
  component UART is
    port(
      RESETn, RxD, ATNACK, R_Wn, CS, clock: in std_logic;
      TxD, ATN: out std_logic;
      DIN: in std_logic_vector(7 downto 0);
      DOUT: out std_logic_vector (7 downto 0);
      ADD: in std_logic_vector(2 downto 0));
  end component;
  
signal CLK, TXD, RXD, rwn, CS, ATN, ATNACK, resetn : std_logic;
signal D_IN, D_OUT : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal ADD: std_logic_vector (2 downto 0);

begin

resetn <= '0', '1' after 25 ns;

CS <= '1' after 65 ns, '0' after 85 ns, '1' after 145 ns, '0' after 165 ns, '1' after 30005 ns, '0' after 30025 ns;
--TXDATA <= "000" , RXDATA <= "001", STAT_REG <= "010", CTRL_REG <= "011"
ADD <= "011" after 65 ns, "000" after 145 ns, "001" after 30005 ns;
D_IN <= "00000011" after 65 ns, "10110011" after 145 ns;
rwn <= '0' after 65 ns, '0' after 145 ns, '1' after 30005 ns;
ATNACK <= '0', '1' after 30055 ns;

--RXD <= '1', '0' after 70 ns, '1' after 2820 ns;

RXD <= TXD;

CLK_GEN: process
begin
CLK <= '1';
wait for 10 ns;
CLK <= '0';
wait for 10 ns;
end process;

--SIGNAL_GEN: process
--begin
--RXD <= '0';
--wait for 2780 ns;
--RXD <= '1';
--wait for 2780 ns;
--end process;


--RXD <= '1';
--wait for 11120 ns;
--RXD <= '0';
--wait for 11120 ns;

DUT: UART port map (
                    RESETn => resetn,
                    RxD => RXD,
                    ATNACK => ATNACK,
                    R_Wn => rwn,
                    CS => CS,
                    clock => CLK,
                    TxD => TXD,
                    ATN => ATN,
                    DIN => D_IN,
                    DOUT => D_OUT,
                    ADD => ADD);
  
  
end behavioral;
