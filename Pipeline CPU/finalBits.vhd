-------------------------------------------------------------------------
-- Eric Marcanio, Thomas Beckler, Ben Pierre
-------------------------------------------------------------------------
-- DESCRIPTION: Big ALU - Final bit

-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity finalBits is 
	port(	sel			 : in 	std_logic_vector(2 downto 0); --Select Bits for the mux
		inA, inB		 : in 	std_logic; --Inputs
		carry 			 : in 	std_logic; --Carry bit
		carryOut		 : out 	std_logic; --Carry out
		sum			 : out	std_logic; -- Sum bit 
		set			 : out  std_logic;
		V			 : out  std_logic  --Overflow bit
	);
	
end finalBits;

architecture structure of finalBits is
signal addOut,addCOut, subOut,subCOut, sltOut, xorOut ,andOut ,orOut ,nandOut ,norOut,muxOut,sSum :std_logic;

begin

--adderSub: entity work.AdderSub port map(inA, inB, nAdd_Sub, carryOut, adderOut);
addGate : entity work.Adder1b port map(inA,inB,carry,addOut, addCOut);
subGate : entity work.sub1b port map(inA,inB,carry, subOut, subCOut );

set <= subCOut;
--sltGate : entity work.setLessThan port map(inA, inB, sltOut);
sltOut <= '0';
xorGate : entity work.xorg2 port map(inA, inB, xorOut);
andGate : entity work.andg2 port map(inA, inB, andOut);
orGate  : entity work.org2  port map(inA, inB, orOut );
notAnd	: entity work.invg  port map(andOut, nandOut );
notOr	: entity work.invg  port map(orOut, norOut   );
mux2bits: entity work.two2one port map(subCOut,addCOut,sel(0),carryOut);
mux8bits: entity work.mux8_1 port map(addOut, subOut, sltOut, xorOut, andOut, orOut, nandOut, norOut, sel, sSum);
sum <= sSum;

process(sel, inA, inB,sSum)
begin
	case sel is
		when "000" =>
		V <= (not inA and not inB and sSum) or (inA and inB and not sSum);
		when "001" =>
		V <= (not inA and not inB and sSum) or (inA and inB and not sSum);
		when others =>
		v <= '0';
	end case;
end process;
--andNandMux: entity work.two2one port map(

end structure;
