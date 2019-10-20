-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION:Second MIPS Application 

-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity MIPSProcessor2 is 
	
	port(	Rd1,Rd2	 : in 	std_logic_vector(4 downto 0);
		W_addr	 : in 	std_logic_vector(4 downto 0);
		CLK	 : in 	std_logic;
		Reset	 : in 	std_logic;
		Enable   : in	std_logic;
		nAdd_Sub : in 	std_logic;
		ALUSrc	 : in 	std_logic;
		Extended : in   std_logic;
		load	 : in   std_logic;
		Immd	 : in 	std_logic_vector(15 downto 0);
		test	 : out	std_logic_vector(31 downto 0)
	);
		
end MIPSProcessor2;

architecture structure of MIPSProcessor2 is

component RegFile32
 port	(
	I_clk 		: in std_logic; 			--Clock
	Enable		: in std_logic;
	Reset		: in std_logic;				--Reset for the resgister
	Rd1 , Rd2 	: in STD_LOGIC_VECTOR (4 DOWNTO 0);	--Read address
	W_addr 		: in STD_LOGIC_VECTOR (4 DOWNTO 0);	--Write Address
	W_data 		: in STD_LOGIC_VECTOR (31 DOWNTO 0);	--Write Data
	R_data1, R_data2: out std_logic_vector(31 DOWNTO 0));	
end component;

component Extender16to32
 port	(	
	input16          : in std_logic_vector(15 downto 0);     -- 5 Bit input
       	output32         : out std_logic_vector(31 downto 0);
       	extended	 : in std_logic);   -- Enable bit
end component;

component AdderSubALU
 port	(	
	A,B	 	: in 	std_logic_vector(31 downto 0);
	nAdd_Sub	: in 	std_logic;
	ALUSrc		: in 	std_logic;
	Immed		: in 	std_logic_vector(31 downto 0);
	C_out   	: out  std_logic;
	Sum  		: out 	std_logic_vector(31 downto 0));
end component;

component mem
port 	(
	clk		: in std_logic;
	addr	        : in std_logic_vector((9) downto 0);
	data	        : in std_logic_vector((31) downto 0);
	we		: in std_logic := '1';
	q		: out std_logic_vector((31) downto 0)
	);
end component;

component two2oneN
port	(	
	in_12 		: in 	std_logic_vector(31 downto 0);
	in_22 		: in 	std_logic_vector(31 downto 0);
	Sel2  		: in 	std_logic;
	out_12		: out	std_logic_vector(31 downto 0));
end component;

signal RegOut1, RegOut2, ExtenderOut, ALUout, MemOut, MuxOut : std_logic_vector(31 downto 0);
signal C_outNone, NotEnable : std_logic;
begin

NotEnable <= not (Enable);
test <= MuxOut;

G_RegFile : RegFile32
port map(
	I_clk	=> CLK,
	Enable	=> NotEnable,
	Reset	=> Reset,
	Rd1	=> Rd1,
	Rd2	=> Rd2,
	W_addr	=> W_addr,
	W_data	=> MuxOut,
	R_data1 => RegOut1,
	R_data2	=> RegOut2 );

G_Extend : Extender16to32
port map(
	input16	=> Immd,
	extended=> Extended,
	output32=> ExtenderOut );

G_AdderSub : AdderSubALU
port map(
	A	=> RegOut1,
	B	=> RegOut2,
	nAdd_Sub=> nAdd_Sub,
	ALUSrc	=> ALUSrc,
	Immed	=> ExtenderOut,
	C_out	=> C_outNone,
	Sum	=> ALUout );

G_mem : mem
port map(
	clk	=> CLK,
	addr	=> ALUout(9 downto 0),
	data	=> RegOut2,
	we	=> Enable,
	q	=> MemOut );

G_Mux : two2oneN
port map(
	in_12	=> ALUout,
	in_22	=> MemOut,
	Sel2	=> load,
	out_12	=> MuxOut );
	





end structure;























