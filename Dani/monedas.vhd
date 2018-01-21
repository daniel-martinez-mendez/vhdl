
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity monedas is
    Port (
        --ENTRADAS
        SENSOR_MONEDA : in std_logic_vector(5 downto 0);
        --SALIDAS
        VALOR : out integer
    );      
end monedas;

architecture Behavioral of monedas is

begin

		cuenta: process(SENSOR_MONEDA) is
		begin
			case SENSOR_MONEDA is
				when "000001" => 
					VALOR <= 5;
				when "000010" => 
						VALOR <= 10;
				when "000100" => 
						VALOR <= 20;
				when "001000" => 
						VALOR <= 50;
				when "010000" => 
						VALOR <= 100;
				when "100000" => 
						VALOR <= 200;
				when others => 
						VALOR <= 0;
			end case;
		end process cuenta;

end Behavioral;
