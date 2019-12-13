library IEEE;
use IEEE.std_logic_1164.all;

entity HazardDetector9000 is
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
	   
end  HazardDetector9000;


architecture logic of HazardDetector9000 is
signal s_IDEXMemWB : std_logic;
signal s_JSig : std_logic_vector(2 downto 0);
signal s_IDEXWriteAddr,s_Inst25dt21,s_IDecRegAddr,s_IDReadFrom1,s_IDReadFrom2,s_EXMEMRegAddr,s_MEMWBRegAddr,S_IFIDrt,S_IDEXrt,S_IFIDrs : std_logic_vector(4 downto 0);
begin
s_IDEXMemWB <= IDEXMemWB when not(IDEXMemWB = 'X') else '0';
s_IDEXWriteAddr <= IDEXWriteAddr when not(IDEXWriteAddr = "XXXXX") else "00000";
s_IDecRegAddr <= IDecRegAddr when not(IDecRegAddr = "XXXXX") else "00000";
s_IDReadFrom1 <= IDReadFrom1 when not(IDReadFrom1 = "XXXXX") else "00000";
s_IDReadFrom2 <= IDReadFrom2 when not(IDReadFrom2 = "XXXXX") else "00000";
s_EXMEMRegAddr <= EXMEMRegAddr when not(EXMEMRegAddr = "XXXXX") else "00000";
s_JSig <= JSig when not(JSig = "XXX") else "000";
s_MEMWBRegAddr <= MEMWBRegAddr when not(MEMWBRegAddr = "XXXXX") else "00000";

S_IFIDrt <= IFIDrt when not(IFIDrt = "XXXXX") else "00000";
S_IDEXrt <= IDEXrt when not(IDEXrt = "XXXXX") else "00000";
S_IFIDrs <= IFIDrs when not(IFIDrs = "XXXXX") else "00000";
 
process(s_IDEXMemWB,s_iDEXWriteAddr,s_Inst25dt21,s_IDecRegAddr,s_IDReadFrom1,s_IDReadFrom2,s_EXMEMRegAddr,s_MEMWBRegAddr,s_JSig,s_IFIDrs,s_IFIDrt)
begin
	Flush <= '0';
	Stall <= '0';
	if( ((S_IFIDrt = S_IDEXrt) or (S_IDEXrt = S_IFIDrs)) and s_IDEXMemWB = '1') then -- Load use hazard
		Flush <= '1';
		Stall <= '1';

	elsif((S_IFIDrs = s_IDEXWriteAddr) and (s_JSig(2) = '1')) then -- Jump Register hazard
		Flush <= '1';
		Stall <= '1';
	elsif((s_IDEXWriteAddr /= "00000") and (s_JSig(1) = '1') and ((s_IDEXWriteAddr = S_IFIDrs) or (s_IDEXWriteAddr = S_IFIDrt))) then -- Branch
		Flush <= '1';
		Stall <= '0';
	elsif((s_JSig(0) = '1') or (s_JSig(1) = '1') or (s_JSig(2) = '1')) then --Flush after jump
		Flush <= '1';
		stall <='0';
	--elsif(((s_IDEXWriteAddr /= "00000")) and (s_IDEXWriteAddr = s_IFIDrs or s_IDEXWriteAddr = s_IFIDrt)) then
	--	Flush <= '1';
	--	Stall <= '1';
	--elsif((s_EXMEMRegAddr = s_IFIDrs or s_EXMEMRegAddr = s_IFIDrt) and (s_EXMEMRegAddr/="00000")) then
	--	Flush <= '1';
	--	Stall <= '1';
	elsif((s_MEMWBRegAddr = s_IFIDrs or s_MEMWBRegAddr = s_IFIDrt)and (s_MEMWBRegAddr/="00000")) then
		Flush <= '1';
		Stall <= '1';
	else
		Flush <= '0';
		Stall <= '0';
	end if;
end process;
end logic;


--

