-- 03.08.2015     Bahri Enis Demirtel    created
-- 14.08.2015     Patrick Appenheimer	 format


library IEEE;
  use IEEE.std_logic_1164.ALL;
  
library IEEE;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
library WORK;
  use WORK.all;


entity instruction_fetch is
	port(
	clk		: in std_logic;
	rst		: in std_logic;
	PC		: in std_logic_vector(31 downto 0);                             	
	InstrData	: in std_logic_vector(31 downto 0);
	IP		: out std_logic_vector(31 downto 0);	
	InstrAddr	: out std_logic_vector(31 downto 0);
	Instr		: out std_logic_vector(31 downto 0)
	);

end entity instruction_fetch;




architecture behavioral of instruction_fetch is
begin
	process (rst, clk, PC, InstrData) is
	begin
		if(rst = '1') then
			InstrAddr <= X"0000_0000";	--If reset comes PC goes to the beginning, its value is 0000_0000
			IP <= X"0000_0000";		--If reset all coming signals are 0000_0000
			Instr <= X"0000_0000";		--If reset all coming signals are 0000_0000
		else
			InstrAddr <= PC;  		--We can the value of PC to the memory adress
			IP <= PC + X"0000_0004";	--IR value is always PC+4;
			Instr <= InstrData;		--Instr value is always equal to InstrData value
		end if;
	end process ;

end architecture behavioral;
