library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity Debouncer1 is
	Port ( 	D_IN : in std_logic;
				S1, SP : out std_logic;
				clk, reset : in std_logic
			);
end Debouncer1;

architecture Behavioral of Debouncer1 is
	signal QA, QB, Q : std_logic;

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if (reset = '1') then
				QA <= '0';
				QB <= '0';
				Q <= '0';
			else
				QA <= D_IN;
				QB <= QA;
				Q <= QB;
			end if;
		end if;
	end process;

	S1 <= Q;
	SP <= not(QB and not Q);

end Behavioral;