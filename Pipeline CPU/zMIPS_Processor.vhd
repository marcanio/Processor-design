-------------------------------------------------------------------------
-- Henry Duwe
-- Ben Pierre
-- Eric Marcino
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal v0             : std_logic_vector(N-1 downto 0); -- TODO: should be assigned to the output of register 2, used to implement the halt SYSCALL
  signal s_Halt         : std_logic :='0';  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.





  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
  	component IDecode is
	port(
		Instruct	: in std_logic_vector(31 downto 0);
		enable		: in std_logic;
		--Memory--
		DMemWr		: out std_logic;			--
		--DMemAddr	: out std_logic_vector(31 downto 0);	
		--DMemData     	: out std_logic_vector(31 downto 0);
		load		: out std_logic;
		--reg file--
		RegWr         	: out std_logic;			--
		ReadA, ReadB: out std_logic_vector(4 downto 0);		--
		RegWrAddr     : out std_logic_vector(4 downto 0);	--
		--Shift--
		ShiftSize 	: out std_logic_vector(4 downto 0);	--
		ShiftContrl	: out std_logic_vector(1 downto 0);	--
		--Extend--
		ExtendCtrl	: out std_logic;			--
		ALUSrc		: out std_logic;			--
		ALUCtrl		: out std_logic_vector(3 downto 0);
		LuiCTRL		: out std_logic;
		VShift : out std_logic;
		BComp 		: out std_logic;
		beqCtrl		: out std_logic;
		jumpCtrl	: out std_logic;
		JalCtrl		: out std_logic;
		JregCtrl	: out std_logic);	
	end component;
	
	component Fowardatroninator9000 is
	port(
		IDEXRS			: in std_logic_vector(4 downto 0);
		IDEXRT			: in std_logic_vector(4 downto 0);
		EXMEMWrAddr		: in std_logic_vector(4 downto 0);
		MEMWBwrAddr		: in std_logic_vector(4 downto 0);
		IFIDrt			: in std_logic_vector(4 downto 0);
		IFIDrs			: in std_logic_vector(4 downto 0);
		EXMEMWB			: in std_logic;
		EXMEMStore		: in std_logic;
		MEMWBWB			: in std_logic;
		IDEXWB			: in std_logic;
		BranchCtrl		: in std_logic;
		JRegCtrl		: in std_logic;
		ImmCtrl			: in std_logic;
		EXMEMWrAddrBefore : in std_logic_vector(4 downto 0);
		o_EXRACtrl		:out std_logic_vector(1 downto 0); --00 is norm --01 is from MemWB --10 is from EXMem	RS
		o_EXRBCtrl		:out std_logic_vector(1 downto 0); --00 is norm --01 is from MemWB --10 is from EXMem	RT
		o_JCtrlMuxA		:out std_logic_vector(1 downto 0); --00 is norm --01 is from MemWB --10 is from EXMem  	RS
		o_JCtrlMuxB		:out std_logic_vector(1 downto 0); --00 is norm --01 is from MemWB --10 is from EXMem	RT
		o_StoreDataCtrl	: out std_logic_vector(1 downto 0));
	end component;

	component regFile
	port(
	clk,reset,wEnable : in std_logic;
	writeTo, readFrom1, readFrom2 : in std_logic_vector(4 downto 0);
	out_r1,out_r2, v0 : out std_logic_vector(N-1 downto 0);
	writeData : in std_logic_vector(N-1 downto 0));
	end component;

	component alu32
	port(
	     	inA,inB : in std_logic_vector(N-1 downto 0);
	     	sel : in std_logic_vector(3 downto 0);
		shiftSize : in std_logic_vector(4 downto 0);
		shiftCtrl : in std_logic_vector(1 downto 0);
		signOrUnsign : in std_logic;
	     	overflow, carryOut, zero : out std_logic;
		o_F : out std_logic_vector(N-2+1 downto 0));
	end component;

	component extender632
	port(
	inp: in std_logic_vector(15 downto 0);
	ctrl: in std_logic;
	outp: out std_logic_vector(31 downto 0));
	end component;


	component nmux
	port(i_A : in std_logic_vector(N-1 downto 0);
	     i_B : in std_logic_vector(N-1 downto 0);
	     i_S : in std_logic;
	     o_F : out std_logic_vector(N-1 downto 0));
	end component;
	
    component mem
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

	component FullAddNBitDataFlow is
		port( inputa : in std_logic_vector(N-1 downto 0);
			inputb : in std_logic_vector(N-1 downto 0);
			carry : in std_logic;
			sum : out std_logic_vector(N-1 downto 0);
			carry_out : out std_logic);

	end component;
	
  
 --our signals
  signal s_imm : std_logic_vector(N-1 downto 0);
  signal s_aluToMux: std_logic_vector(N-1 downto 0);
  signal s_load : std_logic;
  signal s_RegToA : std_logic_vector(N-1 downto 0);
  signal s_RegToB : std_logic_vector(N-1 downto 0);
  signal s_readFrom1 : std_logic_vector(5-1 downto 0);
  signal s_readFrom2 : std_logic_vector(7-3 downto 0);
  signal s_extnMux : std_logic_vector(N-1 downto 0);
  signal s_ALUCtrl : std_logic_vector(3 downto 0);
  signal s_ShiftSize : std_logic_vector(4 downto 0);
  signal s_ShiftContrl : std_logic_vector(1 downto 0);
  signal s_overflow : std_logic;
  signal s_carryOut : std_logic;
  signal s_zero : std_logic;
  signal s_ExtendCtrl : std_logic;
  signal s_ALUSrc : std_logic;
  signal s_pcAdder : std_logic_vector(N-1 downto 0);
  signal s_LuiCTRL : std_logic;
  signal s_LuiVal : std_logic_vector(N-1 downto 0);
  signal s_DMemAluMux : std_logic_vector(N-1 downto 0);
  signal s_regHalt : std_logic;
  signal s_ShiftSizeDec : std_logic_vector(4 downto 0);
  signal s_VShift : std_logic;
  --j signals
  signal s_BComp,s_beqCtrl,s_jumpCtrl,s_JalCtrl	,s_JregCtrl,s_beqRes : std_logic :='0';
  signal s_JumpMuxOut,s_Shift2out,s_RelOffSet,s_JLoc,s_jCtrlOut,s_RegWrDataInter,s_JregCtrlOut : std_logic_vector(31 downto 0);
  
  
  --Pipelining steps
  signal s_zeros1 : std_logic;
  
    component equalComparator is
	port( inputa : in std_logic_vector(31 downto 0);
	      inputb : in std_logic_vector(31 downto 0);
		  equals : out std_logic);
	end component;

	component EXMEMreg is
      port(
        clk         : in std_logic;
        reset       : in std_logic;
        writeE      : in std_logic;

        i_WB        : in std_logic;     --Write Back
        o_WB        : out std_logic;
        i_M         : in std_logic;     --Memory
        o_M         : out std_logic;
		flush,stall	:in std_logic;

        aluOut      : in std_logic_vector(31 downto 0); --Ouput of ALU
        aluOutO     : out std_logic_vector(31 downto 0);

        dataMem     : in std_logic_vector(31 downto 0);
        dataMemO    : out std_logic_vector(31 downto 0);
		
		luiCarry			:in std_logic_vector(31 downto 0);
		luiCarryOut			:out std_logic_vector(31 downto 0);
		
		jalAddressCarry : in std_logic_vector(31 downto 0);
		jalAddressCarryOut : out std_logic_vector(31 downto 0);

        regDest : in std_logic_vector(4 downto 0);
        regDestO : out std_logic_vector(4 downto 0);
		
		ctrlSigs : in std_logic_vector(31 downto 0);
		ctrlSigsO : out std_logic_vector(31 downto 0));
	end component;
	
	component IDEXDreg is
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

		jalAddressCarry : in std_logic_vector(31 downto 0);
		jalAddressCarryOut : out std_logic_vector(31 downto 0);
	 
		extnMuxOutCarry	: in std_logic_vector(31 downto 0);
		extnMuxOutCarryOut : out std_logic_vector(31 downto 0);
	 
		shiftCtrlCarry		: in std_logic_vector(1 downto 0);
		shiftCtrlCarryOut	: out std_logic_vector(1 downto 0);
		shiftSizeCarry		: in std_logic_vector(4 downto 0);
		shiftSizeCarryOut   : out std_logic_vector(4 downto 0);
	
		luiCarry			:in std_logic_vector(31 downto 0);
		luiCarryOut			:out std_logic_vector(31 downto 0);

		regDest		        :in std_logic_vector(4 downto 0);
		regDestO		    :out std_logic_vector(4 downto 0);

		immExtended : in std_logic_vector(31 downto 0);
		immExtendedO : out std_logic_vector(31 downto 0);
	
		ctrlSigs : in std_logic_vector(31 downto 0);
		ctrlSigsO : out std_logic_vector(31 downto 0));
   end component;
   
   
    component IFIDreg is
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

	end component;
	
	component HazardDetector9000 is
	port(
       iclk : in std_logic;
       iRST            : in std_logic;
	   IDEXMemWB 	   : in std_logic;
	   IDEXWriteAddr    : in std_logic_vector(4 downto 0);
	  
	   IFIDrt			: in std_logic_vector(4 downto 0);
	   IDEXrt			: in std_logic_vector(4 downto 0);
	   IFIDrs			: in std_logic_vector(4 downto 0);
	   JSig				: in std_logic_vector(2 downto 0); --2- Jump register, 1- Branch, 0- Jump and link
	   
	   IDecRegAddr		: in std_logic_vector(4 downto 0);
	   IDReadFrom1		: in std_logic_vector(4 downto 0);
	   IDReadFrom2		: in std_logic_vector(4 downto 0);
	   EXMEMRegAddr		: in std_logic_vector(4 downto 0);
	   MEMWBRegAddr 	: in std_logic_vector(4 downto 0);
	  
	   Flush,Stall		: out std_logic);
	   
	end  component;
	component memWbReg is
    port(
		writeE		:in std_logic;
		reset		:in std_logic;
		CLK		:in std_logic;

        i_WB				:in std_logic;
        o_WB				:out std_logic;
        flush,stall	:in std_logic;
    
    	DMemRead		:in std_logic_vector(31 downto 0);
		DMemReadO		:out std_logic_vector(31 downto 0);
	
		DMemWriteAddress	:in std_logic_vector(31 downto 0);
		DMemWriteAddressO	:out std_logic_vector(31 downto 0);
	
		luiCarry			:in std_logic_vector(31 downto 0);
		luiCarryOut			:out std_logic_vector(31 downto 0);
		
		jalAddressCarry : in std_logic_vector(31 downto 0);
		jalAddressCarryOut : out std_logic_vector(31 downto 0);
	
		regDest		        :in std_logic_vector(4 downto 0);
		regDestO		    :out std_logic_vector(4 downto 0);

		ctrlSigs : in std_logic_vector(31 downto 0);
		ctrlSigsO : out std_logic_vector(31 downto 0));
		end component;
		
	component dffa
	port(
		i_CLK        : in std_logic;     -- Clock input
		i_RST        : in std_logic;     -- Reset input
		i_WE         : in std_logic;     -- Write enable input
		i_D          : in std_logic;     -- Data value input
		o_Q          : out std_logic);   -- Data value output

	end component;
   		
		
	--hazardssss
	signal s_IFIDstall,s_IDEXflush,s_regHaltInter,s_DMemWrInterInter : std_logic := '0';
	signal s_Jsig : std_logic_vector(2 downto 0);
	signal s_readFrom1inter,s_readFrom2inter,s_Reg20downto16inter,s_Reg15downto11Ointer,s_IDecRegAddrinter : std_logic_vector(4 downto 0);
	signal s_currentOrIFIDInst,s_IDEXControlSigsInter : std_logic_vector(31 downto 0);
	
	--fowarding
	signal s_ALUINA,s_ALUINB,s_JumpCompareInA,s_JumpCompareInB,s_s_ALUINAMux,s_s_ALUINBMux,s_IDEXRegBInter : std_logic_vector(31 downto 0);
	signal s_IDEXShiftSizeInter : std_logic_vector(4 downto 0);
	signal s_EXRACtrl,s_EXRBCtrl,s_JCtrlMuxA,s_JCtrlMuxB,s_StoreControlMux: std_logic_vector(1 downto 0);


	--random
	signal s_DMemWrInter,s_HaltInter,enableInter  :std_logic;
	signal s_IDecRegAddr : std_logic_vector(4 downto 0);
	signal s_PCDumby : std_logic_vector(31 downto 0);
	--ifid
	signal s_IFIDEnable : std_logic;
	signal s_IFIDinstAd,s_IFIDInst : std_logic_vector(31 downto 0);
	
	--IDEX
	signal s_IDEXMem,s_IDEXWB : std_logic;
	signal s_IDEXShiftContrl : std_logic_vector(1 downto 0);
	signal s_IDEXOpcode : std_logic_vector(3 downto 0);
	signal s_IDEXRegAddress,s_IDEXReadAddA,s_IDEXReadAddB, s_IDEX20dt16, s_IDEX15dt10,s_IDEXShiftSize : std_logic_vector(4 downto 0);
	signal s_IDEXLUI,s_IDEXJAL,s_IDEXRegA,s_IDEXRegB,s_IDEXextenMux,s_IDEXImm : std_logic_vector(31 downto 0);
	
	--exmem
	signal s_EXMEMWB : std_logic;
	signal s_EXMEMRegDest : std_logic_vector(4 downto 0);
	signal s_EXMEMLUI,s_EXMEMJAL,s_EXMEMALU,s_EXMEMdatamem : std_logic_vector(31 downto 0);
	
	--memwb
	signal s_MemWBWB : std_logic;
    signal s_MEMWBLUI,s_MEMWBJAL,s_MemWBReadO, S_MemWBWriteAddress : std_logic_vector(31 downto 0);
	
	
	--Control Busses
	signal s_MEMWBControlSigs,s_MEMWBControlSigsO,s_EXMEMControlSigs,s_EXMEMControlSigsO,s_IDEXControlSigs,s_IDEXControlSigsO : std_logic_vector(31 downto 0);
	
begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.

	
  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_EXMEMALU(11 downto 2),
             data => s_EXMEMdatamem,
             we   => s_DMemWr, --s_DMemWr  																		--changed
             q    => s_DMemOut);

  s_HaltInter <='1' when (s_IFIDInst = x"0000000C") else '0';
  s_Halt <='1' when (s_MEMWBControlSigsO(3)='1') and (v0 = "00000000000000000000000000001010") else '0';
  s_RegWr <= '1' when (s_MemWBWB ='1' and not(s_Halt='1')) else '0';																				--changed

	--Hardwire values for our memwriteing / the synthesis
	s_DMemData <= s_EXMEMdatamem;
	s_DMemAddr <= s_EXMEMALU(31 downto 0);

	--our extender for immediate input
	zeroSignExtender_i : extender632
		port MAP(
			inp => s_IFIDInst(15 downto 0),
			ctrl => s_ExtendCtrl,
			outp => s_imm);
			
	--Dictates if we are reading from memory or the alu	
	nmux_i : nmux
		port MAP(
		i_A => S_MemWBWriteAddress,
		i_B => s_MemWBReadO,
		i_S => s_MEMWBControlSigsO(0),											   --TODO
		o_F => s_DMemAluMux);										--changed
		
	oALUOut <= s_RegWrData;   --leave this here its for the synthesis
		
	
	

	--stores all the values of our program registers
	progReg : regFile
		port MAP(
			clk => iCLK,
			reset => iRST,
			wEnable => s_RegWr,												--changed from s_RegWr
			writeTo => s_RegWrAddr, --s_RegWrAddr                            --changed can we just use regwraddr instead of the mux n shit?
			readFrom1 => s_readFrom1,
			readFrom2 => s_readFrom2,
			writeData => s_RegWrData,
			out_r1 => s_RegToA,
			out_r2 => s_RegToB,
			v0 => v0);
			
			
	s_IDEXShiftSizeInter <= s_ALUINB(4 downto 0) when s_EXRBCtrl = "01" else s_IDEXShiftSize;
	
	--Does most of our operations
	oALU:alu32
		port MAP(
		inA => s_ALUINA,
		inB => s_ALUINB,
		sel => s_IDEXOpcode,
		shiftSize => s_IDEXShiftSizeInter, 
		shiftCtrl => s_IDEXShiftContrl,
		signOrUnsign => s_IDEXControlSigsO(31),
		overflow => s_overflow,
		carryOut => s_carryOut,
		zero => s_zero,
		o_F => s_aluToMux);
		
  -- TODO: Implement the rest of your processor below this comment! 
    with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0', --Determines if reseting program counter or going to next instruction
      iInstAddr when others;

	rstPRC : process(iRst,iCLK,s_Halt)
	begin
		if(iRst = '1') then
			s_NextInstAddr <= x"00400000"; --Reset to 0x0040000
		elsif(rising_Edge(iClk)) then
			s_NextInstAddr <= s_JregCtrlOut;  --pc target
		end if;

	end process;
	  

	--Takes an instruction from the decoder and breaks it into various control signals
	Decoder : IDecode
		port MAP(
		Instruct => s_IFIDInst,
		enable	 => s_IFIDEnable,
		DMemWr => s_DMemWrInter,
		load => s_load,
		RegWr => s_regHalt,
		ReadA => s_readFrom1,
		ReadB => s_readFrom2,
		RegWrAddr => s_IDecRegAddr,
		ShiftSize => s_ShiftSizeDec,
		ShiftContrl => s_ShiftContrl,
		ExtendCtrl => s_ExtendCtrl,
		ALUSrc => s_ALUSrc,
		ALUCtrl => s_ALUCtrl,
		LuiCTRL => s_LUiCTRL,
		VShift => s_VShift,
		BComp => s_BComp,
		beqCtrl	=> s_beqCtrl,
		jumpCtrl => s_jumpCtrl,
		JalCtrl	=> s_JalCtrl,
		JregCtrl => s_JregCtrl);
		

	--Adds four to the program counter every cycle

	--Mux to dictate if we are doing an extend or not (used for imediate adding)
	MuxAluSrc : for i in 0 to n-1 generate
		s_extnMux(i) <= (s_RegToB(i) and not(s_ALUSrc)) or (s_imm(i) and s_ALUSrc);
	end generate;
	
	--Mux to dictate if we are doing a lui or not
	s_LuiVal <= s_IFIDInst(15 downto 0) & x"0000";
	MuxLUI : for i in 0 to n-1 generate
		s_RegWrDataInter(i) <= (s_DMemAluMux(i) and not(s_MEMWBControlSigsO(1))) or (s_MEMWBLUI(i) and s_MEMWBControlSigsO(1));
	end generate;
	
	--Mux to dictate if we do a variable shift or not.
	ShiftSizeMux : for i in 0 to 4 generate
		s_ShiftSize(i) <= (s_ShiftSizeDec(i) and not (s_VShift)) or (s_extnMux(i) and s_VShift);
	end generate;
	
	--Below here we have our jump controls

	--IF BEQ and the b is eq or bneq and the b isnt eq
	s_beqRes <= (s_BComp and (not s_beqCtrl) and s_zeros1) or (s_BComp and (s_beqCtrl) and (not s_zeros1)) or s_jumpCtrl;

	--mux between current instruction and ifid instruction hazzard stuff
	
	s_currentOrIFIDInst <= "00000000000000000000000000000000" when (s_IFIDstall='1') else "00000000000000000000000000000100";
	
	--pc+4
	pcAdder : FullAddNBitDataFlow
	port MAP(
			inputa => s_NextInstAddr,
			inputb => s_currentOrIFIDInst,
			carry => '0',
			sum => s_pcAdder,
			carry_out => open);

	--Shift immediate (label) left by 2
	s_Shift2out <= s_imm(29 downto 0) & "00";
	
	--Build relative jump location
	s_JLoc <= s_pcAdder(31 downto 28) & s_IFIDInst(25 downto 0) & "00";    					--changed from pcadder
	

	--PC+4+offset
	pcRelCalc : FullAddNBitDataFlow
	port MAP(
			inputa => s_IFIDinstAd, --pc+4 but now it's from ifif 							--changed from pcAdder
			inputb => s_Shift2out, --immediate shifted
			carry => '0',
			sum => s_RelOffSet,
			carry_out => open);

	--Switch between bcomp jump and R type jump
	--if jctrl is 0 do a branch, else do a jump
	JCTRLMUX : for i in 0 to n-1 generate
		s_jCtrlOut(i) <= (s_RelOffSet(i) and ( not s_jumpCtrl)) or (s_JLoc(i) and s_jumpCtrl);
	end generate;

	--Mux between pc_adder and s_RelOffSet based on s_beqRes
	JumpMux : for i in 0 to n-1 generate
		s_JumpMuxOut(i) <= (s_pcadder(i) and (( not s_beqRes) or s_IDEXControlSigsO(30))) or (s_jCtrlOut(i) and s_beqRes and not s_IDEXControlSigsO(30));	--changed from pcAdder
	end generate;
	
	
	--s_JregCtrlOut
	--switch between s_jCtrlOut and Output from register A
	s_PCDumby <= x"00400000";
	JRMUX : for i in 0 to n-1 generate
		s_JregCtrlOut(i) <= ((( s_JumpMuxOut(i) and ((not s_JregCtrl) or s_IDEXControlSigsO(30))) or ( s_RegToA(i) and (s_JregCtrl and not s_IDEXControlSigsO(30))))and not iRST); -- or (iRST and s_PCDumby(i));
	end generate;
	
	--Load current pc if s_jalCTRL
	JalMUX : for i in 0 to n-1 generate
		s_RegWrData(i) <= (s_RegWrDataInter(i) and ( not s_MEMWBControlSigsO(2))) or (s_MEMWBJAL(i) and s_MEMWBControlSigsO(2)); --todo use this to be carried through,inter is generated in the last cycle, jal needs to be carried
	end generate;	
	
	
	
	
	--pipelining below this line
	earlyequals : equalComparator
	port MAP ( 
		inputa => s_JumpCompareInA,
	    inputb => s_JumpCompareInB,
		equals => s_zeros1);
	enableInter <= not IRST;
	s_Jsig <=  s_JregCtrl & s_IDEXControlSigsO(30) & s_JalCtrl;

--s_EXMEMControlSigsO
	-- 0=load 1= lui, 2=jal,
	with s_EXMEMControlSigsO(2 downto 0)select
		s_s_ALUINAMux <=    s_EXMEMLUI   when "010",
							s_EXMEMJAL 	 when "100",
							s_DMemOut when "001",
							s_EXMEMALU when others;
		with s_EXMEMControlSigsO(2 downto 0) select
		s_s_ALUINBMux <=    s_EXMEMLUI   when "010",
							s_EXMEMJAL 	 when "100",
							s_DMemOut when "001",
							s_EXMEMALU when others;
	
	with s_EXRACtrl select
		 s_ALUINA <= s_RegWrData when "01",
					 s_s_ALUINAMux  when "10",
					 s_IDEXRegA  when others;
					 
					 
	with s_EXRBCtrl select
		 s_ALUINB <= s_RegWrData when "01",
					 s_s_ALUINBMux  when "10",
					 s_IDEXextenMux  when others;
					 
	with s_JCtrlMuxA select
		s_JumpCompareInA  <= s_RegWrData when "01",
							 s_aluToMux  when "10",
							 s_EXMEMALU when "11",
							 s_RegToA	 when others;
							 
	with s_JCtrlMuxB select
		s_JumpCompareInB  <= s_RegWrData when "01",
							 s_aluToMux  when "10",
							 s_EXMEMALU when "11",
							 s_RegToB	 when others;
							 
							 

	with s_StoreControlMux select
		 s_IDEXRegBInter <= s_s_ALUINBMux when "01",
							s_RegWrData	  when "10",
							s_IDEXRegB	  when others;
	
	forward : Fowardatroninator9000
	port MAP(
		IDEXRS			=> s_IDEXReadAddA,
		IDEXRT			=> s_IDEXReadAddB,
		EXMEMWrAddr		=> s_EXMEMRegDest,
		EXMEMWrAddrBefore => s_IDEXRegAddress,
		MEMWBwrAddr		=> s_RegWrAddr,
		IFIDrt			=> s_IFIDInst(20 downto 16),
		IFIDrs			=> s_IFIDInst(25 downto 21),
		EXMEMWB			=> s_EXMEMWB,
		EXMEMStore		=> s_IDEXMem,
		MEMWBWB			=> s_MemWBWB,
		IDEXWB			=> s_IDEXWB,
		BranchCtrl		=> s_BComp, -- ?
		JRegCtrl		=> s_JregCtrl,
		ImmCtrl			=> s_IDEXControlSigsO(29),
		o_EXRACtrl		=> s_EXRACtrl,
		o_EXRBCtrl		=> s_EXRBCtrl,
		o_JCtrlMuxA		=> s_JCtrlMuxA,
		o_JCtrlMuxB		=> s_JCtrlMuxB,
		o_StoreDataCtrl	=> s_StoreControlMux);
	
	
	hazzard : HazardDetector9000
	port MAP(
	iclk => iCLK,
       iRST            => iRST,
	   IDEXMemWB 	    => s_IDEXControlSigsO(0),
	   IDEXWriteAddr     => s_IDEXRegAddress,
	   IFIDrt			=> s_IFIDInst(20 downto 16),
	   IDEXrt			=> s_IDEX20dt16,
	   IFIDrs			=> s_IFIDInst(25 downto 21),
	   JSig				 => s_Jsig,
	   IDecRegAddr		 => s_IDecRegAddr,
	   IDReadFrom1		 => s_readFrom1,
	   IDReadFrom2		 => s_readFrom2,
	   EXMEMRegAddr		 => s_EXMEMRegDest,
	   MEMWBRegAddr 	 => s_RegWrAddr,
	   Flush			 => s_IDEXflush,
	   Stall			 => s_IFIDstall);
	   	
	
	IFID : IFIDreg
	port MAP(
        clk    => iCLK,
        reset  => iRst,
		flush		=> '0',
		stall 		=> s_IFIDstall,
		writeE => '1',
        inst   => s_Inst,
        instAd => s_pcAdder,--: in std_logic_vector(31 downto 0);
        instO    => s_IFIDInst, --out std_logic_vector(31 downto 0);
        instAdO  => s_IFIDinstAd, --out std_logic_vector(31 downto 0);
	enablein => enableInter,
	enableout => s_IFIDEnable
	);
	


	s_regHaltInter <= '0' when (not(s_IDEXflush = '0') and not s_JalCtrl='1') else s_regHalt;
	s_DMemWrInterInter <= '0' when not(s_IDEXflush = '0') else s_DMemWrInter;
	s_IDEXControlSigsInter <= "00000000000000000000000000000000" when (not(s_IDEXflush = '0') and not s_JalCtrl='1') else s_IDEXControlSigs;

	s_readFrom1inter <= "00000" when not(s_IDEXflush = '0') else s_readFrom1;
	s_readFrom2inter <= "00000" when not(s_IDEXflush = '0') else s_readFrom2;
	s_Reg20downto16inter <= "00000" when not(s_IDEXflush = '0') else s_IFIDInst(20 downto 16);
	s_Reg15downto11Ointer <= "00000" when not(s_IDEXflush = '0') else s_IFIDInst(15 downto 11);
	s_IDecRegAddrinter <= "00000" when (not(s_IDEXflush = '0') and not s_JalCtrl='1') else s_IDecRegAddr;
	
	IDEX : IDEXDReg
   	 port MAP (
     writeE		=>'1',
	 reset		=> iRst,
	 CLK		=> iCLK,
	
     i_WB		=> s_regHaltInter, --:in std_logic; --Write Back
	 o_WB		=> s_IDEXWB, --:out std_logic;
	 i_M		=> s_DMemWrInterInter, --:in std_logic; --Memory
     o_M	    => s_IDEXMem, --:out std_logic;
	 flush		=> '0',
	 stall 		=> '0',

     opcode      => s_ALUCtrl, --:in std_logic;: in std_logic_vector(31 downto 0);
     opcodeO     => s_IDEXOpcode, --: out std_logic_vector(31 downto 0);

     RegA  => s_RegToA, --:in std_logic;: in std_logic_vector(31 downto 0);
	 RegB  => s_RegToB, --:in std_logic;: in std_logic_vector(31 downto 0);
     RegAO => s_IDEXRegA, --: out std_logic_vector(31 downto 0);
	 RegBO => s_IDEXRegB, --: out std_logic_vector(31 downto 0);

     RegAddressA    => s_readFrom1inter, --:in std_logic;: in std_logic_vector(4 downto 0);
 	 RegAddressB    => s_readFrom2inter, --:in std_logic;: in std_logic_vector(4 downto 0);
     RegAddressAO   => s_IDEXReadAddA, --:in std_logic;: in std_logic_vector(4 downto 0);
	 RegAddressBO   => s_IDEXReadAddB, --: out std_logic_vector(4 downto 0);

     Reg20downto16 => s_Reg20downto16inter, --:in std_logic_vector(4 downto 0);
	 Reg15downto11 => s_Reg15downto11Ointer, --: in std_logic_vector(4 downto 0);
     Reg20downto16O => s_IDEX20dt16, --: out std_logic_vector(4 downto 0);
	 Reg15downto11O => s_IDEX15dt10, --: out std_logic_vector(4 downto 0);

     immExtended => s_imm, --: in std_logic_vector(31 downto 0);
     immExtendedO => s_IDEXImm, --: out std_logic_vector(31 downto 0));
		
	 jalAddressCarry 	 =>  s_IFIDinstAd,
	 jalAddressCarryOut	 =>  s_IDEXJAL,
	 
	 extnMuxOutCarry	=> s_extnMux,
	 extnMuxOutCarryOut => s_IDEXextenMux,
	 
	 shiftCtrlCarry		=>s_ShiftContrl,
	 shiftCtrlCarryOut	=>s_IDEXShiftContrl,
	 shiftSizeCarry		=> s_ShiftSize,
	 shiftSizeCarryOut  => s_IDEXShiftSize,
	
	 luiCarry		=>s_LuiVal,
	 luiCarryOut	=>s_IDEXLUI,
	 
	 regDest		=> s_IDecRegAddrinter,
	 regDestO		=> s_IDEXRegAddress, 
	 
	 --0= DMem/ALU Mux, 1=lui,2= jal, 3=shalt 31 =s_ExtendCtrl
	 ctrlSigs		=> s_IDEXControlSigsInter,
	 ctrlSigsO		=> s_IDEXControlSigsO
	 

   );
   
   --Carry through the signal for the final mux
	s_IDEXControlSigs(0) <= s_load;
	s_IDEXControlSigs(1) <= s_LUiCTRL;
	s_IDEXControlSigs(2) <= s_JalCtrl;
	s_IDEXControlSigs(3) <= s_HaltInter;
	s_IDEXControlSigs(4) <= s_DMemWrInter;
	s_IDEXControlSigs(29) <= s_ALUSrc;
	s_IDEXControlSigs(30) <= s_beqRes;
	s_IDEXControlSigs(31) <= s_ExtendCtrl;
   

	
	EXMEM : EXMEMreg
      port MAP(
        clk          =>iCLK,
        reset        => iRst,
        writeE       =>'1',

        i_WB        =>s_IDEXWB, --:in std_logic;     --Write Back
        o_WB        =>s_EXMEMWB, --  : out std_logic;
        i_M         => s_IDEXMem, --:in std_logic;     --Memory
        o_M         => s_DMemWr, -- : out std_logic;
		flush		=> '0',
		stall 		=> '0',

        aluOut      => s_aluToMux, --:in std_logic;: in std_logic_vector(31 downto 0); --Ouput of ALU
        aluOutO     => s_EXMEMALU, -- : out std_logic_vector(31 downto 0);

        dataMem     => s_IDEXRegBInter, --:in std_logic;: in std_logic_vector(31 downto 0);		 --what it was unless foward is 11 then we need to foward s_aluToMux
        dataMemO    => s_EXMEMdatamem, --: out std_logic_vector(31 downto 0);

        regDest     => s_IDEXRegAddress,--:in std_logic_vector(4 downto 0);: in std_logic_vector(4 downto 0);
        regDestO    => s_EXMEMRegDest, --: out std_logic_vector(4 downto 0));
		
		
		luiCarry		=> s_IDEXLUI,
		luiCarryOut		=> s_EXMEMLUI,
		
		jalAddressCarry 	 => s_IDEXJAL,
		jalAddressCarryOut	 => s_EXMEMJAL,
		--0=finalmux, 1=luicontrol, 2=jalCtrl,3=s_halt
		ctrlSigs		=> s_EXMEMControlSigs,
		ctrlSigsO		=> s_EXMEMControlSigsO
		
		);
		
	--0=finalmux, 1=luicontrol, 2=jalCtrl,3=s_halt
	s_EXMEMControlSigs(4 downto 0) <= s_IDEXControlSigsO(4 downto 0);
	
	memWB :  memWbReg                                                                        --changed fully hooked up?
     port MAP(
     writeE		=>'1',
	reset		=> iRst,
	CLK			=> iCLK,

        i_WB				=> s_EXMEMWB, --:in std_logic;
        o_WB				=> s_MemWBWB, --:out std_logic;
	flush		=> '0',
	stall 		=> '0',
    
    DMemRead		  => s_DMemOut,--:in std_logic_vector(31 downto 0);
	DMemReadO			=> s_MemWBReadO, --:out std_logic_vector(31 downto 0);
	
	DMemWriteAddress	=>s_EXMEMALU,--:in std_logic_vector(31 downto 0);  s_DMemAddr
	DMemWriteAddressO	=> S_MemWBWriteAddress, --:out std_logic_vector(31 downto 0);
	
	regDest		    =>	s_EXMEMRegDest,--:in std_logic_vector(4 downto 0);
	regDestO		    => s_RegWrAddr, --:out std_logic_vector(4 downto 0));
		
	luiCarry	=> s_EXMEMLUI,
	luiCarryOut	=> s_MEMWBLUI,
		
	jalAddressCarry 	 => s_EXMEMJAL,
	jalAddressCarryOut	 => s_MEMWBJAL,
		
		--0=finalmux, 1=luicontrol, 2=jalCtrl,3=s_halt
	ctrlSigs		=> s_MEMWBControlSigs,
	ctrlSigsO		=> s_MEMWBControlSigsO
);
	--0=finalmux, 1=luicontrol, 2=jalCtrl,3=s_halt
	s_MEMWBControlSigs(4 downto 0) <= s_EXMEMControlSigsO(4 downto 0);
	
	--marswork/examples/proj-b_test1.s to run first test
end structure;
