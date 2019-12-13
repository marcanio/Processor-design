---- Set less than 32b ---
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity setLessThan32b is
	port(inputA,inputB : in std_logic_vector(31 downto 0);
	     sel : in std_logic;
	     output : out std_logic);
end setLessThan32b;

architecture processor of setLessThan32b is


begin

	process(inputA,inputB,sel)
		begin
		if(signed(inputA)<signed(inputB)) and sel='1' then
			output <= '1';
		elsif(unsigned(inputA)<unsigned(inputB)) and sel ='0' then
			output <= '1';
		else
			output <= '0';
		end if;
	end process;
end processor;