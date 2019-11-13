-------------------------------------------------------------------------
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- nreg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nreg is
generic(N : integer := 32);
  port(
	clk,reset,ctl : in std_logic;
	r1 : out std_logic_vector(N-1 downto 0);
	w1 : in std_logic_vector(N-1 downto 0));
end nreg;

architecture structure of nreg is
--components
component dffa
	port(
		i_CLK        : in std_logic;     -- Clock input
		i_RST        : in std_logic;     -- Reset input
		i_WE         : in std_logic;     -- Write enable input
		i_D          : in std_logic;     -- Data value input
		o_Q          : out std_logic);   -- Data value output

end component;

begin
Gl : for i in 0 to N-1 generate
	flipflop : dffa
	port MAP(i_CLK => clk,
		i_RST => reset,
		i_WE => ctl,
		i_D => w1(i),
		o_Q => r1(i));
end generate; 
end structure;