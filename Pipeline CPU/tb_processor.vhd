library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_processor is
	generic 
	(
		N : natural := 32;
		ADDR_WIDTH : natural := 10;
		gclk_help : time := 50 ns
	);

end tb_processor;
architecture structure of tb_processor is
--components
component processor
 port 
	(
		clk,reset,store,extSel,load,nAdd_sub,aluSrc	: in std_logic;
		writeTo,readFrom1,readFrom2     : in std_logic_vector(4 downto 0);
		immediate	        : in std_logic_vector(15 downto 0);
		muxOut : out std_logic_vector(N-1 downto 0)
	);
end component;

constant c_clk  : time := gclk_help * 2;
signal s_clk, s_reset,s_store,s_extSel,s_load,s_nAdd_sub,s_aluSrc 	: std_logic;
signal s_writeTo,s_readFrom1,s_readFrom2 :  std_logic_vector(4 downto 0);
signal s_imm 	: std_logic_vector(15 downto 0);
signal s_muxOut : std_logic_vector(N-1 downto 0);

begin
	dprocessor : processor 
	port map (
		clk  => s_clk,
		reset => s_reset,
		store => s_store,
		extSel => s_extSel,
  	        load  => s_load,
		nAdd_sub => s_nAdd_sub,
		aluSrc => s_aluSrc,
		writeTo => s_writeTo,
		readFrom1 => s_readFrom1,
		readFrom2 => s_readFrom2,
		immediate => s_imm,
		muxOut => s_muxOut);

	gclk : process
	begin
		s_clk <= '0';
		wait for gclk_help;
		s_clk <= '1';
		wait for gclk_help;
	end process;

	gtb : process
	begin
		s_reset <= '1';
		s_store <= '0';
		s_extSel <= '0';
		s_load <= '0';
		s_nAdd_sub <= '0';
		s_aluSrc <= '0';
		s_writeTo <= "00000";
		s_readFrom1 <= "00000";
		s_readFrom2 <= "00000";
		s_imm <= "0000000000000000";
		wait for c_clk;
		---------------------------------addi 25 0 0
		s_reset <= '0';
		s_aluSrc <= '1';
		s_extSel <= '0';
		s_imm <= "0000000000000000";
		s_writeTo <= "11001";
		wait for c_clk;
		---------------------------------addi 26 0 256
		s_reset <= '0';
		s_aluSrc <= '1';
		s_extSel <= '0';
		s_imm <= "0000000100000000";
		s_writeTo <= "11010";
		wait for c_clk;
		---------------------------------lw 1 0(25)
		s_extSel <= '1';
		s_aluSrc <= '1';
		s_load <= '1';
		s_writeTo <= "00001";
		s_readFrom1 <= "11001";
		s_imm <="0000000000000000";
		wait for c_clk;
		---------------------------------lw 2 4(25)
		s_extSel <= '1';
		s_aluSrc <= '1';
		s_load <= '1';
		s_writeTo <= "00010";
		s_readFrom1 <= "11001";
		s_imm <="0000000000000001";
		wait for c_clk;
		---------------------------------add 1 1 2
		s_extSel <= '0';
		s_load <= '0';
		s_aluSrc <= '0';
		s_writeTo <= "00001";
		s_readFrom1 <= "00001";
		s_readFrom2 <= "00010";
		wait for c_clk;
		---------------------------------sw 1 0(26)
		s_extSel <= '0';
		s_load <= '0';
		s_aluSrc <= '1';
		s_readFrom1 <= "11010";
		s_readFrom2 <= "00001";
		s_imm <="0000000000000000";
		s_store <= '1';
		wait for c_clk;
		---------------------------------lw 2 8(25)
		s_extSel <= '1';
		s_store <= '0';
		s_aluSrc <= '1';
		s_load <= '1';
		s_writeTo <= "00010";
		s_readFrom1 <= "11001";
		s_imm <="0000000000000010";
		wait for c_clk;
		---------------------------------add 1 1 2
		s_extSel <= '0';
		s_load <= '0';
		s_aluSrc <= '0';
		s_writeTo <= "00001";
		s_readFrom1 <= "00001";
		s_readFrom2 <= "00010";
		wait for c_clk;
		---------------------------------sw 1 4(26)
		s_store <= '1';
		s_aluSrc <= '1';
		s_extSel <= '0';
		s_load <= '0';
		s_readFrom1 <= "11010";
		s_readFrom2 <= "00001";
		s_imm <="0000000000000001";
		wait for c_clk;
		---------------------------------lw 2 12(25)
		s_extSel <= '1';
		s_store <= '0';
		s_aluSrc <= '1';
		s_load <= '1';
		s_writeTo <= "00010";
		s_readFrom1 <= "11001";
		s_imm <="0000000000000011";
		wait for c_clk;
		---------------------------------add 1 1 2
		s_extSel <= '0';
		s_store <= '0';
		s_load <= '0';
		s_aluSrc <= '0';
		s_writeTo <= "00001";
		s_readFrom1 <= "00001";
		s_readFrom2 <= "00010";
		wait for c_clk;
		---------------------------------sw 1 8(26)
		s_extSel <= '0';
		s_load <= '0';
		s_readFrom1 <= "11010";
		s_readFrom2 <= "00001";
		s_imm <="0000000000000010";
		s_store <= '1';
		s_aluSrc <= '1';
		wait for c_clk;
		---------------------------------lw 2 16(25)
		s_extSel <= '1';
		s_aluSrc <= '1';
		s_store <= '0';
		s_load <= '1';
		s_writeTo <= "00010";
		s_readFrom1 <= "11001";
		s_imm <="0000000000000100";
		wait for c_clk;
		---------------------------------add 1 1 2
		s_extSel <= '0';
		s_store <= '0';
		s_load <= '0';
		s_aluSrc <= '0';
		s_writeTo <= "00001";
		s_readFrom1 <= "00001";
		s_readFrom2 <= "00010";
		wait for c_clk;
		---------------------------------sw 1 12(26)
		s_extSel <= '0';
		s_load <= '0';
		s_readFrom1 <= "11010";
		s_readFrom2 <= "00001";
		s_imm <="0000000000000011";
		s_store <= '1';
		s_aluSrc <= '1';
		wait for c_clk;
		---------------------------------lw 2 20(25)
		s_extSel <= '1';
		s_aluSrc <= '1';
		s_store <= '0';
		s_load <= '1';
		s_writeTo <= "00010";
		s_readFrom1 <= "11001";
		s_imm <="0000000000000101";
		wait for c_clk;
		---------------------------------add 1 1 2
		s_extSel <= '0';
		s_store <= '0';
		s_load <= '0';
		s_aluSrc <= '0';
		s_writeTo <= "00001";
		s_readFrom1 <= "00001";
		s_readFrom2 <= "00010";
		wait for c_clk;
		---------------------------------sw 1 16(26)
		s_extSel <= '0';
		s_load <= '0';
		s_readFrom1 <= "11010";
		s_readFrom2 <= "00001";
		s_imm <="0000000000000100";
		s_store <= '1';
		s_aluSrc <= '1';
		wait for c_clk;
		---------------------------------lw 2 24(25)
		s_extSel <= '1';
		s_aluSrc <= '1';
		s_store <= '0';
		s_load <= '1';
		s_writeTo <= "00010";
		s_readFrom1 <= "11001";
		s_imm <="0000000000000110";
		wait for c_clk;
		---------------------------------add 1 1 2
		s_extSel <= '0';
		s_store <= '0';
		s_load <= '0';
		s_aluSrc <= '0';
		s_writeTo <= "00001";
		s_readFrom1 <= "00001";
		s_readFrom2 <= "00010";
		wait for c_clk;
		---------------------------------addi 27 0 512
		s_reset <= '0';
		s_aluSrc <= '1';
		s_extSel <= '0';
		s_imm <= "0000001000000000";
		s_writeTo <= "11011";
		wait for c_clk;
		---------------------------------sw 1 -4(27)
		s_extSel <= '1';
		s_load <= '0';
		s_readFrom1 <= "11011";
		s_readFrom2 <= "00001";
		s_imm <="1111111111111111";
		s_store <= '1';
		s_aluSrc <= '1';
		wait for c_clk;
		s_readFrom1 <= "11111";
		s_readFrom2 <= "11111";
		s_store <= '0';
		s_extSel <= '0';
		s_load <= '0';
		s_nAdd_sub <= '0';
		s_aluSrc <= '0';
	wait for c_clk;wait for c_clk;wait for c_clk;wait for c_clk;wait for c_clk;wait for c_clk;wait for c_clk;wait for c_clk;wait for c_clk;wait for c_clk;
	end process;
end structure;