-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 2:1 Mux that can have N valules

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity two2oneData is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_1 : in 	std_logic_vector(N-1 downto 0);
		in_2 : in 	std_logic_vector(N-1 downto 0);
		Sel  : in 	std_logic;
		out_1: out	std_logic_vector(N-1 downto 0));
	
end two2oneData;

architecture dataflow of two2oneData is

begin 

MUXDATA: for i in 0 to N-1 generate
 	
	out_1(i) <=( (not(Sel) and in_1(i) ) or (Sel and in_2(i)) );

end generate;

end dataflow;