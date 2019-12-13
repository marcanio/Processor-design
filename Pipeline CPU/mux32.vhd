-------------------------------------------------------------------------
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32.vhd
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

entity mux32 is
  port(
	in_1,in_2,in_3,in_4,in_5,in_6,in_7,in_8,in_9,in_10,in_11,in_12,in_13,in_14,in_15,in_16,in_17,in_18,in_19,in_20,in_21,in_22,in_23,in_24,in_25,in_26,in_27,in_28,in_29,in_30,in_31,in_32 : in std_logic_vector(31 downto 0);
	out_32: out std_logic_vector(31 downto 0);
	sel: in std_logic_vector(4 downto 0));
end mux32;

architecture behavior of mux32 is
begin 
  with sel select
out_32 <= in_1 when "00000",
	  in_2 when "00001",
	  in_3 when "00010",
	  in_4 when "00011",
	  in_5 when "00100",
	  in_6 when "00101",
	  in_7 when "00110",
	  in_8 when "00111",
	  in_9 when "01000",
	  in_10 when "01001",
	  in_11 when "01010",
	  in_12 when "01011",
	  in_13 when "01100",
	  in_14 when "01101",
	  in_15 when "01110",
	  in_16 when "01111",
	  in_17 when "10000",
	  in_18 when "10001",
	  in_19 when "10010",
	  in_20 when "10011",
	  in_21 when "10100",
	  in_22 when "10101",
	  in_23 when "10110",
	  in_24 when "10111",
	  in_25 when "11000",
	  in_26 when "11001",
	  in_27 when "11010",
	  in_28 when "11011",
	  in_29 when "11100",
	  in_30 when "11101",
	  in_31 when "11110",
	  in_32 when "11111",
	  in_1 when others;

end behavior;