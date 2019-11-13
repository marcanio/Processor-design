library IEEE;
use IEEE.std_logic_1164.all;

entity barrel32 is
  port(inA          : in std_logic_vector(31 downto 0);
       sel	    : in std_logic_vector(4 downto 0);
 	ctrl,arithctrl	    : in std_logic;
       o_F          : out std_logic_vector(31 downto 0));
end barrel32;

architecture structural of barrel32 is
component Mux is
	port( inputa : in std_logic;
	      inputb : in std_logic;
	      selector : in std_logic;
	      output : out std_logic);
end component;
signal arithbit : std_logic;
signal tier2sig,tier3sig,tier4sig,tier5sig,initsig,outsig : std_logic_vector(31 downto 0);

begin
arithbit <= inA(31) and ctrl and arithctrl;
process(ctrl,inA,arithctrl)
begin

	if ctrl='1' then
		iflip : for i in 0 to 31 loop
			initsig(i) <= inA(31-i);
		end loop;
	
	else
		initsig <= inA;
	end if;
end process; 	


external1 : MUX
port map(inputA => initsig(0),
	 inputb => arithbit,
	 selector => sel(0),
	 output => tier2sig(0));

tier1 : for i in 1 to 31 generate
	internal1 : MUX
	port map(inputA => initsig(i),
	 	 inputb => initsig(i-1),
		 selector => sel(0),
		 output => tier2sig(i));
end generate;

tier2b : for i in 0 to 1 generate
	internalexternal : MUX
		port map(inputA => tier2sig(i),
	 	 	 inputb => arithbit,
			 selector => sel(1),
		 	 output => tier3sig(i));
end generate;

tier2 : for i in 2 to 31 generate
	internal2 : MUX
	port map(inputA => tier2sig(i),
	 	 inputb => tier2sig(i-2),
		 selector => sel(1),
		 output => tier3sig(i));
end generate;

tier3b : for i in 0 to 3 generate
	internalexternal : MUX
		port map(inputA => tier3sig(i),
	 	 	 inputb => arithbit,
			 selector => sel(2),
		 	 output => tier4sig(i));
end generate;

tier3 : for i in 4 to 31 generate
	internal2 : MUX
	port map(inputA => tier3sig(i),
	 	 inputb => tier3sig(i-4),
		 selector => sel(2),
		 output => tier4sig(i));
end generate;

tier4b : for i in 0 to 7 generate
	internalexternal : MUX
		port map(inputA => tier4sig(i),
	 	 	 inputb => arithbit,
			 selector => sel(3),
		 	 output => tier5sig(i));
end generate;

tier4 : for i in 8 to 31 generate
	internal2 : MUX
	port map(inputA => tier4sig(i),
	 	 inputb => tier4sig(i-8),
		 selector => sel(3),
		 output => tier5sig(i));
end generate;

tier5b : for i in 0 to 15 generate
	internalexternal : MUX
		port map(inputA => tier5sig(i),
	 	 	 inputb => arithbit,
			 selector => sel(4),
		 	 output => outsig(i));
end generate;

tier5 : for i in 16 to 31 generate
	internal2 : MUX
	port map(inputA => tier5sig(i),
	 	 inputb => tier5sig(i-16),
		 selector => sel(4),
		 output => outsig(i));
end generate;

process(ctrl,outsig)
begin
	if ctrl='1' then

	oflip : for i in 0 to 31 loop
		o_F(i) <= outsig(31-i);
	end loop;
	
	else
		o_F <= outsig;
	end if;
end process; 	

end structural;