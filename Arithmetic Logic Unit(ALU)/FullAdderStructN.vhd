-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural full adder to the N

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdderStructN is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_12 : in 	std_logic_vector(N-1 downto 0);
		in_22 : in 	std_logic_vector(N-1 downto 0);
		C_in2 : in 	std_logic;
		Sum2  : out 	std_logic_vector(N-1 downto 0);
		C_out2: out	std_logic);
	
end FullAdderStructN;

architecture structure of FullAdderStructN is
signal Carry : std_logic_vector(N-1 downto 0);

component FullAdderStruct
  port(		in_1 : in 	std_logic;
		in_2 : in 	std_logic;
		C_in : in 	std_logic;
		Sum  : out 	std_logic;
		C_out: out	std_logic);
end component;

begin

 	g_FullAdder:FullAdderStruct
	port MAP(	in_1 => in_12(0),
			in_2 => in_22(0),
			C_in => C_in2,
			Sum  => sum2(0),
			C_out=> Carry(0));

FullAdder: for i in 1 to N-1 generate
	g_FullAdder2:FullAdderStruct
	port MAP(	in_1 => in_12(i),
			in_2 => in_22(i),
			C_in => Carry(i-1),
			Sum  => sum2(i),
			C_out=> Carry(i));
end generate;



C_out2 <= Carry(N-1); 

end structure;