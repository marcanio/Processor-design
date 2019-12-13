library IEEE;
use IEEE.std_logic_1164.all;

entity FullAddNBitDataFlow is
	generic(N : integer := 32);
	port( inputa : in std_logic_vector(N-1 downto 0);
	      inputb : in std_logic_vector(N-1 downto 0);
	      carry : in std_logic;
	      sum : out std_logic_vector(N-1 downto 0);
	      carry_out : out std_logic);

end FullAddNBitDataFlow;

architecture dataflow of FullAddNBitDataFlow is
signal carrysig : std_logic_vector(N downto 0);
begin
carrysig(0) <= carry;
G1 : for i in 0 to N-1 generate
	sum(i) <= (not carrysig(i) and ( inputa(i) or inputb(i)) and (not inputa(i) or not inputb(i))) or (carrysig(i) and ( (inputa(i) and inputb(i)) or (not inputa(i) and not inputb(i))));
	carrysig(i+1) <= ((not carrysig(i)) and inputa(i) and inputb(i)) or (carrysig(i) and(inputa(i) or inputb(i)));
end generate;
carry_out <= carrysig(N);
end dataflow;

