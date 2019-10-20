-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural Adder/ subtractor with a control to select from adding immediate to adding a value you enter

-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity AdderSubALU is 
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	A,B	 : in 	std_logic_vector(N-1 downto 0);
		nAdd_Sub : in 	std_logic;
		ALUSrc	 : in 	std_logic;
		Immed	 : in 	std_logic_vector(N-1 downto 0);
		C_out    : out std_logic;
		Sum  	 : out 	std_logic_vector(N-1 downto 0));
	
end AdderSubALU;


architecture structure of AdderSubALU is

component AdderSub
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	A,B	 : in 	std_logic_vector(N-1 downto 0);
		nAdd_Sub : in 	std_logic;
		C_out    : out std_logic;
		Sum  	 : out 	std_logic_vector(N-1 downto 0));
end component;

component two2oneN
	generic(N : integer := 32);	--Used to simulate a number, N
	port(	in_12 : in 	std_logic_vector(N-1 downto 0);
		in_22 : in 	std_logic_vector(N-1 downto 0);
		Sel2  : in 	std_logic;
		out_12: out	std_logic_vector(N-1 downto 0));
end component;
signal muxoutput : std_logic_vector(31 downto 0);
begin

G_mux : two2oneN
	generic map(N=>N)
	port map(in_12	=> Immed,
		 in_22  => B,
		 Sel2   => ALUSrc,
		 out_12 => muxoutput);

G_AdderSub : AdderSub
	generic map(N=>N)
	port map(A	=>  A,
		 B	=>  muxoutput,
		 nAdd_Sub=> nAdd_Sub,
		 C_out	=>  C_out,
		 Sum	=>  Sum);

	


end structure;