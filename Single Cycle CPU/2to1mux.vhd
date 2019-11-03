-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 2:1 Mux 

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity two2one is 
	
	port(	in_1 : in 	std_logic;
		in_2 : in 	std_logic;
		Sel  : in 	std_logic;
		out_1: out	std_logic);
	
end two2one;

architecture structure of two2one is
signal Selnot, and1, and2 : std_logic;

component andg2
  port(i_A  : in std_logic;
       i_B   : in std_logic;
       o_F  : out std_logic);
end component;

component invg
  port(i_A   : in std_logic;
       o_F  : out std_logic);
end component;

component org2
  port(i_A   : in std_logic;
       i_B   : in std_logic;
       o_F  : out std_logic);
end component;

begin


  g_not1:invg
   port MAP(	i_A => 	Sel,
		o_F =>Selnot);
  g_and1:andg2
   port MAP(	i_A => 	in_1,
		i_B =>	Sel,
		o_F=>	and1);
  g_and2:andg2
   port MAP(	i_A => 	in_2,
		i_B =>	Selnot,
		o_F=>	and2);

  g_or1:org2
   port MAP(	i_A => 	and1,
		i_B =>	and2,
		o_F=>	out_1);
	

end structure;