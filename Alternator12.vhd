library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
 
entity Alternator_12 is
    Port ( reset : in STD_LOGIC;
           clk : in STD_LOGIC; -- clk is >> than 1 kHz, i.e. 100kHz and above
           EN :  in STD_LOGIC;
			  Max : in STD_LOGIC_VECTOR(11 downto 0);
           Duty_Cycle_out : out STD_LOGIC_VECTOR(11 downto 0)
          );
end Alternator_12;

architecture Behavioral of Alternator_12 is
	signal altbit : STD_LOGIC_VECTOR(0 downto 0) := "0";
	constant zeros : STD_LOGIC_VECTOR(11 downto 0) := "000000000000";
	
	
BEGIN

	with altbit select Duty_Cycle_out <=
		zeros when "0",
		Max when "1",
		zeros when others;

	count : process(clk, reset)
       begin
            if(reset = '1') then
                altbit <= "0";
            elsif (rising_edge(clk)) then 
                if (EN = '1') then
                        altbit <= altbit + '1';                                        
                end if;
            end if;
    end process;
	
END Behavioral;