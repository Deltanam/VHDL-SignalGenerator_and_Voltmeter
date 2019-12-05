library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gen_averager is
	generic(N : integer);
	port (
		  clk   : in  std_logic;
		  EN    : in  std_logic;
		  reset : in  std_logic;
		  Din   : in  std_logic_vector(11 downto 0);
		  Q     : out std_logic_vector(11 downto 0));
	end gen_averager;

architecture rtl of gen_averager is

subtype REG is std_logic_vector(11 downto 0);

type Register_Array is array (natural range <>) of REG;

signal REG_ARRAY : Register_Array(2**N downto 1);



type temporary is array(integer range <>) of integer;
signal tmp : temporary((2**N)-1 downto 1);


signal tmplast : std_logic_vector(2**N-1 downto 0); ---TMPLAST?
--signal tmplast : std_logic_vector(15 downto 0);
signal   zeros : STD_LOGIC_VECTOR(11 downto 0) := "000000000000";


begin


shift_reg : process(clk, reset)
	begin
		if(reset = '1') then
		
			LoopA1: for i in 1 to 2**N loop
				REG_ARRAY(i) <= Zeros;
			end loop LoopA1;
			Q     <= (others => '0');
			
		elsif rising_edge(clk) then
			if EN = '1' then
			
				REG_ARRAY(1) <= Din;
				LoopA2: for i in 1 to 2**N-1 loop
					REG_ARRAY(i+1) <= REG_ARRAY(i);
				end loop LoopA2;
				Q <= tmplast(N+11 downto N); ---TMPLAST?
				
			end if;
		end if;
	end process shift_reg;


LoopB1: for i in 1 to (2**N)/2 generate
	tmp(i) <= to_integer(unsigned(REG_ARRAY((2*i)-1)))  + to_integer(unsigned(REG_ARRAY(2*i)));
end generate LoopB1;

LoopB2: for i in ((2**N)/2)+1 to (2**N)-1 generate
	tmp(i) <= tmp(2*(i-(2**N)/2)-1) + tmp(2*(i-(2**N)/2));
end generate LoopB2;

tmplast <= std_logic_vector(to_unsigned(tmp((2**N)-1), tmplast'length)); ---TMPLAST?
	
	
end rtl;
