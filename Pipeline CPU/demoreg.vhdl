--MEM/WB register for pipeline

library IEEE;
use IEEE.std_logic_1164.all;

entity demoreg is
    port(
        writeE		:in std_logic;
	reset		:in std_logic;
	CLK			:in std_logic;

        i_WB				:in std_logic;
        o_WB				:out std_logic;
	flush,stall	:in std_logic;
    
    	DMemRead		    :in std_logic_vector(31 downto 0);
	DMemReadO			:out std_logic_vector(31 downto 0));
end demoreg;

architecture structure of  demoreg  is

component dffa
	port(
		i_CLK        : in std_logic;     -- Clock input
		i_RST        : in std_logic;     -- Reset input
		i_WE         : in std_logic;     -- Write enable input
		i_D          : in std_logic;     -- Data value input
		o_Q          : out std_logic);   -- Data value output

end component;


signal S_reset, S_writeE, i_WBsig: std_logic;

begin

S_reset <= '1' when (reset='1' OR flush='1') else '0';
S_writeE <= '1' when (not(stall='1') and writeE='1') else '0';
i_WBsig <= '1' when (i_WB ='1') else '0';
wbM : dffa
port MAP(	i_CLK => clk,
            i_RST => S_reset,
            i_WE => S_writeE,
            i_D => i_WBsig,
            o_Q => o_WB);

generator : for i in 0 to 31 generate
	flipflop : dffa
    port MAP(i_CLK => clk,
        i_RST => S_reset,
        i_WE => S_writeE,
        i_D => DMemRead(i),
        o_Q => DMemReadO(i));
end generate;

end structure;
