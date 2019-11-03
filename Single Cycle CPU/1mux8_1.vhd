-------------------------------------------------------------------------
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux8_1.vhd


library IEEE;
use IEEE.std_logic_1164.all;

entity mux8_1 is
	port(i_A,i_B,i_C,i_D,i_E,i_F,i_G,i_H : in std_logic;
	     sel : in std_logic_vector(2 downto 0);
	     o_F : out std_logic);
end mux8_1;

architecture behavior of mux8_1 is
begin 
  with sel select
o_F <= i_A when "000",
	  i_B when "001",
	  i_C when "010",
	  i_D when "011",
	  i_E when "100",
	  i_F when "101",
	  i_G when "110",
	  i_H when "111",
	  i_A when others;

end behavior;