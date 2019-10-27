-------------------------------------------------------------------------
-- Eric Marcanio
-------------------------------------------------------------------------
-- DESCRIPTION: Tb for the instruction decode

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity IDecodetb is



end IDecodetb;

architecture structure of IDecodetb is

component IDecode
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
	ALUCtrl		: out std_logic_vector(3 downto 0)	--
);
end component;

--Input--
signal S_Instruct : std_logic_vector(31 downto 0);
--Output--
signal S_DmemWr, S_load, S_RegWr, S_ExtendCtrl, S_ALUSrc : std_logic;
signal S_ReadA, S_ReadB, S_ShiftSize, S_RegWrAddr : std_logic_vector(4 downto 0);
signal S_ShiftContrl : std_logic_vector(1 downto 0);
signal S_ALUCtrl : std_logic_vector(3 downto 0); 

begin

test: entity work.IDecode port map(S_Instruct, S_DmemWr, S_load, S_RegWr, S_ReadA, S_ReadB, S_RegWrAddr, S_ShiftSize, S_ShiftContrl, S_ExtendCtrl, S_ALUSrc, S_ALUCtrl);

Decode : IDecode
 port map(	Instruct => S_Instruct,
		DMemWr	 => S_DmemWr,
		load 	 => S_load,
		RegWr	 => S_RegWr,
		ReadA	 => S_ReadA,
		ReadB	 => S_ReadB,
		RegWrAddr=> S_RegWrAddr,
		ShiftSize=> S_ShiftSize,
		ShiftContrl => S_ShiftContrl,
		ExtendCtrl=> S_ExtendCtrl,
		ALUSrc	 => S_ALUSrc,
		ALUCtrl  => S_ALUCtrl);


testing: process
begin
	--Addi
	S_Instruct	<= "00100000101010000000000000000010"; -- (addi r8, r5, 2) r8 = r5 + 2
	wait for 100 ns;
	--Addiu
	S_Instruct	<= "00100100111001110000000000000110"; --(addiu r7, r7, 6) r7 = r7 + 6
	wait for 100 ns;
	--Andi
	S_Instruct	<= "00110000110001000000000011111111"; --(Andi  r4, r6, 255 )  r4 = r6 && 255
	wait for 100 ns;
	--Lui
	S_Instruct	<= "00111100111001000000111000011111"; --(lui r4, 3615) lui 001111
	wait for 100 ns;
	--Lw
	S_Instruct	<= "10001100110001000000000000001111"; --(lw r4, (15)r6) lw  100011
	wait for 100 ns;
	--Xori
	S_Instruct	<= "00111000111000110000000000000111"; --xori 001110 (xori r3, r7, 7) r3 = r7 xor 7
	wait for 100 ns;
	--Ori
	S_Instruct	<= "00110100011000100000000011111111"; --ori 001101 (ori r2, r3, 255) r2 = r3 || 255
	wait for 100 ns;
	--Slti
	S_Instruct	<= "00101000010000110000000000000100"; --slti 001010 (slti r3, r2, 4) r3 = r2 < 4
	wait for 100 ns;
	--sltiu
	S_Instruct	<= "00101100111000110000000000000111"; --sltiu 001011 (sltiu r3, r7, 7) r3 = r7 < 7
	wait for 100 ns;
	--sw
	S_Instruct	<= "10101100011000100000000000000010"; --sw 101011 (sw r2,(2)r3)
	wait for 100 ns;
	--Add
	S_Instruct	<= "00000000011010000000100000100000"; -- 3 + 8 = R1
	wait for 100 ns;
	--Addu
	S_Instruct	<= "00000000111010000001000000100000"; -- 7 + 8 = R2
	wait for 100 ns;
	--And
	S_Instruct	<= "00000001000010000010000000100100"; -- 8 and 8 =  R4
	wait for 100 ns;
	--Nor
	S_Instruct	<= "00000000001100000100000000100111"; -- 16 NOR 1 = R8
	wait for 100 ns;
	--XOR
	S_Instruct	<= "00000001111001100001100000100110"; -- 15 XOR 6 = R3
	wait for 100 ns;
	--OR
	S_Instruct	<= "00000000111010000001000000100101"; -- 7 OR 8 = R2
	wait for 100 ns;
	--slt
	S_Instruct	<= "00000000010001010100100000101010"; --slt func(101010) (slt r9, r2, r5) r9 = r2 < r5
	wait for 100 ns;
	--sltu
	S_Instruct	<= "00000000101000100100000000101011"; --sltu func(101011) (sltu r8, r5, r2) r8 = r5 < r2
	wait for 100 ns;
	--sll
	S_Instruct	<= "00000000000000100001001000000000"; --sll func(000000) (sll r2, r2, 8) r2 = r2 << 8
	wait for 100 ns;
	--srl
	S_Instruct	<= "00000000000000100001000100000010" ;--srl func(000010) (sll r2, r2, 4) r2 = r2 >> 4
	wait for 100 ns;
	--sra
	S_Instruct	<= "00000000000001010001100010000011" ;--sra func(000011) (sra r3, r5, 2) r3 = r5 >> 2
	wait for 100 ns;
	--sllv
	S_Instruct	<= "00000000011010000101000000000100";--sllv func(000100) (sllv r10, r3, r8) r10 = r3 << r8
	wait for 100 ns;
	--srlv
	S_Instruct	<= "00000000011010000100100000000110";--srlv func(000110) (srlv r9, r3, r8) r9 = r3 >> r8
	wait for 100 ns;
	--srav
	S_Instruct	<= "00000001010010000011100000000111";--srav func(000111) (srav r7, r10, r8) r7 = r10 >> r8
	wait for 100 ns;
	--sub
	S_Instruct	<= "00000001010010010011000000100010";--sub func(100010) (sub r6, r10, r9) r6 = r10-r9
	wait for 100 ns;
	--subu
	S_Instruct	<= "00000001001010100110000000100011";--subu func(100011) (subu r12, r9, r10) r12 = r9-r10
	wait for 100 ns;



end process;


end structure;