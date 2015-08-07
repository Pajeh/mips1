-- revision history:
-- 2015-08-06       Lukas Jaeger        created
-- 2015-08-07	Lukas Jaeger		added instructions of counter-example

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity tb_cpu_datapath is
end entity tb_cpu_datapath;

architecture behavioural of tb_cpu_datapath is
    component cpu_datapath
    port(
      clk                   	: in  std_logic;
      rst                   	: in  std_logic;
      instr_addr            	: out std_logic_vector(31 downto 0);
      data_addr             	: out std_logic_vector(31 downto 0);
      instr_in              	: in  std_logic_vector(31 downto 0);
      data_to_cpu           	: in  std_logic_vector(31 downto 0);
      data_from_cpu         	: out std_logic_vector(31 downto 0);
      alu_op            	: in  std_logic_vector(5 downto 0);
      exc_mux1              	: in  std_logic_vector(1 downto 0);
      exc_mux2              	: in  std_logic_vector(1 downto 0);
      exc_alu_zero		: out std_logic_vector(0 downto 0);
      memstg_mux        	: in  std_logic;
      id_regdest_mux    	: in std_logic_vector (1 downto 0);
      id_regshift_mux       	: in std_logic_vector (1 downto 0);
      id_enable_regs		: in std_logic;
      in_mux_pc             	: in std_logic;
      stage_control		: in std_logic_vector (4 downto 0)
      
    );
    end component;
    
    signal clk, rst, memstg_mux, id_enable_regs, in_mux_pc : std_logic := '0';
    signal instr_in, data_to_cpu : std_logic_vector (31 downto 0) := x"00000000";
    signal alu_op : std_logic_vector (5 downto 0) := "000000";
    signal exc_mux1, exc_mux2, id_regdest_mux, id_regshift_mux : std_logic_vector(1 downto 0) := "00"; 
    signal exc_alu_zero : std_logic_vector(0 downto 0) := "0";
   signal stage_control : std_logic_vector(4 downto 0) := "11111";
    -- Tweak clock frequency here
    constant clk_time : time := 10 ns;
    begin
        dut: cpu_datapath port map(
            clk => clk,
            rst => rst,
            instr_in => instr_in,
            data_to_cpu => data_to_cpu,
            alu_op => alu_op,
            exc_mux1 => exc_mux1,
            exc_mux2 => exc_mux2,
            memstg_mux => memstg_mux,
            id_regdest_mux => id_regdest_mux,
            id_regshift_mux => id_regshift_mux,
            id_enable_regs => id_enable_regs,
	    in_mux_pc => in_mux_pc,
	    stage_control => stage_control
        );
        
        clk_proc : process
        begin
               clk <= '0';
                wait for clk_time / 2;
                clk <= '1';
                wait for clk_time / 2;
        end process;
        
        data_proc : process
        begin
            	-- Reset
            	rst <= '0';
            	wait for clk_time;
            	rst <= '1';

		--usually the first instruction address should be dropping out at
		-- instr_addr and it should be 00000000, so we return an instruction
		-- and set the ID's muxes for correct decoding
		-- To test: 
		-- instr_address: 00000004
		-- ip_2 : 00000000
		instr_in <= x"3c1c0001";	-- Instruction 1: LUI $gp, 1
		id_regdest_mux <= "10";
		id_regshift_mux <= "00";
		id_enable_regs <= '0';
		wait for clk_time;

		-- To test:
		-- imm_2: 00000001
		-- regdest_2: 1C
		-- instr_address: 00000008
		-- ip_2 : 00000004
		instr_in <= x"279c8070";	-- Instruction 2: ADDIU $gp, $gp, -32656
		id_regdest_mux <= "10";
		id_regshift_mux <= "00";
		id_enable_regs <= '0';
		-- Instruction 1 now reaches execution stage, prepare muxes
		exc_mux1 <= "00";
		exc_mux2 <= "01";
		alu_op <= b"00_0010";
		wait for clk_time;
		
		-- To test:
		-- regdest_2: 1C
		-- instr_address: 0000000C
		-- ip_2 : 00000008
		-- alu_result_3: 00000001
		-- regdest_3: 1C
		instr_in <= x"08000004";	-- Instruction 3: J 0x10
		id_regdest_mux <= "10";
		id_regshift_mux <= "00";
		id_enable_regs <= '0';
		-- Instruction 2 now reaches execution stage
		exc_mux1 <= "00";
		exc_mux2 <= "01";
		alu_op <= b"10_0000";
		-- Instruction 1 now reaches memory stage, but the mux is already set to 0, so nothing to do
		wait for clk_time;

		instr_in <= x"3c1d00a2";	-- Instruction 4: LUI $sp,0xa2 
		id_regdest_mux <= "10";
		id_regshift_mux <= "00";
		id_enable_regs <= '1';	-- Writeback will write back the result of instruction 1, so id is prepared
		-- Instruction 3 now reaches execution stage, but since ALU has nothing to do when J is performed, we don't care
		-- about correct settings
		-- However the new program counter must be written:
		in_mux_pc <= '1';
		-- Instruction 2 now reaches memory stage, which is already prepared for forwarding data to writeback

		--Instruction 1 now reaches writeback, nothing to do
		
		wait for clk_time;


            
        end process;
    end architecture;
