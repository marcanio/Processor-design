-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 2:1 Mux that can have N valules

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity two2oneN is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_12 : in 	std_logic_vector(N-1 downto 0);
		in_22 : in 	std_logic_vector(N-1 downto 0);
		Sel2  : in 	std_logic;
		out_12: out	std_logic_vector(N-1 downto 0));
	
end two2oneN;

architecture structure of two2oneN is

component two2one
  port(in_1   : in std_logic;
       in_2   : in std_logic;
       Sel    : in std_logic;
       out_1  : out std_logic);
end component;

begin 

MUXN: for i in 0 to N-1 generate
 	g_mux:two2one
	port MAP(	in_1 => in_12(i),
			in_2 => in_22(i),
			Sel => 	Sel2,
			out_1 => out_12(i));
end generate;

end structure;