-------------------------------------------------------------------------
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- regFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity regFile is
generic(N : integer := 32);
  port(
	clk,reset,wEnable : in std_logic;
	writeTo, readFrom1, readFrom2 : in std_logic_vector(4 downto 0);
	out_r1,out_r2,v0 : out std_logic_vector(N-1 downto 0);
	writeData : in std_logic_vector(N-1 downto 0));
end regFile;
architecture structure of regFile is
--components
component de5to32
	port(
		in_5 : in std_logic_vector(4 downto 0);
		out_32: out std_logic_vector(31 downto 0));
end component;

component nreg
	port(
		clk,reset,ctl : in std_logic;
		r1 : out std_logic_vector(N-1 downto 0);
		w1 : in std_logic_vector(N-1 downto 0));
end component;

component mux32
	port(
		in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16,in_17,in_18,in_19,in_20,in_21,in_22,in_23,in_24,in_25,in_26,in_27,in_28,in_29,in_30,in_31,in_32 : in std_logic_vector(31 downto 0);
		out_32: out std_logic_vector(31 downto 0);
		sel: in std_logic_vector(4 downto 0));
end component;

component andg2
	port(
		i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);

end component;

type std_array is array (31 downto 0) of std_logic_vector(31 downto 0);
signal regToMux : std_array;
signal wTo,wToReg : std_logic_vector(N-1 downto 0);

begin
	decode : de5to32
	port MAP(in_5 => writeTo,
		 out_32 =>wTo);
G1: for i in 0 to N-1 generate
	andg : andg2
	port MAP(i_A =>wTo(i),
		 i_B =>wEnable,
		 o_F =>wToReg(i));
end generate; 
G2: for i in 0 to N-1 generate
	reg : nreg
	port MAP(clk => clk,
		 reset => reset,
		 ctl => wToReg(i),
		 r1 => regToMux(i),
		 w1 => writeData);
		 
end generate; 
	bigMux1 : mux32
	port MAP(
	in_1 => x"00000000",
	in_2 => regToMux(1),
	in_3 => regToMux(2),
	in_4 => regToMux(3),
	in_5 => regToMux(4),
	in_6 => regToMux(5),
	in_7 => regToMux(6),
	in_8 => regToMux(7),
	in_9 => regToMux(8),
	in_10 => regToMux(9),
	in_11 => regToMux(10),
	in_12 => regToMux(11),
	in_13 => regToMux(12),
	in_14 => regToMux(13),
	in_15 => regToMux(14),
	in_16 => regToMux(15),
	in_17 => regToMux(16),
	in_18 => regToMux(17),
	in_19 => regToMux(18),
	in_20 => regToMux(19),
	in_21 => regToMux(20),
	in_22 => regToMux(21),
	in_23 => regToMux(22),
	in_24 => regToMux(23),
	in_25 => regToMux(24),
	in_26 => regToMux(25),
	in_27 => regToMux(26),
	in_28 => regToMux(27),
	in_29 => regToMux(28),
	in_30 => regToMux(29),
	in_31 => regToMux(30),
	in_32 => regToMux(31),
	sel => readFrom1,
	out_32 => out_r1);

	bigMux2 : mux32
	port MAP(
	in_1 => x"00000000",
	in_2 => regToMux(1),
	in_3 => regToMux(2),
	in_4 => regToMux(3),
	in_5 => regToMux(4),
	in_6 => regToMux(5),
	in_7 => regToMux(6),
	in_8 => regToMux(7),
	in_9 => regToMux(8),
	in_10 => regToMux(9),
	in_11 => regToMux(10),
	in_12 => regToMux(11),
	in_13 => regToMux(12),
	in_14 => regToMux(13),
	in_15 => regToMux(14),
	in_16 => regToMux(15),
	in_17 => regToMux(16),
	in_18 => regToMux(17),
	in_19 => regToMux(18),
	in_20 => regToMux(19),
	in_21 => regToMux(20),
	in_22 => regToMux(21),
	in_23 => regToMux(22),
	in_24 => regToMux(23),
	in_25 => regToMux(24),
	in_26 => regToMux(25),
	in_27 => regToMux(26),
	in_28 => regToMux(27),
	in_29 => regToMux(28),
	in_30 => regToMux(29),
	in_31 => regToMux(30),
	in_32 => regToMux(31),
	sel => readFrom2,
	out_32 => out_r2);
	
	v0 <= regToMux(2);
end structure;