-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------


-- Einsten.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the Einsteins 
-- equation E = mc^2 using invidual adder and multiplier units.
--
--
-- NOTES:
-- 8/27/19
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity Einstein is

  port(iCLK             : in std_logic;
       m 		            : in integer;
       E 		            : out integer);

end Einstein;

architecture structure of Einstein is
  

  component Multiplier
    port(iCLK           : in std_logic;
         iA             : in integer;
         iB             : in integer;
         oC             : out integer);
  end component;

-- C is a constant
  constant c : integer := 9487;

-- Signals to store c^2
  signal s_VALUE : integer;

begin
--c^2
  g_Mult1: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => c,
             iB               => c,
             oC               => s_VALUE);

--m*c^2
  g_Mult2: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => m,
             iB               => s_VALUE,
             oC               => E);

end structure;