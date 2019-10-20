-- This is a 32:1 mux
library IEEE;
use IEEE.std_logic_1164.all;

entity Mux32to1 is
 generic(N : integer := 32);
  port(in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18,in19,in20,in21,in22,in23,in24,in25,in26,in27,in28,in29,in30,in31,in32        : in std_logic_vector(31 downto 0);     -- 5 Bit input
       output32         : out std_logic_vector(31 downto 0);
       selector		: in std_logic_vector(4 downto 0));   -- Enable bit

end Mux32to1;


architecture DataFlow of Mux32to1 is

begin

process(selector)
begin
	output32 <= "00000000000000000000000000000000"; --Default output
	
	
		case selector is
			when "00000" => output32 <= in1;
			when "00001" => output32 <= in2;
			when "00010" => output32 <= in3;
			when "00011" => output32 <= in4;	
			when "00100" => output32 <= in5;
			when "00101" => output32 <= in6;
			when "00110" => output32 <= in7;
			when "00111" => output32 <= in8;
			when "01000" => output32 <= in9;	
			when "01001" => output32 <= in10;	
			when "01010" => output32 <= in11;
			when "01011" => output32 <= in12;
			when "01100" => output32 <= in13;
			when "01101" => output32 <= in14;
			when "01110" => output32 <= in15;
			when "01111" => output32 <= in16;
			when "10000" => output32 <= in17;
			when "10001" => output32 <= in18;
			when "10010" => output32 <= in19;
			when "10011" => output32 <= in20;
			when "10100" => output32 <= in21;	
			when "10101" => output32 <= in22;	
			when "10110" => output32 <= in23;
			when "10111" => output32 <= in24;
			when "11000" => output32 <= in25;
			when "11001" => output32 <= in26;
			when "11010" => output32 <= in27;
			when "11011" => output32 <= in28;
			when "11100" => output32 <= in29;
			when "11101" => output32 <= in30;
			when "11110" => output32 <= in31;
			when "11111" => output32 <= in32;
			when others  => output32 <= "00000000000000000000000000000000";
		end case;
	
end process;
end DataFlow;
