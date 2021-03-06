-- revision history:
-- 07.08.2015     Patrick Appenheimer    created


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.cpu_pack.all;

entity tb_fsm is
end entity tb_fsm;

architecture behav_tb_fsm of tb_fsm is

  -- -------- SIMULATION CONSTANTS -----
  constant CLK_TIME : time := 2500 ps;
  constant RST_TIME : time := 15 ns;

  -- -------- FSM INTERFACE -----------------
  signal clk                : std_logic := '0';
  signal rst                : std_logic;
signal       instr_in : std_logic_vector(31 downto 0);
signal fsm_busy: std_logic;
signal       nextfsm_busy: std_logic;
signal       nextfsm_state: std_logic_vector(4 downto 0);
signal       output_buffer : std_logic_vector(29 downto 0);

    signal instr  :   std_logic_vector(31 downto 0); 
  
  signal test_instr_stall   : std_logic;
  signal test_data_stall    : std_logic;

  -- ------ SIMULATION CONTROL ---------------
  signal sim_finish : std_logic;




begin

  -- GENERAL CONTROL SIGNALS
  clk <= not clk  after CLK_TIME;
  rst <= '1', '0' after RST_TIME;

  -- FSM
  u1_fsm : entity work.fsm(behavioral)
    port map(clk, rst, fsm_busy, nextfsm_busy, nextfsm_state, output_buffer, instr_in, test_instr_stall, test_data_stall);


  -- TEST PROCESS
  test_process:
  process
  begin
    sim_finish <= '0';

    wait for 1 ns;
    sim_finish <= '1';

    rst <= '1';

    --usually the first instruction address should be dropping out at
    -- instr_addr and it should be 00000000, so we return an instruction
    -- and set the ID's muxes for correct decoding
    -- To test: 
    -- instr_address: 00000004
    -- if: Instruction 1: LUI $gp, 1
    instr_in        <= x"3c1c0001";
    --id: Nothing
    --id_regdest_mux  <= "00";
    --id_regshift_mux <= "00";
    --in_mux_pc       <= '0';
    --ex: Nothing
    --exc_mux1        <= "10";
    --exc_mux2        <= "00";
    --alu_op          <= "000001";
    -- mem: Nothing
    --memstg_mux      <= '1';
    -- wb: Nothing
    --id_enable_regs  <= '0';
    wait for clk_time;

    -- To test:
    -- shift_2 : 10;
    -- imm_2: 00000001
    -- regdest_2: 1C
    -- instr_address: 00000004
    -- ip_2 : 00000000
    instr_in        <= x"279c8070";  -- Instruction 2: ADDIU $gp, $gp, -32656
    --id: Instruction 1 (LUI $gp, 1)
    --id_regdest_mux  <= "10";
    --id_regshift_mux <= "01";
    --in_mux_pc       <= '0';
    --ex: Nothing
    --exc_mux1        <= "10";
    --exc_mux2        <= "00";
    --alu_op          <= "000001";
    -- mem: Nothing
    --memstg_mux      <= '1';
    -- wb: Nothing
    --id_enable_regs  <= '0';
    wait for clk_time;

    -- To test:
    -- regdest_2: 1C
    -- reg_a_2: 00010000;
    -- imm_2: 8070
    -- instr_address: 00000008
    -- ip_2 : 00000004
    -- alu_result_3: 000010000
    -- regdest_3: 1C
    -- ip_3 : 00000000
    instr_in        <= x"08000004";     -- Instruction 3: J 0x10
    --id: Instruction 2 (ADDIU $gp, $gp, -32656)
    --id_regdest_mux  <= "10";
    --id_regshift_mux <= "00";
    --in_mux_pc       <= '0';
    --ex: Instruction 1 (LUI $gp, 1)
    --exc_mux1        <= "00";
    --exc_mux2        <= "01";
    --alu_op          <= "000100";
    -- mem: Nothing
    --memstg_mux      <= '1';
    -- wb: Nothing
    --id_enable_regs  <= '0';
    wait for clk_time;

    wait;
  end process;

end architecture behav_tb_fsm;
