-- revision history:
-- 05.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;
  
library IEEE;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
  
entity tb_instruction_fetch is
end entity tb_instruction_fetch;

architecture behav_tb_instruction_fetch of tb_instruction_fetch is


 -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2500 ps;
  constant RST_TIME           : time              := 15 ns;


  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal PC :std_logic_vector(31 downto 0) := x"0000_0000";
  signal InstrData : std_logic_vector(31 downto 0) := x"0000_0000";
signal IR : std_logic_vector(31 downto 0);
signal InstrAddr : std_logic_vector(31 downto 0);
signal Instr : std_logic_vector(31 downto 0);  

 

begin

 -- GENERAL CONTROL SIGNALS
  clk   <= not clk      after CLK_TIME;
  rst   <= '1', '0'     after RST_TIME;

  u1_instruction_fetch : entity work.instruction_fetch(behavioral)
    PORT MAP(clk,rst,PC,InstrData,IR,InstrAddr,Instr);
		
	 -- TEST PROCESS
  test_process:
  process
  begin
  
    PC <= x"0000_0000";
	InstrData <= x"0000_0100";
    wait for 1 ns;
    PC <= IR;
	InstrData <= x"0000_0110";
    wait for 1 ns;
    
    wait;
  end process;




end architecture behav_tb_instruction_fetch;
