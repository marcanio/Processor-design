-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a Dataflow full adder to the N

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdderDataN is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_1 : in 	std_logic_vector(N-1 downto 0);
		in_2 : in 	std_logic_vector(N-1 downto 0);
		C_in : in 	std_logic;
		Sum  : out 	std_logic_vector(N-1 downto 0);
		C_out: out	std_logic);
	
end FullAdderDataN;

architecture dataflow of FullAdderDataN is
signal Carry : std_logic_vector(N-1 downto 0);

begin

Sum(0) <= (in_1(0) xor in_2(0)) xor C_in;
Carry(0) <= ((C_in and (in_1(0) xor in_2(0))) or (in_1(0) and in_2(0)));

FAData: for i in 1 to N-2 generate
 	
	Sum(i) <= (in_1(i) xor in_2(i)) xor Carry(i-1);
	Carry(i) <= ((Carry(i-1) and (in_1(i) xor in_2(i))) or (in_1(i) and in_2(i)));
end generate;
	
	Sum(N-1) <= (in_1(N-1) xor in_2(N-1)) xor Carry(N-2);
	C_out <= ((Carry(N-2) and (in_1(N-1) xor in_2(N-1))) or (in_1(N-1) and in_2(N-1)));

end  dataflow ;