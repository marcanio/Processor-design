-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an 2 versions of the 2:1 MUX 

-- NOTES:
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity Two2OneTest is 
generic(N : integer := 32);
end Two2OneTest;

architecture structure of Two2OneTest is

component two2oneN
generic(N : integer := 32);
	port(	in_12 : in 	std_logic_vector(N-1 downto 0);
		in_22 : in 	std_logic_vector(N-1 downto 0);
		Sel2  : in 	std_logic;
		out_12: out	std_logic_vector(N-1 downto 0));
end component;

component two2oneData
generic(N : integer := 32);
	port(	in_1 : in 	std_logic_vector(N-1 downto 0);
		in_2 : in 	std_logic_vector(N-1 downto 0);
		Sel  : in 	std_logic;
		out_1: out	std_logic_vector(N-1 downto 0));
end component;

signal S_1, S_2, S_O1, S_O2 : std_logic_vector(N-1 downto 0);
signal S_Sel 	: std_logic;

begin

Struct: two2oneN 
  port map(	in_12  => s_2,
  	        in_22  => s_1,
  	        Sel2   => s_sel,
		out_12 => S_O1);

DataFlow: two2oneData 
  port map(	in_1  => s_1,
  	        in_2  => s_2,
  	        Sel   => s_sel,
		out_1 => S_O2);
--Struct: entity work.two2oneN port map(S_1,S_2,S_Sel,out_1);	--Struct version of MUX
--DataFlow: entity work.two2oneData port map(S_1,S_2,S_Sel,out_2);	--Dataflow version of MUX

process
  begin
    S_1 <= "00000000000000000000000000000000";
    S_2 <= "00000000000000110000000000000000";
    S_Sel <= '0';
    wait for 100 ns;

    S_1 <= "01111100000000000000000000000000";
    S_2 <= "00000000000000000000000000011111";
    S_Sel <= '1';
    wait for 100 ns;

    S_1 <= "00000111110000000001111100000000";
    S_2 <= "00000000000000110000000001111100";
    S_Sel <= '0';
    wait for 100 ns;

    S_1 <= "00000000000000000000000000000000";
    S_2 <= "10101011010101010101101010101010";
    S_Sel <= '1';
    wait for 100 ns;


end process;
    


end structure;