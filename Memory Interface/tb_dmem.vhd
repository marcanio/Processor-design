-- This is the testbench for the MEM.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_dmem is

	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10;
		gCLK_HPER   : time := 50 ns
	);

end tb_dmem;

architecture behavior of tb_dmem is
component mem
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);
	port 
	(	clk		: in std_logic;
		addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
end component;
constant cCLK_PER  	: time := gCLK_HPER * 2;
signal S_clk, S_we 	: std_logic;
signal S_addr 		: std_logic_vector((ADDR_WIDTH-1) downto 0);
signal S_data, S_q 	: std_logic_vector((DATA_WIDTH-1) downto 0);

type DataType is array (10 downto 0) of std_logic_vector(31 downto 0);	--32 by 32 Array 
signal MainData  : DataType ;
begin

dmem: mem
	port map(clk 	=> S_clk,
		 addr	=> S_addr,
		 data	=> S_data,
		 we	=> S_we,
		 q	=> S_q);

G_CLK: process
 begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
--1 is writing

G_TB : process
 begin
--Read the intial 10 values
	S_addr <= "0000000000";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(0) <= S_q;
        wait for cCLK_PER;
	
	S_addr <= "0000000001";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(1) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000000010";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(2) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000000100";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(3) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000000101";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(4) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000000110";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(5) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000000111";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(6) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000001000";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(7) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000001001";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(8) <= S_q;
        wait for cCLK_PER;

        S_addr <= "0000001010";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(9) <= S_q;
        wait for cCLK_PER;

	S_addr <= "0000001010";
	S_data <= "00000000000000000000000000000000";
	S_we   <= '0'; 
	MainData(10) <= S_q;
        wait for cCLK_PER;
--Write values
	S_we   <= '1'; 
	S_addr <= "0100000000";
	S_data <= MainData(0);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100000001";
	S_data <= MainData(1);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100000010";
	S_data <= MainData(2);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100000011";
	S_data <= MainData(3);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100000100";
	S_data <= MainData(4);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100000101";
	S_data <= MainData(5);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100000110";
	S_data <= MainData(6);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100000111";
	S_data <= MainData(7);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100001000";
	S_data <= MainData(8);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100001001";
	S_data <= MainData(9);
        wait for cCLK_PER;

	S_we   <= '1'; 
	S_addr <= "0100001010";
	S_data <= MainData(10);
        wait for cCLK_PER;
--Read back
	S_we   <= '0'; 
	S_addr <= "0100000000";
	wait for cCLK_PER;

	S_addr <= "0100000001";
	wait for cCLK_PER;

	S_addr <= "0100000010";
	wait for cCLK_PER;

	S_addr <= "0100000011";
	wait for cCLK_PER;

	S_addr <= "0100000100";
	wait for cCLK_PER;

	S_addr <= "0100000101";
	wait for cCLK_PER;

	S_addr <= "0100000110";
	wait for cCLK_PER;

	S_addr <= "0100000111";
	wait for cCLK_PER;

	S_addr <= "0100001000";
	wait for cCLK_PER;

	S_addr <= "0100001001";
	wait for cCLK_PER;

	S_addr <= "0100001010";
	wait for cCLK_PER;



	wait;

end process;




end behavior;