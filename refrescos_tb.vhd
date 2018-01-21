
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity refrescos_tb is
end refrescos_tb;

architecture Behavioral of refrescos_tb is
--COMPONENTES
component refrescos
    Port(
    --ENTRADAS
              CLK           : in std_logic;
              CANCELAR      : in std_logic;
              ACEPTAR       : in std_logic;
              SEL_REFRESCO  : in std_logic_vector(3 downto 0);
              SENSOR_MONEDA : in std_logic_vector(5 downto 0);
              SENSOR_BEBIDA_LLENA : in std_logic;
        --SALIDAS
              SAL_REFRESCO  : out std_logic_vector(3 downto 0);
              LED_REFRESCO  : out std_logic_vector(3 downto 0);
              SAL_DINERO    : out std_logic;
              SITUACION     : out std_logic_vector(3 downto 0);
              CUENTA_DINERO : out integer range 0 to 500
              );
end component;
--SEÑALES DE ENTRADA
signal clk              : std_logic := '0';
signal cancelar         : std_logic := '0';
signal aceptar          : std_logic := '0';
signal sel_refresco     : std_logic_vector(3 downto 0) := (others => '0');
signal sensor_moneda    : std_logic_vector(5 downto 0) := (others => '0');
signal sensor_bebida_llena : std_logic := '0';
--SEÑALES DE SALIDA
signal sal_refresco     : std_logic_vector(3 downto 0);
signal led_refresco     : std_logic_vector(3 downto 0);
signal sal_dinero       : std_logic :='0';
signal situacion        : std_logic_vector(3 downto 0);
signal cuenta_dinero    : integer range 0 to 500;
constant clk_period: time := 10 us;  
begin
-- DAMOS VALORES INICIALES


--EMPEZAMOS EL UUT

    uut: refrescos
        port map(
        --ENTRADAS
        CLK           =>    clk          ,
        CANCELAR      =>    cancelar     ,
        ACEPTAR       =>    aceptar      ,
        SEL_REFRESCO  =>    sel_refresco ,
        SENSOR_MONEDA =>    sensor_moneda,
        SENSOR_BEBIDA_LLENA => sensor_bebida_llena,
        --SALIDAS
        SAL_REFRESCO  =>    sal_refresco ,
        LED_REFRESCO  =>    led_refresco ,
        SAL_DINERO    =>    sal_dinero   ,
        SITUACION     =>    situacion    ,
        CUENTA_DINERO =>    cuenta_dinero
        );
        
  clk_process :process
    begin
    clk <= '0';
    wait for 0.5 * clk_period;
    clk <= '1';
    wait for 0.5 * clk_period;
  end process;        

    --INICIAMOS EL TESTBENCH AQUÍ
    estimulos : process
    begin

    aceptar <= '1';
    wait for 2*clk_period;
    aceptar <= '0';
    sel_refresco <= "0100";
    wait for 2*clk_period;
    sel_refresco <= "0000";
    wait for 2*clk_period;
    sensor_moneda <= "010000";
    wait for 2*clk_period;
    sensor_moneda <= "000000";
    wait for 2*clk_period;
    sensor_moneda <= "010000";
    wait for 2 *clk_period;
    sensor_moneda <= "000000";   
    wait for 2 *clk_period; 
    sensor_bebida_llena <= '1';
    wait for 2* clk_period;
    sensor_bebida_llena <= '0';
    wait for 2*clk_period;
    aceptar <= '1';
    wait for 2*clk_period;
    aceptar <= '0';
    sel_refresco <= "0001";
    wait for 2*clk_period;
    sel_refresco <= "0000";
    cancelar <= '1';
    wait for 2*clk_period;
    assert false
      report "Acaba la simulacion"
      severity failure;
    end process;
end Behavioral;
