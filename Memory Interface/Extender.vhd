-- 16-bit to 32-bit MIPS Extender

library IEEE;
use IEEE.std_logic_1164.all;


entity Extender16to32 is
	port(	input16           : in std_logic_vector(15 downto 0);     -- 5 Bit input
       		output32          : out std_logic_vector(31 downto 0);
       		extended	  : in std_logic);   -- Enable bit


end  Extender16to32;

architecture behavioral of Extender16to32 is

begin

process(extended, input16)
begin

if ( extended = '0') then
	for i in 16 to 31 loop
		output32(i) <= '0';
	end loop;
	for i in 0 to 15 loop
		output32(i) <= input16(i);
	end loop;
else
	for i in 16 to 31 loop
		output32(i) <= input16(15);
	end loop;
	for i in 0 to 15 loop
		output32(i) <= input16(i);
	end loop;
	
end if;

end process;

end behavioral;