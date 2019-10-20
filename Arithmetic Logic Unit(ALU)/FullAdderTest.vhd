-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an 2 versions of the 2:1 MUX 

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity FullAdderTest is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_1 : in 	std_logic_vector(N-1 downto 0);
		in_2 : in 	std_logic_vector(N-1 downto 0);
		C_in : in 	std_logic;
		Sum  : out 	std_logic_vector(N-1 downto 0);
		Sum2  : out 	std_logic_vector(N-1 downto 0);
		C_out: out	std_logic;
		C_out2: out	std_logic);
	
end FullAdderTest;


architecture structure of FullAdderTest is

begin


Struct: entity work.FullAdderStructN port map(in_1,in_2,C_in,Sum, C_out);	--Struct version of MUX
DataFlow: entity work.FullAdderDataN port map(in_1,in_2,C_in,Sum2, C_out2);	--Dataflow version of MUX



end structure;