-- 03.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;
  
library IEEE;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
library WORK;
  use WORK.all;


entity instruction_fetch is
port(

clk : in std_logic;
rst : in std_logic;

PC : in std_logic_vector(31 downto 0);      --PC : in std_logic_vector(CPU_ADDR_WIDTH-1 downto 0);                        	--PC(32 bit)
InstrData : in std_logic_vector(31 downto 0);			--InstrData : in std_logic_vector(CPU_DATA_WIDTH-1 downto 0);				 	    --InstrData, Adress information comes from Memory(32 bit)

--StallData : in std_logic;

IR : out std_logic_vector(31 downto 0);    --IR : out std_logic_vector(CPU_ADDR_WIDTH-1 downto 0);   					    --IR, Next PC goes to Execution Stage(32 bit)
InstrAddr: out std_logic_vector(31 downto 0); --InstrAddr: out std_logic_vector(CPU_ADDR_WIDTH-1 downto 0);  					--InstrAddr, PC goes to Memory(32 bit)
Instr : out std_logic_vector(31 downto 0)	--Instr : out std_logic_vector(CPU_DATA_WIDTH-1 downto 0);				    	--Instr, Adress information from Memory goes to Instruction Decoder(32 bit)


);

end entity instruction_fetch;




architecture behavioral of instruction_fetch is


	begin

	process (rst, clk, PC, InstrData) is
	begin

		if(rst = '1') then
		InstrAddr <= X"0000_0000";		-- If reset comes PC goes to at the beginning, its value is 100
		IR <= X"0000_0000";
		Instr <= X"0000_0000";
		
		
			else
						--elsif (rising_edge(clk)) then  
						--if(StallData='0') then
		
		
				InstrAddr <= PC;
				IR <= PC + X"0000_0004";
				Instr <= InstrData;
				
			
		end if;
	end process ;

end architecture behavioral;






















