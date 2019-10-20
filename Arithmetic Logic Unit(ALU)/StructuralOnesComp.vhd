-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an N bit one's complementer  

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Onescomp is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_1 : in 	std_logic_vector(N-1 downto 0);
		out_1: out	std_logic_vector(N-1 downto 0));
	
end Onescomp;

architecture structure of Onescomp is

component not1				--A Not gate. The input is inverted
  port(in_1  : in std_logic;
       out_1  : out std_logic);
end component;

begin
 
out_1 <= not(in_1);

G1: for i in 0 to N-1 generate
  not_i: not1
	port map(in_1  => in_1(i),
  	          out_1  => out_1(i));
end generate;



end structure;