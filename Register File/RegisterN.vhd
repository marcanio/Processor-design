-- THis is a register to the N
library IEEE;
use IEEE.std_logic_1164.all;

entity RegisterN is
 generic(N : integer := 32);
  port(CLK        : in std_logic;     -- Clock input
       RST        : in std_logic;     -- Reset input
       WE         : in std_logic;     -- Write enable input
       D          : in std_logic_vector(N-1 downto 0);     -- Data value input
       Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end RegisterN;

architecture structure of RegisterN is
  
component dff
 port( i_CLK        : in std_logic;     
       i_RST        : in std_logic;     
       i_WE         : in std_logic;   
       i_D          : in std_logic;    
       o_Q          : out std_logic);
end component;

begin

RegN: for i in 0 to N-1 generate
	g_Reg:dff
	port MAP(	i_CLK => CLK,
			i_RST => RST,
			i_WE => WE,
			i_D  => D(i),
			o_Q  => Q(i));
end generate;
 
  
end structure;