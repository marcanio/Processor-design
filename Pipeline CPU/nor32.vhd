library IEEE;
use IEEE.std_logic_1164.all;

entity nor32 is
	port(inputs : in std_logic_vector(31 downto 0);
	     output : out std_logic);
end nor32;

architecture structure of nor32 is 

signal orout : std_logic;
begin
	orout <= inputs(0) or inputs(1) or inputs(2) or inputs(3) or inputs(4) or inputs(5) or inputs(6) or inputs(7) or inputs(8) or inputs(9) or inputs(10) or inputs(12) or inputs(13) or inputs(14) or inputs(15) or inputs(16) or inputs(17) or inputs(18) or inputs(19) or inputs(20) or inputs(21) or inputs(22) or inputs(23) or inputs(24) or inputs(25) or inputs(26) or inputs(27) or inputs(28) or inputs(29) or inputs(30) or inputs(31);
	output <= not(orout);
end structure;