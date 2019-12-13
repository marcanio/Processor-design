library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Fowardatroninator9000 is
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
	o_JCtrlMuxA		:out std_logic_vector(1 downto 0); --00 is norm --01 is from MemWB --10 is from EXMem  	RS --11 is from mem
	o_JCtrlMuxB		:out std_logic_vector(1 downto 0); --00 is norm --01 is from MemWB --10 is from EXMem	RT --11 is from mem
	o_StoreDataCtrl	: out std_logic_vector(1 downto 0)); --00 is normal, --01 gets it's data from mem, 10 is from wb
	
end Fowardatroninator9000;

architecture code of Fowardatroninator9000 is
signal s_IDEXRT, s_IDEXRS, s_EXMEMWrAddr,s_EXMEMWrAddrBefore, s_MEMWBwrAddr, s_IFIDrt, s_IFIDrs : std_logic_vector(4 downto 0);
signal s_EXMEMWB, s_MEMWBWB, s_BranchCtrl, s_JRegCtrl,s_IDEXWB,s_ImmCtrl,s_EXMEMStore : std_logic;
begin
s_IDEXRS<=IDEXRS when IDEXRS/="XXXXX" else "00000";
s_IDEXRT<=IDEXRT when IDEXRT/="XXXXX" else "00000";
s_EXMEMWrAddr<=EXMEMWrAddr when EXMEMWrAddr/="XXXXX" else "00000";
s_MEMWBwrAddr<=MEMWBwrAddr when MEMWBwrAddr/="XXXXX" else "00000";
s_IFIDrt<=IFIDrt when IFIDrt/= "XXXXX" else "00000";
s_IFIDrs<=IFIDrs when IFIDrs/= "XXXXX" else "00000";
s_EXMEMWrAddrBefore<=EXMEMWrAddrBefore when EXMEMWrAddrBefore/="XXXXX" else "00000";
s_EXMEMWB<=EXMEMWB when EXMEMWB/='X' else '0';
s_MEMWBWB<=MEMWBWB when MEMWBWB/='X' else '0';
s_IDEXWB<=IDEXWB when IDEXWB/='X' else '0';
s_BranchCtrl<=BranchCtrl when BranchCtrl/='X' else '0';
s_JRegCtrl<=JRegCtrl when JRegCtrl/='X' else '0';
s_ImmCtrl <= ImmCtrl when ImmCtrl/='X' else '0';
s_EXMEMStore <= EXMEMStore when EXMEMStore /= 'X' else '0';
process(s_IDEXRS,s_IDEXRT,s_EXMEMWrAddr,s_MEMWBwrAddr,s_EXMEMWB,s_MEMWBWB,s_BranchCtrl,s_JRegCtrl)
begin
	o_EXRACtrl	<= "00";
	o_EXRBCtrl	<= "00";
	o_StoreDataCtrl <= "00";


	if(s_EXMEMWrAddr/="00000" and (s_EXMEMWrAddr = s_IDEXRS) and s_EXMEMWB ='1') then  --ALULINA
		o_EXRACtrl <= "10";
	
	elsif(s_MEMWBwrAddr/="00000" and (s_MEMWBwrAddr = s_IDEXRS) and s_MEMWBWB ='1') then
		o_EXRACtrl <= "01";
	else
		o_EXRACtrl	<= "00";

	end if;
	
	if(((s_EXMEMWrAddr/="00000" and (s_EXMEMWrAddr = s_IDEXRT)) and (s_EXMEMWB ='1') and (not s_ImmCtrl = '1'))) then  --ALULINB
		o_EXRBCtrl <= "10";
	elsif(((s_EXMEMWrAddr/="00000" and (s_EXMEMWrAddr = s_IDEXRT)) and (EXMEMStore = '1') and (s_ImmCtrl = '1'))) then
		o_StoreDataCtrl <= "01"; --from mem phase
		--a different mux
	elsif(((s_MEMWBwrAddr/="00000" and (s_MEMWBwrAddr = s_IDEXRT)) and (EXMEMStore = '1') and (s_ImmCtrl = '1'))) then
		o_StoreDataCtrl <= "10";
	elsif(((s_MEMWBwrAddr/="00000" and (s_MEMWBwrAddr = s_IDEXRT)) and s_MEMWBWB ='1') and (not s_ImmCtrl = '1')) then
		o_EXRBCtrl <= "01";
	else
		o_StoreDataCtrl <= "00";
		o_EXRBCtrl	<= "00";
	end if;
	
	
	if((s_BranchCtrl='1' or s_JRegCtrl ='1') and (s_EXMEMWrAddrBefore/="00000" and IFIDRS = s_EXMEMWrAddrBefore)and s_IDEXWB = '1') then
	    o_JCtrlMuxA <="10";
	elsif((s_BranchCtrl='1' or s_JRegCtrl ='1') and (s_MEMWBwrAddr/="00000" and IFIDRS = s_MEMWBwrAddr) and s_MEMWBWB ='1') then
		o_JCtrlMuxA <="01";
	elsif((s_BranchCtrl='1' or s_JRegCtrl ='1') and (s_EXMEMWrAddr/="00000" and IFIDRS = s_EXMEMWrAddr) and s_EXMEMWB ='1') then
		o_JCtrlMuxA <="11";
	else 
		o_JCtrlMuxA <="00";
	end if;
	
	if((s_BranchCtrl='1') and (s_EXMEMWrAddrBefore/="00000" and IFIDRT = s_EXMEMWrAddrBefore)and s_IDEXWB = '1') then
	    o_JCtrlMuxB <="10";
	elsif((s_BranchCtrl='1') and (s_MEMWBwrAddr/="00000" and IFIDRT = s_MEMWBwrAddr) and s_MEMWBWB ='1') then
		o_JCtrlMuxB <="01";
	elsif((s_BranchCtrl='1') and (s_EXMEMWrAddr/="00000" and IFIDRT = s_EXMEMWrAddr) and s_EXMEMWB ='1') then
		o_JCtrlMuxB <="11";
	else
		o_JCtrlMuxB <="00";
	end if;
		
end process;

end code;