-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural Adder/ subtractor with a control to select either

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity AdderSub is 
	generic(N : integer := 0);	--Used to simulate a number, N
	port(	A,B	 : in 	std_logic_vector(N downto 0);
		nAdd_Sub : in 	std_logic;
		C_out    : out std_logic;
		Sum  	 : out 	std_logic_vector(N downto 0));
	
end AdderSub;

architecture structure of AdderSub is

component FullAdderStructN
  generic(N : integer);
  port(		in_12 : in 	std_logic_vector(N-1 downto 0);
		in_22 : in 	std_logic_vector(N-1 downto 0);
		C_in2 : in 	std_logic;
		Sum2  : out 	std_logic_vector(N-1 downto 0);
		C_out2: out	std_logic);
  end component;
  
component Onescomp2
  generic(N : integer);
  port(		in_1 : in 	std_logic_vector(N-1 downto 0);
		out_1: out	std_logic_vector(N-1 downto 0));
  end component;

component two2oneData
  generic(N : integer);
  port(		in_1 : in 	std_logic_vector(N-1 downto 0);
		in_2 : in 	std_logic_vector(N-1 downto 0);
		Sel  : in 	std_logic;
		out_1: out	std_logic_vector(N-1 downto 0));
  end component;

signal notB : std_logic_vector(N-1 downto 0);	--This the opposite of A
signal B_add : std_logic_vector(N-1 downto 0);	--This is the value of A that is picked by the user to add or subtract

begin

invert : Onescomp2
  generic map(N=>N)
  port map(in_1  => B,
           out_1 => notB);

mux : two2oneData
  generic map(N=>N)
  port map(in_1  => B,
           in_2  => notB,
           Sel   => nAdd_Sub,
           out_1 => B_add);

FullAdder : FullAdderStructN
  generic map(N=>N)
  port map(in_12 => A,
           in_22 => B_add,
           C_in2 => nAdd_Sub,
           Sum2 => Sum,
           C_out2 => C_out);


           
end structure;