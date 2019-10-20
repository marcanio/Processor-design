-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural full adder

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdderStruct is 
	
	port(	in_1 : in 	std_logic;
		in_2 : in 	std_logic;
		C_in : in 	std_logic;
		Sum  : out 	std_logic;
		C_out: out	std_logic);
	
end FullAdderStruct;

architecture structure of FullAdderStruct is
signal Xor1, and1, and2 : std_logic;

component andg2			--And Gate 
  port(i_A  : in std_logic;
       i_B  : in std_logic;
       o_F  : out std_logic);
end component;

component org2			--Or Gate
  port(i_A   : in std_logic;
       i_B   : in std_logic;
       o_F   : out std_logic);
end component;


component xorg2			--XOr Gate
  port(i_A   : in std_logic;
       i_B   : in std_logic;
       o_F   : out std_logic);
end component;


begin 

  g_Xor1:xorg2
   port MAP(	i_A => 	in_1,
		i_B =>	in_2,
		o_F=>	Xor1);
  g_Xor2:xorg2
   port MAP(	i_A => 	Xor1,
		i_B =>	C_in,
		o_F=>	Sum);
  g_and1:andg2
   port MAP(	i_A => 	Xor1,
		i_B =>	C_in,
		o_F=>	and1);
  g_and2:andg2
   port MAP(	i_A => 	in_1,
		i_B =>	in_2,
		o_F=>	and2);
  g_or1:org2
   port MAP(	i_A => 	and1,
		i_B =>	and2,
		o_F=>	C_out);



end structure;