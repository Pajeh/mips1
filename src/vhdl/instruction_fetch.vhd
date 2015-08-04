-- 03.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;


entity instruction_fetch is
port(

clk: in std_logic;
rst: in std_logic;

PC : in std_logic_vector(CPU_ADDR_WIDTH-1 downto 0);                        	--PC(32 bit)
InstrData : in std_logic_vector(CPU_MEM_CELL_WIDTH-1 downto 0);				    --InstrData, Adress information comes from Memory(8 bit)


fsm_instruction : in std_logic_vector(1 to 0);         	  	  				    --FSS should control 


IR : out std_logic_vector(CPU_ADDR_WIDTH-1 downto 0);   					    --IR, Next PC goes to Execution Stage(32 bit)
InstrAddr: out std_logic_vector(CPU_MEM_CELL_WIDTH-1 downto 0);  				--InstrAddr, PC goes to Memory(8 bit)
Instr : out std_logic_vector(CPU_ADDR_WIDTH-1 downto 0);				    	--Instr, Adress information from Memory goes to Instruction Decoder(32 bit)



--Memory Stage????



				--MemoryRead, Comment for reading adress from Memory(4 bit)



--FSM Sequence Control

--constant fsm_inst_ctrl_0        : t_memory_rw     :=b"00";
--constant fsm_inst_ctrl_1        : t_memory_rw     :=b"01";
--constant fsm_inst_ctrl_2        : t_memory_rw     :=b"10";
--constant fsm_inst_ctrl_3        : t_memory_rw     :=b"11";



);

end entity instruction_fetch;




architecture behavior of instruction_fetch
begin

process (rst, clk, PC, InstrData) is
begin

if(rst = '1') then
PC <= x"0000_0100";																-- If reset comes PC goes to at the beginning, its value is 100

else
if (rising_edge(clk)) then
InstrAddr <= PC;
--MemoryRead <= x"1111";
IR <= PC + x"0000_0004";
Instr <= InstrData;


end if;
end process ;



fullmemory: process ()
begin
case(full_memory) is





end process fullmemory;


end architecture behavioral;






















