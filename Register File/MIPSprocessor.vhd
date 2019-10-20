-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural Adder/ subtractor with a control to select from adding immediate to adding a value you enter

-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity MIPSProcessor is 
	port(	CLK	 : in 	std_logic; --
		rA,rB	 : in 	std_logic_vector(4 downto 0); 
		nAdd_Sub1 : in 	std_logic; --
		ALUSrc1	 : in 	std_logic; --
		Reset1	 : in 	std_logic; --
		Enable1	 : in	std_logic; -- not needed but implemeted for testing purposes (Enable bit)
		Immed1	 : in 	std_logic_vector(31 downto 0); 
		W_addr1   : in 	std_logic_vector(4 downto 0)); 
	
end MIPSProcessor;

architecture structure of MIPSProcessor is

component RegFile32
PORT	(	I_clk 		: in std_logic; 			--Clock
		Enable		: in std_logic;
		Reset		: in std_logic;				--Reset for the resgister
		Rd1 , Rd2 	: in STD_LOGIC_VECTOR (4 DOWNTO 0);	--Read address
		W_addr 		: in STD_LOGIC_VECTOR (4 DOWNTO 0);	--Write Address
		W_data 		: in STD_LOGIC_VECTOR (31 DOWNTO 0);	--Write Data
		R_data1, R_data2: out std_logic_vector(31 DOWNTO 0));				--Rt and RS
end component;

component AdderSubALU
port(		A,B	 : in 	std_logic_vector(31 downto 0);
		nAdd_Sub : in 	std_logic;
		ALUSrc	 : in 	std_logic;
		Immed	 : in 	std_logic_vector(31 downto 0);
		C_out    : out std_logic;
		Sum  	 : out 	std_logic_vector(31 downto 0));
	
end component;
signal AdderSubOut: std_logic_vector(31 downto 0);
signal rd1_a, rd2_b : std_logic_vector(31 downto 0);
signal C_out1 : std_logic;
begin
g_Reg: RegFile32
	port MAP(	I_clk	=> CLK,  	--
			Enable	=> Enable1,	--
			Reset	=> Reset1,	--	
			Rd1	=> rA,		--	
			Rd2	=> rB,		--
			w_addr	=> W_addr1,	--
			W_data	=> AdderSubOut,	--
			R_data1	=> rd1_a,	
			R_data2 => rd2_b );

g_AdderSub : AdderSubALU
	port MAP(	A	=> rd1_a,
			B	=> rd2_b,
			nAdd_Sub=> nAdd_Sub1,
			ALUSrc	=> ALUsrc1,
			Immed	=> Immed1,
			C_out	=> C_out1,
			Sum	=> AdderSubOut);


end structure;