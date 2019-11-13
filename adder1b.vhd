---1bit adder---
library IEEE;
use IEEE.std_logic_1164.all;

entity adder1b is
	port(inputA, inputB, carryIn : in std_logic;
		 output, carryOut : out std_logic);

end adder1b;

architecture structural of adder1b is 
begin
 pCase : process (inputA, inputB, carryIN)
 variable v_CONCATENATE : std_logic_vector(2 downto 0);
	begin 
	 v_CONCATENATE := inputA & inputB & carryIn;
	 
	 C1 :case v_CONCATENATE is
		when "000" => output<= '0';
		when "001" => output<= '1';
		when "010" => output<= '1';
		when "011" => output<= '0';
		when "100" => output<= '1';
		when "101" => output<= '0';
		when "110" => output<= '0';
		when "111" => output<= '1';
		when others => output<= '0';
	end case;
	
	C2 :case v_CONCATENATE is
		when "000" => carryOut<= '0';
		when "001" => carryOut<= '0';
		when "010" => carryOut<= '0';
		when "011" => carryOut<= '1';
		when "100" => carryOut<= '0';
		when "101" => carryOut<= '1';
		when "110" => carryOut<= '1';
		when "111" => carryOut<= '1';
		when others => carryOut<= '0';
	end case;
 end process;
end structural;