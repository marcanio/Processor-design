
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDecode is

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
end IDecode;

architecture structure of IDecode is

begin
process(Instruct)
begin 
	
	case Instruct(31 downto 26) is
		 when "001000" => 	--Addi
			ALUSrc		<= '1';
			ALUCtrl		<= "0000";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '0';
			ExtendCtrl	<= '1';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";	
		when "001001" =>	--Addiu
			ALUSrc		<= '1';
			ALUCtrl		<= "0000";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '0';
			ExtendCtrl	<= '1';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";	
		when "001100" =>	--Andi
			ALUSrc		<= '1';
			ALUCtrl		<= "0100";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '0';
			ExtendCtrl	<= '0';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";
		when "001111" =>	--Lui
			ALUSrc		<= '1';
			ALUCtrl		<= "0000";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '1';
			ExtendCtrl	<= '1';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";
		when "100011" => 	--Lw
			ALUSrc		<= '0';
			ALUCtrl		<= "0000";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '1';
			ExtendCtrl	<= '0';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= Instruct(20 downto 16);
		when "001110" =>	--Xori
			ALUSrc		<= '1';
			ALUCtrl		<= "0011";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '0';
			ExtendCtrl	<= '0';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";
		when "001101" =>	--ori
			ALUSrc		<= '1';
			ALUCtrl		<= "0101";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '0';
			ExtendCtrl	<= '0';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";
		when "001010" =>	--slti
			ALUSrc		<= '1';
			ALUCtrl		<= "0010";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '0';
			ExtendCtrl	<= '1';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";
		when "001011" => 	--sltiu
			ALUSrc		<= '1';
			ALUCtrl		<= "0010";
			ShiftSize	<= "00000";
			RegWr		<= '1';
		   	DMemWr 		<= '0';
			load		<= '0';
			ExtendCtrl	<= '0';
			ShiftContrl	<= "00";
			RegWrAddr	<= Instruct(20 downto 16);
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= "00000";
		when "101011" => 	--sw
			ALUSrc		<= '0';
			ALUCtrl		<= "0000";
			ShiftSize	<= "00000";
			RegWr		<= '0';
		   	DMemWr 		<= '1';
			load		<= '0';
			ExtendCtrl	<= '0';
			ShiftContrl	<= "00";
			RegWrAddr	<= "00000";
			ReadA		<= Instruct(25 downto 21);
			ReadB		<= Instruct(20 downto 16);	
		when "000000" =>
			if(Instruct(5 downto 0) = "100000") then	--Add
				ALUSrc		<= '0';
				ALUCtrl		<= "0000";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);	
			end if;
			if(Instruct(5 downto 0) = "100001") then	--Addu
				ALUSrc		<= '0';
				ALUCtrl		<= "0000";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0) = "100100") then	--And
				ALUSrc		<= '0';
				ALUCtrl		<= "0100";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0) = "100111") then	--Nor
				ALUSrc		<= '0';
				ALUCtrl		<= "0111";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "100110") then 	--Xor
				ALUSrc		<= '0';
				ALUCtrl		<= "0011";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "100101") then 	--or
				ALUSrc		<= '0';
				ALUCtrl		<= "0101";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "101010") then 	--slt
				ALUSrc		<= '0';
				ALUCtrl		<= "0010";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "101011") then		--sltu
				ALUSrc		<= '0';
				ALUCtrl		<= "0010";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "000000") then		--sll
				ALUSrc		<= '0';
				ALUCtrl		<= "1000";
				ShiftSize	<= Instruct(10 downto 6);
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "000010") then		--srl
				ALUSrc		<= '0';
				ALUCtrl		<= "1000";
				ShiftSize	<= Instruct(10 downto 6);
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "01";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "000011") then		--sra
				ALUSrc		<= '0';
				ALUCtrl		<= "1000";
				ShiftSize	<= Instruct(10 downto 6);
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "11";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "000000") then		--srl
				ALUSrc		<= '0';
				ALUCtrl		<= "1000";
				ShiftSize	<= Instruct(10 downto 6);
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "01";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "000100") then		--sllv
				ALUSrc		<= '0';
				ALUCtrl		<= "1000";
				ShiftSize	<= Instruct(10 downto 6);
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "000110") then		--srlv
				ALUSrc		<= '0';
				ALUCtrl		<= "1000";
				ShiftSize	<= Instruct(10 downto 6);
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "01";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "000111") then		--srav
				ALUSrc		<= '0';
				ALUCtrl		<= "1000";
				ShiftSize	<= Instruct(10 downto 6);
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "11";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "100010") then		--sub
				ALUSrc		<= '0';
				ALUCtrl		<= "0001";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
			if(Instruct(5 downto 0)= "100011") then		--subu
				ALUSrc		<= '0';
				ALUCtrl		<= "0001";
				ShiftSize	<= "00000";
				RegWr		<= '1';
		   		DMemWr 		<= '0';
				load		<= '0';
				ExtendCtrl	<= '0';
				ShiftContrl	<= "00";
				RegWrAddr	<= Instruct(15 downto 11);
				ReadA		<= Instruct(25 downto 21);
				ReadB		<= Instruct(20 downto 16);
			end if;
		when others => ALUCtrl <= "0000";
	

	end case;


end process;

		




end structure;