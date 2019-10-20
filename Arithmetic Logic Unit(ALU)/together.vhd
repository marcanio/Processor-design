-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an N bit one's complementer  

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity Onescomp3 is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_1 : in 	std_logic_vector(N-1 downto 0);
		out_1: out	std_logic_vector(N-1 downto 0);
		out_2: out	std_logic_vector(N-1 downto 0));
	
end Onescomp3;


architecture structure of Onescomp3 is

begin

Struct: entity work.Onescomp port map(in_1,out_1);
DataFlow: entity work.Onescomp2 port map(in_1,out_2);



end structure;