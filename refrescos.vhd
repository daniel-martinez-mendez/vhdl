----------------------------------------------------------------------------------
 -- ÁLVARO MARTÍNEZ NOTARIO
 -- DANIEL MARTÍNEZ MÉNDEZ
 -- TERESA RODRÍGUEZ
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
          SENSOR_BEBIDA_LLENA : in std_logic;
    --SALIDAS
          SAL_REFRESCO  : out std_logic_vector(3 downto 0);
          LED_REFRESCO  : out std_logic_vector(3 downto 0);
          SAL_DINERO    : out std_logic;
          SITUACION     : out std_logic_vector(3 downto 0);
          CUENTA_DINERO : out integer range 0 to 500
          );
    --SITUACIÓN SE REFIERE A 1) LA MAQUINA NOS DICE
    --SU ESTADO       
end refrescos;

architecture Behavioral of refrescos is
    --DECLARAMOS AQUÍ LAS SEÑALES INTERNAS
type ESTADO_MAQUINA is (INICIO, S_REFR, SELECCIONANDO, PIDE_DINERO ,SERVIR);
signal PS, NS: ESTADO_MAQUINA; --PRESENT STATE Y NEW STATE
subtype saldo is integer range 0 to 500;
signal dinero : saldo := 0;
constant PRECIO : integer := 150; --Hay que meter el dinero justo
signal last_coin : std_logic; -- Guarda estado de si ha habido flanco de subida de la moneda
signal ref_pedido : std_logic_vector(3 downto 0);
signal servido : std_logic := '0';

begin
    --DIVIDIMOS EN BLOQUES PARA QUE SE
    --VEA BIEN LA SEPARACIÓN
     
--------------------------------
--------------------------------
--------------------------------
MAQUINA_CAFE : block is
begin    
    state_register : process(CANCELAR, CLK) is
    begin
        if CANCELAR = '1' then PS <= INICIO;
        elsif rising_edge(CLK) then 
        PS <= NS;
        end if;
    end process state_register;
    
    next_state: process(PS, servido, ACEPTAR, SEL_REFRESCO, SENSOR_MONEDA) is
    begin

        case PS is
            when INICIO =>
                if ACEPTAR = '1' then NS<=S_REFR;
                end if;
            when S_REFR =>
                if SEL_REFRESCO'event then 
                NS <= SELECCIONANDO;                
                end if;
            when SELECCIONANDO =>
                NS <= PIDE_DINERO;
            when PIDE_DINERO =>
                if dinero>=PRECIO then NS <= SERVIR;
                end if;
            when SERVIR =>
                if servido = '1' then 
                NS <= INICIO;
                end if;
            end case;
    end process next_state;
    ----------------------
    salidas : process(PS, CANCELAR) is
    begin
        if CANCELAR = '1' then SAL_DINERO <= '1';
        else SAL_DINERO <= '0';
        end if;
        case PS is
            when INICIO =>
                LED_REFRESCO <= "0000";
                SAL_REFRESCO <= "0000";        
                SITUACION <= "1000";
            when S_REFR =>                
                SITUACION <= "0100";
            when SELECCIONANDO =>
                LED_REFRESCO <= SEL_REFRESCO;
                ref_pedido <= SEL_REFRESCO; 
            when PIDE_DINERO =>
                SITUACION <= "0010";
            when SERVIR =>
                SAL_REFRESCO <= ref_pedido;
                if(dinero>150) then SAL_DINERO <='1';
                end if;
                SITUACION <= "0001";
            end case;
    end process salidas;
    
end block MAQUINA_CAFE;
--------------------------------
--------------------------------
--------------------------------
SENSOR_BEBIDA : block is
begin
    sincronia : process(CLK) is 
    begin
        if rising_edge(CLK) then 
            if SENSOR_BEBIDA_LLENA = '1' then
                servido <= '1';          
            elsif servido = '1' then
                servido <= '0';
            end if;
        end if;
    end process sincronia;
end block SENSOR_BEBIDA;
--------------------------------
--------------------------------
--------------------------------
MONEDAS : block is --tIENE EL CONTADOR DENTRO
begin

    cuenta: process(CLK) is
    begin
        if rising_edge(CLK) then
            if(SENSOR_MONEDA /= "000000") then last_coin <= '1';
            else last_coin <= '0';
            end if;
            if(last_coin = '0') then
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
                when others   => dinero <=dinero;
            end case;
            end if;
            CUENTA_DINERO <= dinero;
            if PS = INICIO then dinero <= 0;
            end if;
        end if;
    end process cuenta;
    end block MONEDAS;


end Behavioral;
