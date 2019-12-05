library ieee;
use ieee.std_logic_1164.all;

entity registers_stdlogic is

generic(bits : integer := 1);
 
port( 
	  clk       : in  std_logic;
	  reset     : in  std_logic;
	  enable    : in  std_logic;
     d_inputs  : in  std_logic;
	  q_outputs : out std_logic	
    );
end entity;

architecture rtl of registers_stdlogic is
begin
--The input "reset" was not in the sensitivity list - this made it so
--that the reset would not occur until the clock changed.
   process (clk,reset)
   begin
      if (rising_edge(clk)) then
			if reset = '1' then
				q_outputs <= '0';
		   elsif (enable = '1') then
            q_outputs <= d_inputs;
			end if;
      end if;
   end process;

end;
--
--architecture rtl of registers is
--begin
--	process (clk,reset)
--	begin
--	