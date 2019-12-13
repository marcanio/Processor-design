-- IDEX register for pipeline

library IEEE;
use IEEE.std_logic_1164.all;

entity IDEXDreg is
    port(
        writeE		:in std_logic;
	    reset		:in std_logic;
	    CLK			:in std_logic;
	
    	i_WB		:in std_logic; --Write Back
	    o_WB		:out std_logic;
	    i_M		    :in std_logic; --Memory
    	o_M	    	:out std_logic;
		flush,stall	:in std_logic;

        opcode      : in std_logic_vector(3 downto 0);
        opcodeO     : out std_logic_vector(3 downto 0);

        RegA,RegB   : in std_logic_vector(31 downto 0);
        RegAO,RegBO : out std_logic_vector(31 downto 0);

        RegAddressA, RegAddressB    : in std_logic_vector(4 downto 0);
        RegAddressAO, RegAddressBO  : out std_logic_vector(4 downto 0);

        Reg20downto16, Reg15downto11 : in std_logic_vector(4 downto 0);
        Reg20downto16O, Reg15downto11O : out std_logic_vector(4 downto 0);

        immExtended : in std_logic_vector(31 downto 0);
        immExtendedO : out std_logic_vector(31 downto 0);
		
		jalAddressCarry : in std_logic_vector(31 downto 0);
		jalAddressCarryOut : out std_logic_vector(31 downto 0);
	 
		extnMuxOutCarry	: in std_logic_vector(31 downto 0);
		extnMuxOutCarryOut : out std_logic_vector(31 downto 0);
	 
		shiftCtrlCarry		: in std_logic_vector(1 downto 0);
		shiftCtrlCarryOut	: out std_logic_vector(1 downto 0);
		shiftSizeCarry		: in std_logic_vector(4 downto 0);
		shiftSizeCarryOut   : out std_logic_vector(4 downto 0);
	
		regDest		        :in std_logic_vector(4 downto 0);
		regDestO		    :out std_logic_vector(4 downto 0);
	
		luiCarry			:in std_logic_vector(31 downto 0);
		luiCarryOut			:out std_logic_vector(31 downto 0);
		
		ctrlSigs : in std_logic_vector(31 downto 0);
		ctrlSigsO : out std_logic_vector(31 downto 0));
       
end IDEXDreg;

architecture structure of IDEXDreg is

    component dffa
          port(i_CLK        : in std_logic;     -- Clock input
           i_RST        : in std_logic;     -- Reset input
           i_WE         : in std_logic;     -- Write enable input
           i_D          : in std_logic;     -- Data value input
           o_Q          : out std_logic);   -- Data value output
    
    end component;
    signal S_reset, S_writeE : std_logic;
	
begin

	S_reset <= reset OR flush;
	S_writeE <= (not stall) and writeE;

	WBDFF : dffa
	port MAP(i_CLK => CLK,
		 i_RST => S_reset,
		 i_WE => S_writeE,
		 i_D => i_WB,
		 o_Q => o_WB);

	MemoryDFF : dffa
		port MAP(i_CLK => CLK,
			 i_RST => S_reset,
			 i_WE => S_writeE,
			 i_D => i_M,
			 o_Q => o_M);
			 
			 
	Gen1 : for i in 0 to 1 generate
		shiftCtrl : dffa
		port MAP(i_CLK => CLK,
		 i_RST => S_reset,
		 i_WE => S_writeE,
		 i_D => shiftCtrlCarry(i),
		 o_Q => shiftCtrlCarryOut(i));
	end generate;
	
	Gen32 : for i in 0 to 3 generate
	OpcodeDFF : dffa
	port MAP(i_CLK => CLK,
		 i_RST => S_reset,
		 i_WE => S_writeE,
		 i_D => opcode(i),
		 o_Q => opcodeO(i));
	end generate;	


	Gen4 : for i in 0 to 4 generate

		RSDFF : dffa
		port MAP(i_CLK => CLK,      --Destination of regsiter A
			 i_RST => S_reset,
			 i_WE => S_writeE,
			 i_D => RegAddressA(i),
			 o_Q => RegAddressAO(i));
			 
		RTDFF : dffa
		port MAP(i_CLK => CLK,      --Destination of register B
			 i_RST => S_reset,
			 i_WE => S_writeE,
			 i_D => RegAddressB(i),
			 o_Q => RegAddressBO(i));
			 
		RDDFF : dffa
		port MAP(i_CLK => CLK,      --20 downto 16 in instruction
			 i_RST => S_reset,
			 i_WE => S_writeE,
			 i_D => Reg20downto16(i),
			 o_Q => Reg20downto16O(i));
			 
		Reg15downto : dffa
		port MAP(i_CLK => CLK,      --15 downto 11 in instruction
				  i_RST => S_reset,
				  i_WE => S_writeE,
				  i_D => Reg15downto11(i),
				  o_Q => Reg15downto11O(i));
				  
		shiftSize : dffa
		port MAP(i_CLK => CLK,      --15 downto 11 in instruction
				  i_RST => S_reset,
				  i_WE => S_writeE,
				  i_D => shiftSizeCarry(i),
				  o_Q => shiftSizeCarryOut(i));
				  
		regDests : dffa
		port MAP(i_CLK => CLK,      --15 downto 11 in instruction
				  i_RST => S_reset,
				  i_WE => S_writeE,
				  i_D => regDest(i),
				  o_Q => regDestO(i));
	end generate;
	
	
		Gen31 : for i in 0 to 31 generate
		IMMDFF : dffa
		port MAP(i_CLK => CLK,
			 i_RST => S_reset,
			 i_WE => S_writeE,
			 i_D => immExtended(i),
			 o_Q => immExtendedO(i));

		REGADFF : dffa
		port MAP(i_CLK => CLK,
			 i_RST => S_reset,
			 i_WE => S_writeE,
			 i_D => RegA(i),
			 o_Q => RegAO(i));

		REGBDFF : dffa
		port MAP(i_CLK => CLK,
			 i_RST => S_reset,
			 i_WE => S_writeE,
			 i_D => RegB(i),
			 o_Q => RegBO(i));
			 
		ctrlSigsDff : dffa
		port MAP(i_CLK => clk,
			i_RST => S_reset,
			i_WE => writeE,
			i_D => ctrlSigs(i),
			o_Q => ctrlSigsO(i));
			
		jalAddress : dffa
		port MAP(i_CLK => clk,
			i_RST => S_reset,
			i_WE => writeE,
			i_D => jalAddressCarry(i),
			o_Q => jalAddressCarryOut(i));
			
		extnMuxOut : dffa
		port MAP(i_CLK => clk,
			i_RST => S_reset,
			i_WE => writeE,
			i_D => extnMuxOutCarry(i),
			o_Q => extnMuxOutCarryOut(i));
			
		lui : dffa
		port MAP(i_CLK => clk,
			i_RST => S_reset,
			i_WE => writeE,
			i_D => luiCarry(i),
			o_Q => luiCarryOut(i));
			
						
	end generate;


end structure;