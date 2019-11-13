library IEEE;
use IEEE.std_logic_1164.all;

entity Mux is
	port( inputa : in std_logic;
	      inputb : in std_logic;
	      selector : in std_logic;
	      output : out std_logic);

end Mux;

architecture structure of Mux is
signal selNot, anda,andb : std_logic;
component andg2
	port(i_A : in std_logic;
	     i_B : in std_logic;
	     o_F : out std_logic);
end component;
component org2
	port(i_A : in std_logic;
	     i_B : in std_logic;
	     o_F : out std_logic);
end component;
component invg
	port(i_A : in std_logic;
	     o_F : out std_logic);
end component;
begin
	g_not : invg
		port MAP(i_A => selector,
			 o_F => selNot);
	g_and1 : andg2
		port MAP(i_A => inputa,
			 i_B => selNot,
			 o_F => anda);
	g_and2 : andg2
		port MAP(i_A => inputb,
			 i_B => selector,
			 o_F => andb);
	g_or : org2
		port MAP(i_A => anda,
			 i_B => andb,
			 o_F => output);
end structure;
