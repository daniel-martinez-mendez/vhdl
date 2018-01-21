----------------------------------------------------------------------------------
 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--use UNISIM.VComponents.all;

entity refrescos is
    Port (
    --ENTRADAS
          CLK           : in std_logic;
          CANCELAR      : in std_logic;
          ACEPTAR       : in std_logic;
          SEL_REFRESCO  : in std_logic_vector(3 downto 0);
          SENSOR_MONEDA : in std_logic_vector(5 downto 0);
    --SALIDAS
          SAL_REFRESCO  : out std_logic_vector(3 downto 0);
          LED_REFRESCO  : out std_logic_vector(3 downto 0);
          SAL_DINERO    : out std_logic;
          SITUACION     : out std_logic_vector(3 downto 0)
          );
    --SITUACIÓN SE REFIERE A 1) LA MAQUINA NOS DICE
    --SU ESTADO       
end refrescos;

architecture Behavioral of refrescos is
    --DECLARAMOS AQUÍ LAS SEÑALES INTERNAS
type ESTADO_MAQUINA is (INICIO, S_REFR, PIDE_DINERO ,SERVIR);
signal PS, NS: ESTADO_MAQUINA; --PRESENT STATE Y NEW STATE
subtype saldo is integer range 0 to 500;
signal dinero : saldo;
constant PRECIO : integer := 150; --Hay que meter el dinero justo
signal ref_elegido : std_logic_vector(3 downto 0) := "0000";
signal ref_pagado  : std_logic;
signal servido     : std_logic;     --señal interna que sabe si ha salido o no el refresco
signal sirviendo_time_count : integer range 0 to 60 := 0;
signal d_devuelto : saldo;

begin
    --DIVIDIMOS EN BLOQUES PARA QUE SE
    --VEA BIEN LA SEPARACIÓN ENTRE BLOQUES
     
    --------------------------------
    --------------------------------
    --------------------------------
REFRESCOS_SEL : block is
begin
    
    seleccion : process(SEL_REFRESCO, CANCELAR) is 
    begin
        if CANCELAR = '1' then ref_elegido <="0000";
        elsif ref_elegido = "0000" and SEL_REFRESCO'event and PS = S_REFR then 
            ref_elegido <= SEL_REFRESCO;
            LED_REFRESCO <= SEL_REFRESCO; --SI NO SE HABIA SELECCIONADO, SE PUEDE SELECCIONAR
        end if;        
    end process seleccion;
    
    check_servido : process (CLK) is
    begin
        if rising_edge(CLK) and PS = SERVIR then sirviendo_time_count <= sirviendo_time_count + 1;
        elsif (sirviendo_time_count = 10) then 
            servido <= '1';
            sirviendo_time_count <= 0;
        end if;
    end process;
    
    salida : process (PS) is
    begin
        if PS = SERVIR then SAL_REFRESCO<=ref_elegido;
        elsif PS = INICIO then ref_elegido <= "0000"; 
        end if;
    end process salida;
end block REFRESCOS_SEL; 
--------------------------------
--------------------------------
--------------------------------
MAQUINA_CAFE : block is
begin


    state_register : process(CANCELAR, CLK) is
    begin
        if CANCELAR = '1' then PS <= INICIO;
        elsif rising_edge(CLK) then PS <= NS;
        end if;
    end process state_register;
    
    next_state: process(PS, CANCELAR, ACEPTAR, SEL_REFRESCO, SENSOR_MONEDA) is
    begin
    NS <= PS; --CONDICION DE MANTENIMIENTO DE ESTADO SI NO SE
              --CUMPLE NINGUN CASO
        case PS is
            when INICIO =>
                if ACEPTAR = '1' then NS<=S_REFR;
                end if;
            when S_REFR =>
                if SEL_REFRESCO'event then NS <= PIDE_DINERO;
                end if;
            when PIDE_DINERO =>
                if ref_pagado = '1' then NS <= SERVIR;
                end if;
            when SERVIR =>
                if servido = '1' then NS <= INICIO;
                end if;
            end case;
    end process next_state;
    ----------------------
    salidas : process(PS) is
    begin
        if CANCELAR = '1' then SAL_DINERO <= '1';
        else SAL_DINERO <= '0';
        end if;
        case PS is
            when INICIO =>
                ref_pagado <= '0';
                SITUACION <= "1000";
            when S_REFR =>
                SITUACION <= "0100";
            when PIDE_DINERO =>
                SITUACION <= "0010";
                if dinero > PRECIO then
                ref_pagado <= '1';
                end if;
            when SERVIR =>
                SITUACION <= "0001";
            end case;
    end process salidas;
    
end block MAQUINA_CAFE;
--------------------------------
--------------------------------
--------------------------------
MONEDAS : block is --tIENE EL CONTADOR DENTRO
begin

    cuenta: process(SENSOR_MONEDA) is
    begin
        case SENSOR_MONEDA is
            when "000001" => 
                dinero <= dinero + 5;
            when "000010" => 
                    dinero <= dinero + 10;
            when "000100" => 
                    dinero <= dinero + 20;
            when "001000" => 
                    dinero <= dinero + 50;
            when "010000" => 
                    dinero <= dinero + 100;
            when "100000" => 
                    dinero <= dinero + 200;
        end case;
    end process cuenta;
    end block MONEDAS;


end Behavioral;
