
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library UNISIM;
--use UNISIM.VComponents.all;

entity hielos is
    Port (
        --ENTRADAS
        MAS_HIELO : in std_logic;
		MENOS_HIELO : in std_logic;
		HIELO_ACTUAL : in std_logic_vector(3 downto 0);
        --SALIDAS
        HIELO_FINAL : out std_logic_vector(3 downto 0)
    );
end hielos;

architecture Behavioral of hielos is

begin

		add_hielo: process(MAS_HIELO) is
		begin
			if MAS_HIELO = '1' then
				case HIELO_ACTUAL is
					when "0000" => 
							HIELO_FINAL <= "1000";
					when "1000" => 
							HIELO_FINAL <= "1100";
					when "1100" => 
							HIELO_FINAL <= "1110";
					when "1110" => 
							HIELO_FINAL <= "1111";
					when others => 
							HIELO_FINAL <= HIELO_ACTUAL;
				end case;
			end if;
		end process add_hielo;

		del_hielo: process(MENOS_HIELO) is
		begin
			if MENOS_HIELO = '1' then
				case HIELO_ACTUAL is
					when "1111" =>
							HIELO_FINAL <= "1110";
					when "1110" =>
							HIELO_FINAL <= "1100";
					when "1100" =>
							HIELO_FINAL <= "1000";
					when "1000" =>
							HIELO_FINAL <= "0000";
					when others =>
							HIELO_FINAL <= HIELO_ACTUAL;
				end case;
			end if;
		end process del_hielo;

end Behavioral;
