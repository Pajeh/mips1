-- Revision history:
-- 2015-08-12       Lukas Jaeger        created

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.cpu_pack.all;

entity tb_fsm_pl is
end entity tb_fsm_pl;

architecture behav_tb_fsm of tb_fsm_pl is
        component control_pipeline
                port(
                    clk                   	: in  std_logic;
                    rst                   	: in  std_logic;
                    rd_mask   	                : out std_logic_vector(3  downto 0);
                    wr_mask		        : out std_logic_vector(3  downto 0);
                    instr_stall       	        : in  std_logic;
                    data_stall        	        : in  std_logic;
                    instr_in              	: in  std_logic_vector(31 downto 0);
                    alu_op            	        : out std_logic_vector(5 downto 0);
                    exc_mux1              	: out std_logic_vector(1 downto 0);
                    exc_mux2              	: out std_logic_vector(1 downto 0);
                    exc_alu_zero		: in  std_logic_vector(0 downto 0);
                    memstg_mux        	        : out std_logic;
                    id_regdest_mux    	        : out std_logic_vector (1 downto 0);
                    id_regshift_mux       	: out std_logic_vector (1 downto 0);
                    id_enable_regs		: out std_logic;
                    in_mux_pc             	: out std_logic;
                    stage_control		: out std_logic_vector (4 downto 0)
                );
        end component;
        
        signal clk : std_logic;
        signal rst : std_logic;
        signal instr_in : std_logic_vector (31 downto 0);
        signal instr_stall : std_logic;
        signal data_stall : std_logic;
        signal in_go : std_logic;
        signal exc_alu_zero: std_logic_vector(0 downto 0);
        signal stage_control : std_logic_vector (4 downto 0);
        
        constant clk_time : time := 10 ns;
        
        begin
        
        dut: control_pipeline port map(
            clk => clk,
            rst => rst,
            instr_in => instr_in,
            instr_stall => instr_stall,
            data_stall => data_stall,
            exc_alu_zero => exc_alu_zero
        );
        
        instr_stall <= '0';
        data_stall <= '0';
        
        clk_proc : process
        begin
                clk <= '0';
                wait for clk_time / 2;
                clk <= '1';
                wait for clk_time / 2;
        end process;
        
        test_proc : process
        begin
                instr_in <= x"00000000";
                rst <= '1';
                wait for clk_time / 2;
                rst <= '0';
                wait for clk_time / 2;
                
                -- Inserting J-Type-instruction
                -- To test: 
                -- id_regdest_mux : 10
                -- id_regshift_mux : 00
                -- id_enable_regs : 0
                -- exc_mux1 : 10
                -- exc_mux2 : 00
                -- alu_op : 000100
                -- memstg_mux: 0
                -- rd_mask: 0000
                -- wr_mask: 0000
                -- pc_mux: 1
                instr_in <= x"0FFFFFFF";
                wait for clk_time;
                
                -- Inserting I-Type_instruction (addiu v0, v0, 1)
                -- To test:
                -- id_regdest_mux: 10
                -- id_regshift_mux: 00
                -- id_enable_regs: 0
                -- exc_mux1: 10
                -- exc_mux2: 00
                -- alu_op: 000100
                -- memstg_mux: 0
                -- rd_mask: 0000
                -- wr_mask: 0000
                -- pc_mux: 0
                instr_in <= x"24420001";
                wait for clk_time;
                
                -- Inserting LW v0 -32756(gp)
                -- To test:
                -- id_regdest_mux: 10
                -- id_regshift_mux: 00
                -- id_enable_regs : 00
                -- exc_mux1: 10
                -- exc_mux2: 01
                -- alu_op: 100000
                -- memstg_mux: 0
                -- rd_mask : 0000
                -- wr_mask : 0000
                -- pc_mux : 0
                instr_in <= x"8f82800c";
                wait for clk_time;
                
                -- Inserting LBU v0, 0(v1)
                -- To test:
                -- id_regdest_mux: 10
                -- id_regshift_mux: 00
                -- id_enable_regs: 0
                -- exc_mux1: 10
                -- exc_mux2: 01
                -- alu_op: 100000
                -- rd_mask : 0000
                -- wr_mask : 0000
                -- memstg_mux: 0
                -- pc_mux: 0
                instr_in <= x"90620000";
                wait for clk_time;
                
                -- Inserting SW zero -32756(gp)
                -- To test:
                -- id_regdest_mux: 10
                -- id_regshift_mux: 00
                -- id_enable_regs: 1
                -- exc_mux1: 10
                -- exc_mux2: 01
                -- alu_op: 100000
                -- memstg_mux: 1
                -- in_mux_pc: 0
                instr_in <= x"af80800c";
                wait for clk_time;
                
                -- Inserting sb, zero 0(v0)
                -- To test:
                -- id_regdest_mux: 10
                -- id_regshift_mux: 00
                -- id_enable_regs: 1
                -- exc_mux1: 10
                -- exc_mux2: 01
                -- alu_op: 100000
                -- memstg_mux: 1
                -- in_mux_pc: 0
                instr_in <= x"a0400000";
                wait for clk_time;
                
                -- To test:
                -- id_regdest_mux: 00
                -- id_regshift_mux: 00
                -- id_enable_regs: 1
                -- exc_mux1: 10
                -- exc_mux2: 01
                -- alu_op: 100000
                -- memstg_mux: 0
                -- in_mux_pc: 0
                instr_in <= x"00000000";
                wait for clk_time;
                
                -- To test:
                -- id_regdest_mux: 00
                -- id_regshift_mux: 00
                -- id_enable_regs: 0
                -- exc_mux1: 10
                -- exc_mux2: 00
                -- alu_op: 000100
                -- memstg_mux: 0
                -- in_mux_pc: 0
                instr_in <= x"00000000";
                wait for clk_time;
                
        end process;
        
end architecture;