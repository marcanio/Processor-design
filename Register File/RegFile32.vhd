-- THis is a register to the N
library IEEE;
use IEEE.std_logic_1164.all;

Entity RegFile32 is 
PORT	(
	I_clk 		: in std_logic; 			--Clock
	Enable		: in std_logic;
	Reset		: in std_logic;				--Reset for the resgister
	Rd1 , Rd2 	: in STD_LOGIC_VECTOR (4 DOWNTO 0);	--Read address
	W_addr 		: in STD_LOGIC_VECTOR (4 DOWNTO 0);	--Write Address
	W_data 		: in STD_LOGIC_VECTOR (31 DOWNTO 0);	--Write Data
	R_data1, R_data2: out std_logic_vector(31 DOWNTO 0));	

End RegFile32;


architecture structure of RegFile32 is

signal DecodeSig : std_logic_vector(31 downto 0);
type MainDataType is array (31 downto 0) of std_logic_vector(31 downto 0);	--32 by 32 Array 
signal MainData  : MainDataType ;					--Name of array-MainData
component RegisterN
  port(CLK        : in std_logic;     -- Clock input
       RST        : in std_logic;     -- Reset input
       WE         : in std_logic;     -- Write enable input
       D          : in std_logic_vector(31 downto 0);     	-- Data value input
       Q          : out std_logic_vector(31 downto 0));   	-- Data value output
end component;

component Mux32to1
 port(in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32        : in std_logic_vector(31 downto 0);     -- 5 Bit input
       output32   : out std_logic_vector(31 downto 0);		-- 32 Bit output
       selector	  : in std_logic_vector(4 downto 0));  		-- Enable bit
end component;

component Decoder5to32
 port( input5           : in std_logic_vector(4 downto 0);    	-- 5 Bit input
       output32         : out std_logic_vector(31 downto 0);	-- 32 Bit output
       enable		: in std_logic);   			-- Enable bit
end component;

begin


g_Decoder:Decoder5to32
	port MAP(	input5	=> W_addr,
			output32=> DecodeSig,
			enable 	=> enable);

RegisterN1: for i in 0 to 31 generate

g_RegisterN: RegisterN
	port MAP(	CLK	=> I_clk,
			RST	=> Reset,
			WE	=> DecodeSig(i),
			D	=> W_data,
			Q	=> MainData(i));
end generate;

g_Mux32to1: Mux32to1
	port Map(	in1	=>MainData(0),
			in2	=>MainData(1),
			in3	=>MainData(2),
			in4	=>MainData(3),
			in5	=>MainData(4),
			in6	=>MainData(5),
			in7	=>MainData(6),
			in8	=>MainData(7),
			in9	=>MainData(8),
			in10	=>MainData(9),
			in11	=>MainData(10),
			in12	=>MainData(11),
			in13	=>MainData(12),
			in14	=>MainData(13),
			in15	=>MainData(14),
			in16	=>MainData(15),
			in17	=>MainData(16),
			in18	=>MainData(17),
			in19	=>MainData(18),
			in20	=>MainData(19),
			in21	=>MainData(20),
			in22	=>MainData(21),
			in23	=>MainData(22),
			in24	=>MainData(23),
			in25	=>MainData(24),
			in26	=>MainData(25),
			in27	=>MainData(26),
			in28	=>MainData(27),
			in29	=>MainData(28),
			in30	=>MainData(29),
			in31	=>MainData(30),
			in32	=>MainData(31),
			output32=> R_data1,
			selector=> Rd1 );
g_Mux32to1_2: Mux32to1
	port Map(	in1	=>MainData(0),
			in2	=>MainData(1),
			in3	=>MainData(2),
			in4	=>MainData(3),
			in5	=>MainData(4),
			in6	=>MainData(5),
			in7	=>MainData(6),
			in8	=>MainData(7),
			in9	=>MainData(8),
			in10	=>MainData(9),
			in11	=>MainData(10),
			in12	=>MainData(11),
			in13	=>MainData(12),
			in14	=>MainData(13),
			in15	=>MainData(14),
			in16	=>MainData(15),
			in17	=>MainData(16),
			in18	=>MainData(17),
			in19	=>MainData(18),
			in20	=>MainData(19),
			in21	=>MainData(20),
			in22	=>MainData(21),
			in23	=>MainData(22),
			in24	=>MainData(23),
			in25	=>MainData(24),
			in26	=>MainData(25),
			in27	=>MainData(26),
			in28	=>MainData(27),
			in29	=>MainData(28),
			in30	=>MainData(29),
			in31	=>MainData(30),
			in32	=>MainData(31),
			output32=> R_data2,
			selector=> Rd2 );

		


end structure;