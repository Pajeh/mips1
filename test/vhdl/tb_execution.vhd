-- revision history:
-- 05.08.2015     Patrick Appenheimer    created

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity tb_execution is
end entity tb_execution;

architecture behav_tb_execution of tb_execution is
  
  -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME           : time              := 2500 ps;
  constant RST_TIME           : time              := 15 ns;

  -- -------- ALU INTERFACE -----------------
  signal clk                        : std_logic         := '0';
  signal rst                        : std_logic;
  signal test_alu_result            : std_logic_vector(31 downto 0);
  signal test_data_out              : std_logic_vector(31 downto 0);
  signal test_destreg_out           : std_logic_vector(4  downto 0);
  signal test_alu_zero_out          : std_logic_vector(0  downto 0);
  signal test_a_in                  : std_logic_vector(31 downto 0);
  signal test_b_in                  : std_logic_vector(31 downto 0);
  signal test_destreg_in            : std_logic_vector(4 downto 0);
  signal test_imm_in                : std_logic_vector(31 downto 0);
  signal test_ip_in                 : std_logic_vector(31 downto 0);
  signal test_shift_in              : std_logic_vector(4 downto 0);
  signal test_mux1_control_in       : std_logic_vector(1 downto 0);
  signal test_mux2_control_in       : std_logic_vector(1 downto 0);
  signal test_alu_instruction_in    : std_logic_vector(5 downto 0);
  
  -- ------ SIMULATION CONTROL ---------------
  signal sim_finish           : std_logic;
  

  begin

  -- GENERAL CONTROL SIGNALS
  clk   <= not clk      after CLK_TIME;
  rst   <= '1', '0'     after RST_TIME;

  -- ALU
  u1_execution: entity work.execution(behave)
    PORT MAP();


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
    wait for 1 ns;
    sim_finish  <= '1';
    wait;
  end process;

end architecture behav_tb_execution;
