-------------------------------------------------------------------------
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- alu32.vhd


library IEEE;
use IEEE.std_logic_1164.all;

entity alu32 is
	generic(N : integer := 32);
	port(
	     inA,inB : in std_logic_vector(N-1 downto 0);
	     sel : in std_logic_vector(3 downto 0);
		 shiftSize : in std_logic_vector(4 downto 0);
		 shiftCtrl : in std_logic_vector(1 downto 0);
	     overflow, carryOut, zero : out std_logic;
		 o_F : out std_logic_vector(N-2+1 downto 0));
end alu32;

architecture structure of alu32 is
--components
component nor32
	port(
		inputs : in std_logic_vector(N-1 downto 0);
		output: out std_logic);
end component;

component bigALU
	port(
		inA,inB : in std_logic;
		sel: in std_logic_vector(2 downto 0);
		carry,zero: in std_logic;
		carryOut: out std_logic;
		sum: out std_logic);
end component;
component finalBits
	port(
		inA,inB : in std_logic;
		sel: in std_logic_vector(2 downto 0);
		carry: in std_logic;
		carryOut: out std_logic;
		sum: out std_logic;
		V : out std_logic;
		set: out std_logic);
end component;

component barrel32
	port(inA          : in std_logic_vector(31 downto 0);
		 sel	    : in std_logic_vector(4 downto 0);
		 ctrl,arithctrl	    : in std_logic;
         o_F          : out std_logic_vector(31 downto 0));
end component;
--signals
signal barrelsig, outSig : std_logic_vector(N-1 downto 0);
signal carrySig : std_logic_vector(N-1 downto 0);
signal zeroSig,check : std_logic;

begin 
carrySig(0) <= '0';
bigALU_i : bigALU
	port MAP(inA =>inA(0),
		 inB =>inB(0),
		 sel => sel(2 downto 0),
		 carry => carrySig(0),
		 zero => zeroSig,
		 carryOut => carrySig(1),
		 sum =>outSig(0));
G1: for i in 1 to N-2 generate
	bigALU_i : bigALU
	port MAP(inA =>inA(i),
		 inB =>inB(i),
		 sel => sel(2 downto 0),
		 carry => carrySig(i),
		 zero => '0',
		 carryOut => carrySig(i+1),
		 sum =>outSig(i));
end generate;
	finalBits_i : finalBits
	port MAP(inA =>inA(31),
		 inB =>inB(31),
		 sel => sel(2 downto 0),
		 carry => carrySig(31),
		 carryOut => check,
		 sum => outSig(31),
		 V => overflow,
		 set => zeroSig);

	nor32_i : nor32
	port MAP(inputs => outSig,
		 output => zero);

	bshift : barrel32
	port MAP(inA => inA,
				sel => shiftSize,
				ctrl => shiftCtrl(0),
				arithctrl => shiftCtrl(1),
				o_F => barrelSig);
	
carryOut <= check;

Genny: for i in 0 to N-1 generate
	o_F(i) <= (outSig(i) and not(sel(3))) or (barrelSig(i) and sel(3));
end generate;

end structure;