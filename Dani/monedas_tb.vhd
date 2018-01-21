library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

ENTITY monedas_tb IS
END monedas_tb;

ARCHITECTURE BEHAVIORAL OF monedas_tb IS
	COMPONENT monedas
		PORT(
			SENSOR_MONEDA : in std_logic_vector(5 downto 0);
			VALOR : out integer
		);
	END COMPONENT;

	SIGNAL SENSOR_MONEDA : std_logic_vector(5 downto 0);
	SIGNAL VALOR : integer;

	TYPE vtest is record
		SENSOR_MONEDA : std_logic_vector(5 downto 0);
		VALOR : integer;
	END RECORD;
	
	TYPE vtest_vector IS ARRAY (natural RANGE <>) OF vtest;
	
	CONSTANT test: vtest_vector := (
		(SENSOR_MONEDA => "000001", VALOR => 5),
		(SENSOR_MONEDA => "000010", VALOR => 10),
		(SENSOR_MONEDA => "000100", VALOR => 20),
		(SENSOR_MONEDA => "001000", VALOR => 50),
		(SENSOR_MONEDA => "010000", VALOR => 100),
		(SENSOR_MONEDA => "100000", VALOR => 200),
		(SENSOR_MONEDA => "111111", VALOR => 0),
		(SENSOR_MONEDA => "101010", VALOR => 0),
		(SENSOR_MONEDA => "010101", VALOR => 0)
	);
	
	BEGIN
		uut: monedas PORT MAP(
			SENSOR_MONEDA => SENSOR_MONEDA,
			VALOR => VALOR
		);
		
		tb: PROCESS
		BEGIN
			FOR i IN 0 TO test'HIGH LOOP
				SENSOR_MONEDA <= test(i).SENSOR_MONEDA;
				WAIT FOR 20 ns;
				ASSERT VALOR = test(i).VALOR
					REPORT "Salida incorrecta."
					SEVERITY FAILURE;
			END LOOP;
			
			ASSERT false
				REPORT "Simulación finalizada. Test superado."
				SEVERITY FAILURE;
		END PROCESS;
END BEHAVIORAL;