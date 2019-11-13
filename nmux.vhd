-------------------------------------------------------------------------
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- nmux.vhd


library IEEE;
use IEEE.std_logic_1164.all;
entity nmux is
generic(N : integer := 32);
	port(i_A : in std_logic_vector(N-1 downto 0);
	     i_B : in std_logic_vector(N-1 downto 0);
	     i_S : in std_logic;
	     o_F : out std_logic_vector(N-1 downto 0));
end nmux;
architecture structure of nmux is
begin
G1: for i in 0 to N-1 generate
	o_F(i) <= (i_A(i) and not(i_S)) or (i_B(i) and i_S);
end generate;
end structure;