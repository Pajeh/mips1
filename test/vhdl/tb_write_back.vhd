-- revision history:
-- 05.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;
  
library IEEE;
  use IEEE.STD_LOGIC_UNSIGNED.ALL;
  
  
entity tb_write_back is
end entity tb_write_back;

architecture behav_tb_write_back of tb_write_back is


 -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2500 ps;
  constant RST_TIME           : time              := 15 ns;


  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal writeback_in :std_logic_vector(31 downto 0) := x"0000_0000";
  signal regdest_in : std_logic_vector(4 downto 0) := b"00000";
signal writeback_out : std_logic_vector(31 downto 0);
signal regdest_out : std_logic_vector(4 downto 0);


 

begin

 -- GENERAL CONTROL SIGNALS
  clk   <= not clk      after CLK_TIME;
  rst   <= '1', '0'     after RST_TIME;

  u1_write_back : entity work.write_back(behavioral)
    PORT MAP(clk,rst,writeback_in,regdest_in,writeback_out,regdest_out);
		
	 -- TEST PROCESS
  test_process:
  process
  begin
  
    
    wait for 1 ns;
	regdest_in <= b"00200";
    writeback_in <= x"0000_0100";

	 wait for 1 ns;

    writeback_in <= x"0000_5060";
 wait for 1 ns;
	regdest_in <= x"5200_4218";
	 wait for 1 ns;
    
    wait;
  end process;




end architecture behav_tb_write_back;
