-- This is the testbench for the MIPSProcessor.VHD

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Processor is
	
	generic
	(
		gCLK_HPER   : time := 50 ns
	);

end tb_Processor;


architecture behavior of tb_Processor is

component MIPSProcessor2

port(		Rd1,Rd2	 : in 	std_logic_vector(4 downto 0);
		W_addr	 : in 	std_logic_vector(4 downto 0);
		CLK	 : in 	std_logic;
		Reset	 : in 	std_logic;
		Enable   : in	std_logic;
		nAdd_Sub : in 	std_logic;
		ALUSrc	 : in 	std_logic;
		Extended : in   std_logic;
		load	 : in   std_logic;
		Immd	 : in 	std_logic_vector(15 downto 0);
		test	 : out	std_logic_vector(31 downto 0)
	);

end component;

constant cCLK_PER  	: time := gCLK_HPER * 2;
signal S_clk, S_Reset, S_Enable, S_nAdd_Sub, S_ALUSrc, S_Extended, S_load : std_logic;
signal S_rd1, S_rd2, S_W_addr : std_logic_vector(4 downto 0);
signal S_Immd : std_logic_vector(15 downto 0);
signal S_test : std_logic_vector(31 downto 0);

begin

G_MIPS: MIPSProcessor2
port map(
	Rd1	=> S_rd1,
	Rd2	=> S_rd2,
	W_addr	=> S_W_addr,
	CLK	=> S_clk,
	Reset	=> S_Reset,
	Enable	=> S_Enable, 
	nAdd_sub=> S_nAdd_Sub,
	ALUSrc	=> S_ALUSrc,
	Extended=> S_Extended,
	load	=> S_load,
	Immd	=> S_Immd,
	test	=> S_test );

G_CLK: process
 begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;

G_TB : process
 begin
	S_Reset		<= '1'; --Start
	S_Enable	<= '0';
	S_nAdd_sub	<= '0';
	S_ALUSrc	<= '0';
	S_Extended	<= '0';
	S_load		<= '0';
	S_Rd1		<= "00000";
	S_Rd2		<= "00000";
	S_Immd		<= "0000000000000000";
	S_W_addr	<= "00000";
		wait for cCLK_PER;
	S_ALUSrc	<= '1'; --Addi $25, $0, 0
	S_Reset		<= '0';
	S_Immd		<= "0000000000000000";
	S_W_addr	<= "11001";
	S_rd1		<= "00000";
		wait for cCLK_PER;
	S_Immd		<= "0000000100000000"; 	--Addi $26, $0, 256
	S_W_addr	<= "11010";
	
		wait for cCLK_PER;
	S_Immd		<= "0000000000000000"; --lw $1, 0($25)
	S_load		<= '1';
	S_W_addr	<= "00001";
	S_rd1		<= "11001";
	S_Extended	<= '1';
		wait for cCLK_PER;
	S_W_addr	<="00010"; --lw $2, 4($25)
	S_Immd		<="0000000000000001";
		wait for cCLK_PER;
	S_Extended	<= '0';
	S_load		<='0'; -- add $1, $1, $2
	S_ALUSrc	<='0';
	S_W_addr	<= "00001";
	S_rd1		<= "00001";
	s_rd2		<= "00010";
		wait for cCLK_PER;
	S_Enable	<= '1'; --sw $1, 0($26)
	S_rd1		<= "11010";
	S_rd2		<= "00001";
	S_ALUSrc	<= '1';
	S_Immd		<="0000000000000000";
		wait for cCLK_PER;
	S_W_addr	<= "00010"; -- lw $2, 8($25)
	S_Extended	<= '1';
	S_load		<= '1';
	S_Enable	<= '0';
	S_rd1		<= "11001";
	S_Immd		<="0000000000000010";
		wait for cCLK_PER;
	S_load		<='0'; -- add $1, $1, $2
	S_Extended	<= '0';
	S_ALUSrc	<='0';
	S_W_addr	<= "00001";
	S_rd1		<= "00001";
	s_rd2		<= "00010";
		wait for cCLK_PER;
	S_Enable	<= '1'; --sw $1, 4($26)
	S_rd1		<= "11010";
	S_rd2		<= "00001";
	S_ALUSrc	<= '1';
	S_Immd		<="0000000000000001";
		wait for cCLK_PER;
	S_W_addr	<= "00010"; -- lw $2, 12($25)
	S_Extended	<= '1';
	S_load		<= '1';
	S_Enable	<= '0';
	S_rd1		<= "11001";
	S_Immd		<="0000000000000011";
		wait for cCLK_PER;
	S_load		<='0'; -- add $1, $1, $2
	S_Extended	<= '0';
	S_ALUSrc	<='0';
	S_W_addr	<= "00001";
	S_rd1		<= "00001";
	s_rd2		<= "00010";
		wait for cCLK_PER;
	S_Enable	<= '1'; --sw $1, 8($26)
	S_rd1		<= "11010";
	S_rd2		<= "00001";
	S_ALUSrc	<= '1';
	S_Immd		<="0000000000000010";
		wait for cCLK_PER;
	S_W_addr	<= "00010"; -- lw $2, 16($25)
	S_Extended	<= '1';
	S_load		<= '1';
	S_Enable	<= '0';
	S_rd1		<= "11001";
	S_Immd		<="0000000000000100";
		wait for cCLK_PER;
	S_load		<='0'; -- add $1, $1, $2
	S_Extended	<= '0';
	S_ALUSrc	<='0';
	S_W_addr	<= "00001";
	S_rd1		<= "00001";
	s_rd2		<= "00010";
		wait for cCLK_PER;
	S_Enable	<= '1'; --sw $1, 12($26)
	S_rd1		<= "11010";
	S_rd2		<= "00001";
	S_ALUSrc	<= '1';
	S_Immd		<="0000000000000011";
		wait for cCLK_PER;
	S_W_addr	<= "00010"; -- lw $2, 20($25)
	S_Extended	<= '1';
	S_load		<= '1';
	S_Enable	<= '0';
	S_rd1		<= "11001";
	S_Immd		<="0000000000000101";
		wait for cCLK_PER;
	S_load		<='0'; -- add $1, $1, $2
	S_ALUSrc	<='0';
	S_Extended	<= '0';
	S_W_addr	<= "00001";
	S_rd1		<= "00001";
	s_rd2		<= "00010";
		wait for cCLK_PER;
	S_Enable	<= '1'; --sw $1, 16($26)
	S_rd1		<= "11010";
	S_rd2		<= "00001";
	S_ALUSrc	<= '1';
	S_Immd		<="0000000000000100";
		wait for cCLK_PER;
	S_W_addr	<= "00010"; -- lw $2, 20($25)
	S_load		<= '1';
	S_Extended	<= '1';
	S_Enable	<= '0';
	S_rd1		<= "11001";
	S_Immd		<="0000000000000110";
		wait for cCLK_PER;
	S_load		<='0'; -- add $1, $1, $2
	S_ALUSrc	<='0';
	S_Extended	<= '0';
	S_W_addr	<= "00001";
	S_rd1		<= "00001";
	s_rd2		<= "00010";
		wait for cCLK_PER;
	S_ALUSrc	<= '1'; --Addi $27, $0, 512
	S_Immd		<= "0000000010000000";
	S_W_addr	<= "11011";
	S_rd1		<= "00000";
		wait for cCLK_PER;
	S_Enable	<= '1'; --sw $1, 12($27)
	S_rd1		<= "11011";
	S_rd2		<= "00001";
	S_ALUSrc	<= '1';
	S_nAdd_sub	<= '1';
	S_Immd		<="0000000000000001";
		wait for cCLK_PER;
wait for cCLK_PER;
wait for cCLK_PER;
wait for cCLK_PER;
wait for cCLK_PER;

 end process;

end behavior;