-------------------------------------------------------------------------
-- Henry Duwe
-- Ben Pierre
-- Eric Marcino
-- Thomas Beckler
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
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
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. This case happens when the syscall instruction is observed and the V0 register is at 0x0000000A. This signal is active high and should only be asserted after the last register and memory writes before the syscall are guaranteed to be completed.





  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment
  	component IDecode is
	port(
		Instruct	: in std_logic_vector(31 downto 0);
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
  signal s_LuiMux : std_logic_vector(N-1 downto 0);
  signal s_regHalt : std_logic;
  signal s_ShiftSizeDec : std_logic_vector(4 downto 0);
  signal s_VShift : std_logic;
  signal s_dmemInter : std_logic_vector(29 downto 0);
  --j signals
  signal s_BComp,s_beqCtrl,s_jumpCtrl,s_JalCtrl	,s_JregCtrl,s_beqRes : std_logic :='0';
  signal s_JumpMuxOut,s_Shift2out,s_RelOffSet,s_JLocMux,s_JLoc,s_jCtrlOut,s_RegWrDataInter,s_JregCtrlOut : std_logic_vector(31 downto 0) :=x"00000000";

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
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  s_Halt <='1' when (s_Inst = x"0000000C") and (v0 = "00000000000000000000000000001010") else '0';
  s_RegWr <= s_regHalt and not(s_Halt);

	--Hardwire values for our memwriteing
	s_DMemData <= s_RegToB;
	s_DMemAddr <= s_aluToMux(31 downto 0);

	--our extender for immediate input
	zeroSignExtender_i : extender632
		port MAP(
			inp => s_Inst(15 downto 0),
			ctrl => s_ExtendCtrl,
			outp => s_imm);
			
	--Dictates if we are reading from memory or the alu	
	nmux_i : nmux
		port MAP(
		i_A => s_aluToMux,
		i_B => s_DMemOut,
		i_S => s_load,
		o_F => s_LuiMUX);
		
		
		oALUOut <= s_RegWrData;   --s_RegWrDataInter
		
	


	--stores all the values of our program registers
	progReg : regFile
		port MAP(
			clk => iCLK,
			reset => iRST,
			wEnable => s_RegWr,
			writeTo => s_RegWrAddr,
			readFrom1 => s_readFrom1,
			readFrom2 => s_readFrom2,
			writeData => s_RegWrData,
			out_r1 => s_RegToA,
			out_r2 => s_RegToB,
			v0 => v0);
			
	--Does most of our operations
	oALU:alu32
		port MAP(
		inA => s_RegToA,
		inB => s_extnMux,
		sel => s_ALUCtrl,
		shiftSize => s_ShiftSize,
		shiftCtrl => s_ShiftContrl,
		signOrUnsign => s_ExtendCtrl,
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
		Instruct => s_Inst,
		DMemWr => s_DMemWr,
		load => s_load,
		RegWr => s_regHalt,
		ReadA => s_readFrom1,
		ReadB => s_readFrom2,
		RegWrAddr => s_RegWrAddr,
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
	s_LuiVal <= s_Inst(15 downto 0) & x"0000";
	MuxLUI : for i in 0 to n-1 generate
		s_RegWrDataInter(i) <= (s_LuiMUX(i) and not(s_LUiCTRL)) or (s_LuiVal(i) and s_LUiCTRL);
	end generate;
	
	--Mux to dictate if we do a variable shift or not. Note we use s_ALUSrc to save signal wires
	ShiftSizeMux : for i in 0 to 4 generate
		s_ShiftSize(i) <= (s_ShiftSizeDec(i) and not (s_VShift)) or (s_extnMux(i) and s_VShift);
	end generate;
	
	
	--Below here we have our jump controls

	--IF BEQ and the b is eq or bneq and the b isnt eq
	s_beqRes <= (s_BComp and (not s_beqCtrl) and s_zero) or (s_BComp and (s_beqCtrl) and (not s_zero)) or s_jumpCtrl;


	--pc+4
	pcAdder : FullAddNBitDataFlow
	port MAP(
			inputa => s_NextInstAddr,
			inputb => "00000000000000000000000000000100",
			carry => '0',
			sum => s_pcAdder,
			carry_out => open);

	--Shift immediate (label) left by 2
	s_Shift2out <= s_imm(29 downto 0) & "00";
	
	--Build relative jump location
	s_JLoc <= s_pcAdder(31 downto 28) & s_Inst(25 downto 0) & "00";
	

	--PC+4+offset
	pcRelCalc : FullAddNBitDataFlow
	port MAP(
			inputa => s_pcAdder, --pc+4
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
		s_JumpMuxOut(i) <= (s_pcAdder(i) and ( not s_beqRes)) or (s_jCtrlOut(i) and s_beqRes);
	end generate;
	
	--s_JregCtrlOut
	--switch between s_jCtrlOut and Output from register A
	JRMUX : for i in 0 to n-1 generate
		s_JregCtrlOut(i) <= ( s_JumpMuxOut(i) and (not s_JregCtrl)) or ( s_RegToA(i) and s_JregCtrl);
	end generate;
	
	--Load current pc if s_jalCTRL
	JalMUX : for i in 0 to n-1 generate
		s_RegWrData(i) <= (s_RegWrDataInter(i) and ( not s_JalCtrl)) or (s_pcAdder(i) and s_JalCtrl);
	end generate;

	

	--marswork/examples/proj-b_test1.s to run first test
end structure;
