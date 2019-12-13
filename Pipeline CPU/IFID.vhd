--IFID Register for pipeline

library IEEE;
use IEEE.std_logic_1164.all;

entity IFIDreg is
      port(
        clk    : in std_logic;
        reset  : in std_logic;
        writeE : in std_logic;
		flush,stall	:in std_logic;

        inst   : in std_logic_vector(31 downto 0);
        instAd : in std_logic_vector(31 downto 0);

        instO   : out std_logic_vector(31 downto 0);
        instAdO : out std_logic_vector(31 downto 0);
		
		enablein : in std_logic;
		enableout : out std_logic);

end IFIDreg;
    
architecture structure of IFIDreg is
--D Flip Flop

component dffa
	port(
		i_CLK        : in std_logic;     -- Clock input
		i_RST        : in std_logic;     -- Reset input
		i_WE         : in std_logic;     -- Write enable input
		i_D          : in std_logic;     -- Data value input
		o_Q          : out std_logic);   -- Data value output

end component;

signal S_instO, S_instAdO: std_logic_vector(31 downto 0);
 signal S_reset, S_writeE : std_logic;
begin

S_reset <= reset OR flush;
S_writeE <= (not stall) and writeE;

enn : dffa
port MAP(i_CLK => clk,
		i_RST => S_reset,
		i_WE => S_writeE,
		i_D => enablein,
		o_Q => enableout);

Gl : for i in 0 to 31 generate --Instruction flip flop
flipflop : dffa
port MAP(i_CLK => clk,
		i_RST => S_reset,
		i_WE => S_writeE,
		i_D => inst(i),
		o_Q => S_instO(i));
end generate; 

G2 : for i in 0 to 31 generate -- instruction address flip flop
	flipflop : dffa
	port MAP(i_CLK => clk,
		i_RST => S_reset,
		i_WE => S_writeE,
		i_D => instAd(i),
		o_Q => S_instAdO(i));
end generate; 

instO   <= S_instO;     --Set outputs to the signals
instAdO <= S_instAdO;
end structure;