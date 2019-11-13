-- Quartus Prime VHDL Template
-- Single-port RAM with single read/write address

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
	generic 
	(
		N : natural := 32;
		ADDR_WIDTH : natural := 10
	);
	port 
	(
		clk,reset,store,extSel,load,aluSrc	: in std_logic;
		writeTo,readFrom1,readFrom2, shiftSize    : in std_logic_vector(4 downto 0);
		sel : in std_logic_vector(3 downto 0);
		immediate	        : in std_logic_vector(15 downto 0);
		shiftCtrl : in std_logic_vector(1 downto 0);
		muxOut : out std_logic_vector(N-1 downto 0);
		overflow,zero : out std_logic
	);

end processor;
architecture structure of processor is
--components
component regFile
	port(
	clk,reset,wEnable : in std_logic;
	writeTo, readFrom1, readFrom2 : in std_logic_vector(4 downto 0);
	out_r1,out_r2 : out std_logic_vector(N-1 downto 0);
	writeData : in std_logic_vector(N-1 downto 0));
end component;

component alu32
	port(
	     	inA,inB : in std_logic_vector(N-1 downto 0);
	     	sel : in std_logic_vector(3 downto 0);
		shiftSize : in std_logic_vector(4 downto 0);
		shiftCtrl : in std_logic_vector(1 downto 0);
	     	overflow, carryOut, zero : out std_logic;
		o_F : out std_logic_vector(N-2+1 downto 0));
end component;

component mem
	port 
	(
		clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((N-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((N-1) downto 0)
	);
end component;

component extender632
port(
	inp: in std_logic_vector(15 downto 0);
	ctrl: in std_logic;
	outp: out std_logic_vector(31 downto 0));
end component;

component nmux
	port(i_A : in std_logic_vector(N-1 downto 0);
	     i_B : in std_logic_vector(N-1 downto 0);
	     i_S : in std_logic;
	     o_F : out std_logic_vector(N-1 downto 0));
end component;

signal regToA,regToB,muxToReg,memToMux,aluToMux,extToAlu, aluInB : std_logic_vector(N-1 downto 0);
signal tempToReg : std_logic;
signal empt : std_logic;

begin
	tempToReg <= not(store);	
	regFile_i : regFile
	port MAP(
		clk => clk,
		reset =>reset,
		wEnable =>tempToReg,
		writeTo =>writeTo,
		readFrom1 =>readFrom1,
		readFrom2 =>readFrom2,
		writeData => muxToReg,
		out_r1 =>regToA,
		out_r2 =>regToB);

Genny: for i in 0 to N-1 generate
	aluInB(i) <= (RegToB(i) and not(aluSrc)) or (extToAlu(i) and aluSrc);
end generate;

	alu : alu32
	port MAP(
	     	inA => RegToA,
		inB => aluInB,
	     	sel => sel,
		shiftSize => shiftSize,
		shiftCtrl => shiftCtrl,
	     	overflow => overflow,
		carryOut => empt,
		zero => zero,
		o_F => aluToMux);





	nmux_i : nmux
	port MAP(
		i_A => aluToMux,
		i_B => memToMux,
		i_S => load,
		o_F => muxToReg);

	zeroSignExtender_i : extender632
	port MAP(
		inp => immediate,
		ctrl => extSel,
		outp => extToAlu);
	
	mem_i : mem
	port MAP(
		clk => clk,
		addr => aluToMux(9 downto 0),
		data => regToB,
		we => store,
		q => memToMux);
	muxOut <= muxToReg;
end structure;