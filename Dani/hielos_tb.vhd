library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;

ENTITY hielos_tb IS
END hielos_tb;

ARCHITECTURE BEHAVIORAL OF hielos_tb IS
	COMPONENT hielos
		PORT(
			MAS_HIELO : in std_logic;
			MENOS_HIELO : in std_logic;
			HIELO_ACTUAL : in std_logic_vector(3 downto 0);
			HIELO_FINAL : out std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	SIGNAL MAS_HIELO : std_logic;
	SIGNAL MENOS_HIELO : std_logic;
	SIGNAL HIELO_ACTUAL : std_logic_vector(3 downto 0);
	SIGNAL HIELO_FINAL : std_logic_vector(3 downto 0);

	TYPE vtest is record
		MAS_HIELO : std_logic;
		MENOS_HIELO : std_logic;
		HIELO_ACTUAL : std_logic_vector(3 downto 0);
		HIELO_FINAL : std_logic_vector(3 downto 0);
	END RECORD;
	
	TYPE vtest_vector IS ARRAY (natural RANGE <>) OF vtest;
	
	CONSTANT test: vtest_vector := (
		(MAS_HIELO => '1', MENOS_HIELO => '0', HIELO_ACTUAL => "0000", HIELO_FINAL => "1000"),
		(MAS_HIELO => '1', MENOS_HIELO => '0', HIELO_ACTUAL => "1000", HIELO_FINAL => "1100"),
		(MAS_HIELO => '1', MENOS_HIELO => '0', HIELO_ACTUAL => "1100", HIELO_FINAL => "1110"),
		(MAS_HIELO => '1', MENOS_HIELO => '0', HIELO_ACTUAL => "1110", HIELO_FINAL => "1111"),
		(MAS_HIELO => '1', MENOS_HIELO => '0', HIELO_ACTUAL => "1111", HIELO_FINAL => "1111"),
		(MAS_HIELO => '0', MENOS_HIELO => '1', HIELO_ACTUAL => "1111", HIELO_FINAL => "1110"),
		(MAS_HIELO => '0', MENOS_HIELO => '1', HIELO_ACTUAL => "1110", HIELO_FINAL => "1100"),
		(MAS_HIELO => '0', MENOS_HIELO => '1', HIELO_ACTUAL => "1100", HIELO_FINAL => "1000"),
		(MAS_HIELO => '0', MENOS_HIELO => '1', HIELO_ACTUAL => "1000", HIELO_FINAL => "0000"),
		(MAS_HIELO => '0', MENOS_HIELO => '1', HIELO_ACTUAL => "0000", HIELO_FINAL => "0000")
	);
	
	BEGIN
		uut: hielos PORT MAP(
			MAS_HIELO => MAS_HIELO,
			MENOS_HIELO => MENOS_HIELO,
			HIELO_ACTUAL => HIELO_ACTUAL,
			HIELO_FINAL => HIELO_FINAL
		);
		
		tb: PROCESS
		BEGIN
			FOR i IN 0 TO test'HIGH LOOP
				MAS_HIELO <= test(i).MAS_HIELO;
				MENOS_HIELO <= test(i).MENOS_HIELO;
				HIELO_ACTUAL <= test(i).HIELO_ACTUAL;
				WAIT FOR 20 ns;
				ASSERT HIELO_FINAL = test(i).HIELO_FINAL
					REPORT "Salida incorrecta."
					SEVERITY FAILURE;
			END LOOP;
			
			ASSERT false
				REPORT "Simulación finalizada. Test superado."
				SEVERITY FAILURE;
		END PROCESS;
END BEHAVIORAL;