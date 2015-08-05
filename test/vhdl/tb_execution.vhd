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
  constant CLK_TIME           : time              := 2 ns;
  constant RST_TIME           : time              := 30 ns;

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
    PORT MAP(clk, rst, test_alu_result, test_data_out, test_destreg_out, test_alu_zero_out,
    test_a_in, test_b_in, test_destreg_in, test_imm_in, test_ip_in, test_shift_in, test_mux1_control_in,
    test_mux2_control_in, test_alu_instruction_in);


  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish   <= '0';
    
    test_shift_in <= b"1_0101";
    test_a_in <= x"0000_0002";
    test_b_in <= x"0000_0003";
    test_destreg_in <= b"0_1111";
    test_imm_in <= x"0000_000A";
    test_ip_in <= x"0000_0004";
    test_alu_instruction_in <= b"10_0000";
    
    wait for 1 ns;
    test_mux1_control_in <= b"00";
    test_mux2_control_in <= b"00";
    
    wait for 1 ns;
    test_mux1_control_in <= b"00";
    test_mux2_control_in <= b"01";
    
    wait for 1 ns;
    test_mux1_control_in <= b"00";
    test_mux2_control_in <= b"10";
    
    wait for 1 ns;
    test_mux1_control_in <= b"01";
    test_mux2_control_in <= b"00";
    
    wait for 1 ns;
    test_mux1_control_in <= b"01";
    test_mux2_control_in <= b"01";
    
    wait for 1 ns;
    test_mux1_control_in <= b"01";
    test_mux2_control_in <= b"10";
    
    wait for 1 ns;
    test_mux1_control_in <= b"10";
    test_mux2_control_in <= b"00";
    
    wait for 1 ns;
    test_mux1_control_in <= b"10";
    test_mux2_control_in <= b"01";
    
    wait for 1 ns;
    test_mux1_control_in <= b"10";
    test_mux2_control_in <= b"10";
    
    wait for 1 ns;
    sim_finish  <= '1';
    wait;
  end process;

end architecture behav_tb_execution;
