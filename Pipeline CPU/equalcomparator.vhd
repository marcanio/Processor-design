library IEEE;
use IEEE.std_logic_1164.all;

entity equalComparator is
	port( inputa : in std_logic_vector(31 downto 0);
	      inputb : in std_logic_vector(31 downto 0);
		  equals : out std_logic);
end equalComparator;

architecture dataflow of equalComparator is
signal carrysig,invsig,sum : std_logic_vector(32 downto 0);
begin
carrysig(0) <= '1';
G1 : for i in 0 to 31 generate
	invsig(i) <= not inputb(i);
	sum(i) <= (not carrysig(i) and ( inputa(i) or invsig(i)) and (not inputa(i) or not invsig(i))) or (carrysig(i) and ( (inputa(i) and invsig(i)) or (not inputa(i) and not invsig(i))));
	carrysig(i+1) <= ((not carrysig(i)) and inputa(i) and invsig(i)) or (carrysig(i) and(inputa(i) or invsig(i)));
end generate;

equals <= not (sum(0) or sum(1) or sum(2) or sum(3) or sum(4) or sum(5) or sum(6) or sum(7) or sum(8) or sum(9) or sum(10) or sum(11) or sum(12) or sum(13) or sum(14) or sum(15) or sum(16) or sum(17) or sum(18) or sum(19) or sum(20) or sum(21) or sum(22) or sum(23) or sum(24) or sum(25) or sum(26) or sum(27) or sum(28) or sum(29) or sum(30) or sum(31));

end dataflow;
