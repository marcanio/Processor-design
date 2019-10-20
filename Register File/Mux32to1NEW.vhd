-- This is a 32:1 mux
library IEEE;
use IEEE.std_logic_1164.all;

--use work.array2D.all;

entity Mux32to1NEW is
 generic(N : integer := 32);
  port(input_data 	: in array(31 downto 0) of std_logic_vector(31 downto 0);     -- 32, 32 bit values
       output32         : out std_logic_vector(31 downto 0);
       selector		: in std_logic_vector(4 downto 0));   -- Enable bit

end Mux32to1NEW;


architecture DataFlow of Mux32to1NEW is

begin
output32 <= input_data(selector);



end DataFlow;