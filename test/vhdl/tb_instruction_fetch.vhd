-- revision history:
-- 05.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;
  
library IEEE;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
  
entity tb_instruction_fetch is
end entity tb_instruction_fetch;

architecture behav_tb_instruction_fetch of tb_instruction_fetch is


  component instruction_fetch

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
  
  end component instruction_fetch;

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal PC :std_logic_vector(31 downto 0) := x"0000_0000";
  signal InstrData : std_logic_vector(31 downto 0) := x"0000_0000";
  
  

begin

  uut: instruction_fetch
    PORT MAP(
	clk => clk,
	rst => rst,
	PC => PC,
	InstrData => InstrData
    );

  process
  begin

    wait;
  end process;

end architecture behav_tb_instruction_fetch;
