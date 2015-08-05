-- revision history:
-- 05.08.2015     Patrick Appenheimer    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity tb_alu is
end entity tb_alu;

architecture behav_tb_alu of tb_alu is
  
  -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2500 ps;
  constant RST_TIME           : time              := 15 ns;

  -- -------- ALU INTERFACE -----------------
  signal clk                  : std_logic         := '0';
  signal rst                  : std_logic;
  signal test_in_a            : std_logic_vector(31 downto 0);
  signal test_in_b            : std_logic_vector(31 downto 0);
  signal test_function_code   : std_logic_vector(5  downto 0);
  signal test_result          : std_logic_vector(31  downto 0);
  signal test_zero            : std_logic;
  
  -- ------ SIMULATION CONTROL ---------------
  signal sim_finish           : std_logic;


  begin

  -- GENERAL CONTROL SIGNALS
  clk   <= not clk      after CLK_TIME;
  rst   <= '1', '0'     after RST_TIME;

  -- ALU
  u1_alu: alu
    PORT MAP(test_in_a, test_in_b, test_function_code, test_result, test_zero);


  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish   <= '0';
    test_in_a <= x"0000_0001";
    test_in_b <= x"0000_0001";
    test_function_code <= b"10_0000";
    wait for 1 ns;
    test_in_a <= x"0000_0000";
    test_in_b <= x"0000_0000";
    wait for 1 ns;
    test_in_a <= x"0000_0002";
    test_in_b <= x"0000_0003";
    test_function_code <= b"10_0000";
    wait for 1 ns;
    test_function_code <= b"11_0000";
    sim_finish  <= '1';
    wait;
  end process;

end architecture behav_tb_alu;
