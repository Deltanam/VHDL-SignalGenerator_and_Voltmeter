library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity RegisterInt is
	port (SI: in integer;
			Q: out integer;
			clk, EN, reset: in std_logic);
end RegisterInt;

architecture BEHAV of RegisterInt is
	Signal Q_int : integer;

begin
	registerproc: process(clk, reset)
	begin
		if (rising_edge(clk)) then
			if reset = '1' then
			Q_int <= 0;
			elsif (EN = '1') then
				Q_int <= SI;
			else
				Q_int <= Q_int;
			end if;
		end if;
end process;

Q <= Q_int;

end BEHAV;
