--MEM/WB register for pipeline

library IEEE;
use IEEE.std_logic_1164.all;

entity memWbReg is
    port(
        writeE		:in std_logic;
	reset		:in std_logic;
	CLK			:in std_logic;

        i_WB				:in std_logic;
        o_WB				:out std_logic;
	flush,stall	:in std_logic;
    
    	DMemRead		    :in std_logic_vector(31 downto 0);
	DMemReadO			:out std_logic_vector(31 downto 0);
	
	DMemWriteAddress	:in std_logic_vector(31 downto 0);
	DMemWriteAddressO	:out std_logic_vector(31 downto 0);
	
	 regDest		        :in std_logic_vector(4 downto 0);
	 regDestO		    :out std_logic_vector(4 downto 0);
		
	luiCarry			:in std_logic_vector(31 downto 0);
	luiCarryOut			:out std_logic_vector(31 downto 0);
		
	jalAddressCarry : in std_logic_vector(31 downto 0);
	jalAddressCarryOut : out std_logic_vector(31 downto 0);
		
	ctrlSigs : in std_logic_vector(31 downto 0);
	ctrlSigsO : out std_logic_vector(31 downto 0));
end memWbReg;

architecture structure of  memWbReg  is

component dffa
	port(
		i_CLK        : in std_logic;     -- Clock input
		i_RST        : in std_logic;     -- Reset input
		i_WE         : in std_logic;     -- Write enable input
		i_D          : in std_logic;     -- Data value input
		o_Q          : out std_logic);   -- Data value output

end component;

 signal S_reset, S_writeE : std_logic;

begin

S_reset <= reset OR flush;
S_writeE <= (not stall) and writeE;

wbM : dffa
port MAP(   i_CLK => clk,
            i_RST => S_reset,
            i_WE => S_writeE,
            i_D => i_WB,
            o_Q => o_WB);

generator : for i in 0 to 31 generate
	flipflop : dffa
    port MAP(i_CLK => clk,
        i_RST => S_reset,
        i_WE => S_writeE,
        i_D => DMemRead(i),
        o_Q => DMemReadO(i));
					
	lui : dffa
	port MAP(i_CLK => clk,
		i_RST => S_reset,
		i_WE => S_writeE,
		i_D => luiCarry(i),
		o_Q => luiCarryOut(i));
		
	jal : dffa
	port MAP(i_CLK => clk,
		i_RST => S_reset,
		i_WE => S_writeE,
		i_D => jalAddressCarry(i),
		o_Q => jalAddressCarryOut(i));
		
	ctrlSig : dffa
	port MAP(i_CLK => clk,
		i_RST => reset,
		i_WE => writeE,
		i_D => ctrlSigs(i),
		o_Q => ctrlSigsO(i));
		
	DMemWriteAddres : dffa
    port MAP(i_CLK => clk,
        i_RST => S_reset,
        i_WE => S_writeE,
        i_D => DMemWriteAddress(i),
        o_Q => DMemWriteAddressO(i));
end generate;

regdstLoop : for i in 0 to 4 generate
	flipflop : dffa
	port MAP(i_CLK => clk,
		i_RST => S_reset,
		i_WE => S_writeE,
		i_D => regDest(i),
		o_Q => regDestO(i));
end generate;



end structure;