--TestBench for pipeline registers

library ieee;
use ieee.std_logic_1164.all;

entity PipelineRegisterTB is
	generic(gCLK_HPER   : time := 50 ns);
end PipelineRegisterTB;

architecture structure of PipelineRegisterTB is

component IFIDreg is
    port(
        clk    : in std_logic;
        reset  : in std_logic;
        writeE : in std_logic;
	flush,stall	:in std_logic;
        inst   : in std_logic_vector(31 downto 0);
        instAd : in std_logic_vector(31 downto 0);

        instO   : out std_logic_vector(31 downto 0);
        instAdO : out std_logic_vector(31 downto 0));
end component;

component IDEXDreg is
    port(
        writeE		:in std_logic;
	    reset		:in std_logic;
	    CLK			:in std_logic;
		flush,stall	:in std_logic;
    	i_WB		:in std_logic; --Write Back
	    o_WB		:out std_logic;
	    i_M		    :in std_logic; --Memory
    	o_M	    	:out std_logic;

        opcode      : in std_logic_vector(3 downto 0);
        opcodeO     : out std_logic_vector(3 downto 0);

        RegA,RegB   : in std_logic_vector(31 downto 0);
        RegAO,RegBO : out std_logic_vector(31 downto 0);

        RegAddressA, RegAddressB    : in std_logic_vector(4 downto 0);
        RegAddressAO, RegAddressBO  : out std_logic_vector(4 downto 0);

        Reg20downto16, Reg15downto11 : in std_logic_vector(4 downto 0);
        Reg20downto16O, Reg15downto11O : out std_logic_vector(4 downto 0);

        immExtended : in std_logic_vector(31 downto 0);
        immExtendedO : out std_logic_vector(31 downto 0));
end component;

component EXMEMreg is
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        writeE      : in std_logic;
		flush,stall	:in std_logic;
        i_WB        : in std_logic;     --Write Back
        o_WB        : out std_logic;
        i_M         : in std_logic;     --Memory
        o_M         : out std_logic;

        aluOut      : in std_logic_vector(31 downto 0); --Ouput of ALU
        aluOutO     : out std_logic_vector(31 downto 0);

        dataMem     : in std_logic_vector(31 downto 0);
        dataMemO    : out std_logic_vector(31 downto 0);

        regDest : in std_logic_vector(4 downto 0);
        regDestO : out std_logic_vector(4 downto 0));
end component;

component memWbReg is
    port(
        writeE		:in std_logic;
	    reset		:in std_logic;
	    CLK			:in std_logic;
		flush,stall	:in std_logic;
        i_WB				:in std_logic;
        o_WB				:out std_logic;
    
    	DMemRead		    :in std_logic_vector(31 downto 0);
	    DMemReadO			:out std_logic_vector(31 downto 0);
	
	    DMemWriteAddress	:in std_logic_vector(31 downto 0);
	    DMemWriteAddressO	:out std_logic_vector(31 downto 0);
	
	    regDest		        :in std_logic_vector(4 downto 0);
	    regDestO		    :out std_logic_vector(4 downto 0));
end component;

signal s_writeE: std_logic;
signal s_RST: std_logic;
signal s_CLK: std_logic;
signal s_WB, S_WB_IDEX, S_WB_EXMEM: std_logic;
signal s_M, S_M_IDEX : std_logic;

signal S_inst, S_inst_IFID, S_instAd,S_instAdIFID  : std_logic_vector(31 downto 0);

signal ded32 : std_logic_vector(31 downto 0);
signal ded5 : std_logic_vector(4 downto 0);
signal ded4 : std_logic_vector(3 downto 0);
signal S_inst_IDEX, S_inst_EXMEM, S_inst_MEMWB : std_logic_vector(4 downto 0);

constant g_clock : time := gCLK_HPER*2;

signal S_stallIFID, S_flushIFID : std_logic;
signal S_stallIDEX, S_flushIDEX : std_logic;
signal S_stallEXMEM, S_flushEXMEM : std_logic;
signal S_stallMEMWB, S_flushMEMWB : std_logic;

begin

IFID : IFIDreg
port map(
        clk    => s_CLK,
        reset  => s_RST,
        writeE => S_writeE,
		flush  => S_flushIFID,
		stall  => S_stallIFID,
        inst   => S_inst,
        instAd => S_instAd,
        instO  => S_inst_IFID,
        instAdO => S_instAdIFID);

IDEX : IDEXDreg
port map(
        writeE		=> S_writeE,
	    reset		=> s_RST,
	    CLK			=> s_CLK,
		flush 		=> S_flushIDEX,
		stall  		=> S_stallIDEX,
    	i_WB		=> S_WB,
	    o_WB		=> S_WB_IDEX,
	    i_M		    => S_M,
    	o_M	    	=> S_M_IDEX,
        opcode      => ded4,
        opcodeO     => open,
        RegA        => ded32,
        RegB        => ded32,
        RegAO       => open,
        RegBO       => open,
        RegAddressA => ded5,
        RegAddressB => ded5,
        RegAddressAO=> open,
        RegAddressBO=> open,
        Reg20downto16 => S_inst_IFID(20 downto 16),
        Reg15downto11 => S_inst_IFID(15 downto 11),
        Reg20downto16O => open,
        Reg15downto11O => S_inst_IDEX,
        immExtended => ded32,
        immExtendedO => open);

EXMEM : EXMEMreg
port map(
        clk         => s_CLK,
        reset       => s_RST,
        writeE      => S_writeE,
		flush  		=> S_flushEXMEM,
		stall  		=> S_stallEXMEM,
        i_WB        => S_WB_IDEX,
        o_WB        => S_WB_EXMEM,
        i_M         => S_M_IDEX, 
        o_M         => open,
        aluOut      => ded32,
        aluOutO     => open,
        dataMem     => ded32,
        dataMemO    => open,
        regDest     => S_inst_IDEX,
        regDestO    => S_inst_EXMEM);

MEMWB : memWbReg
port map(
    writeE		    => S_writeE,
    reset		    => s_RST,
    CLK			    => S_clk,
	flush  			=> S_flushMEMWB,
	stall 			=> S_stallMEMWB,
    i_WB			=> S_WB_EXMEM,
    o_WB			=> open,
    DMemRead		=> ded32,
    DMemReadO		=> open,
    DMemWriteAddress	=> ded32,
    DMemWriteAddressO	=> open,
    regDest		        => S_inst_EXMEM,
    regDestO		    => S_inst_MEMWB);

	P_CLK: process
	begin
		s_CLK <= '0';
		wait for gCLK_HPER;
		s_CLK <= '1';
		wait for gCLK_HPER;
	end process;

P_TB : process
begin
    s_writeE <= '1';
    s_rst  <= '1';
	S_stallIFID  <= '0';
	S_flushIFID  <= '0';
	S_stallIDEX <= '0';
	S_flushIDEX  <= '0';
	S_stallEXMEM <= '0';
	S_flushEXMEM <= '0';
	S_stallMEMWB <= '0';
	S_flushMEMWB <= '0';

    wait for g_clock; 

	s_rst <= '0'; 
	S_inst 			<= x"00000000";
	S_instAd 	    <= x"00400000";
	s_WB <= '1';
    s_M  <= '1';

    wait for g_clock;

    S_inst 			<= x"11111111";
    S_instAd 	    <= x"00400004";
    s_WB            <= '0';
    s_M             <= '0';
    
    wait for g_clock;
    S_inst 			<= x"22222222";
    S_instAd 	<= x"00400008";
    s_WB <= '0';
    s_M  <= '0';
	S_stallIDEX  <= '1';
    wait for g_clock;

    S_inst 			<= x"33333333";
    S_instAd 	<= x"0040000B";
    s_WB <= '0';
    s_M  <= '0';
S_stallIDEX  <= '0';
        S_flushIFID  <= '1';
    wait for g_clock;
    S_inst 			<= x"44444444";
    S_instAd 	<= x"0040000F";
    S_flushIFID  <= '0';
    s_WB <= '0';
    s_M  <= '0';
    wait for g_clock;
wait for g_clock;
wait for g_clock;
wait for g_clock;
wait for g_clock;
wait for g_clock;
wait for g_clock;
wait for g_clock;
wait for g_clock;

    
end process;
			


end structure;