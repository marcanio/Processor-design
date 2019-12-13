-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: Big ALU - Final bit

-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity bigALU is 
	port(	sel			 : in 	std_logic_vector(2 downto 0); --Select Bits for the mux
		inA, inB		 : in 	std_logic; --Inputs
		carry 			 : in 	std_logic; --Carry bit
		zero			 : in 	std_logic;
		carryOut		 : out 	std_logic; --Carry out
		sum			 : out	std_logic -- Sum bit 
	);
	
end bigALU;

architecture structure of bigALU is
signal addOut,addCOut, subOut,subCOut, sltOut, xorOut ,andOut ,orOut ,nandOut ,norOut,muxOut,selHelp :std_logic;

begin

addGate : entity work.Adder1b port map(inA,inB,carry,addOut, addCOut);
subGate : entity work.sub1b port map(inA,inB,carry, subOut, subCOut);
selHelp <= sel(0) or sel(1);
sltOut <= zero;
xorGate : entity work.xorg2 port map(inA, inB, xorOut);
andGate : entity work.andg2 port map(inA, inB, andOut);
orGate  : entity work.org2  port map(inA, inB, orOut );
notAnd	: entity work.invg  port map(andOut, nandOut );
notOr	: entity work.invg  port map(orOut, norOut   );
mux2bits: entity work.two2one port map(subCOut,addCOut,selHelp,carryOut);
mux8bits: entity work.mux8_1 port map(addOut, subOut, sltOut, xorOut, andOut, orOut, nandOut, norOut, sel, sum);


end structure;
