-------------------------------------------------------------------------
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- nmux8_1.vhd


library IEEE;
use IEEE.std_logic_1164.all;
entity nmux8_1 is
generic(N : integer := 32);
	port(i_A,i_B,i_C,i_D,i_E,i_F,i_G,i_H : in std_logic_vector(N-1 downto 0);
	     sel : in std_logic_vector(2 downto 0);
	     o_F : out std_logic_vector(N-1 downto 0));
end nmux8_1;
architecture structure of nmux8_1 is
--components
component mux8_1
	port(i_A,i_B,i_C,i_D,i_E,i_F,i_G,i_H : in std_logic;
	     sel : in std_logic_vector(2 downto 0);
	     o_F : out std_logic);
end component;
begin
G1: for i in 0 to N-1 generate
  mux8_1_i: mux8_1 
    port map(i_A  => i_A(i),
		i_B => i_B(i),
		i_C => i_C(i),
		i_D => i_D(i),
		i_E => i_E(i),
		i_F => i_F(i),
		i_G => i_G(i),
		i_H => i_H(i),
		sel => sel,
  	          o_F  => o_F(i));
end generate;
end structure;