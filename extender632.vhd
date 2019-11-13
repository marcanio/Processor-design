---- 16 to 32 zero or sign extend dec---
library IEEE;
use IEEE.std_logic_1164.all;
entity extender632  is
	port(inp : in std_logic_vector(15 downto 0);
	     ctrl : in std_logic;
	     outp : out std_logic_vector(31 downto 0));
end extender632;

architecture ericsaysyoucanuseanythinghere of extender632 is

begin

process(inp,ctrl)

begin
	if(ctrl = '0') then
		for i in 16 to 31 loop
			outp(i) <='0';
		end loop;
		for i in 0 to 15 loop
			outp(i) <= inp(i);
		end loop;
	else
		for i in 16 to 31 loop
			outp(i) <=inp(15);
		end loop;
		for i in 0 to 15 loop
			outp(i) <= inp(i);
		end loop;
	end if;
end process;
end ericsaysyoucanuseanythinghere;