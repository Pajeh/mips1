-- revision history:
-- 2015-08-06       Lukas Jaeger        created
-- 2015-08-07	Lukas Jaeger		added instructions of counter-example
-- 2015-08-10       Lukas jaeger        Made it more clear

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
                -- if: Instruction 1: LUI $gp, 1
		instr_in <= x"3c1c0001";
                --id: Nothing
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Nothing
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "000001";
                -- mem: Nothing
                memstg_mux <= '1';
                -- wb: Nothing
                id_enable_regs <= '0';
		wait for clk_time;

		-- To test:
		-- shift_2 : 10;
		-- imm_2: 00000001
		-- regdest_2: 1C
		-- instr_address: 00000004
		-- ip_2 : 00000000
		instr_in <= x"279c8070";	-- Instruction 2: ADDIU $gp, $gp, -32656
                --id: Instruction 1 (LUI $gp, 1)
                id_regdest_mux <= "10";
                id_regshift_mux <="01";
                in_mux_pc <= '0';    
                --ex: Nothing
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "000001";
                -- mem: Nothing
                memstg_mux <= '1';
                -- wb: Nothing
                id_enable_regs <= '0';
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
		instr_in <= x"08000004";	-- Instruction 3: J 0x10
                --id: Instruction 2 (ADDIU $gp, $gp, -32656)
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Instruction 1 (LUI $gp, 1)
                exc_mux1 <= "00";
                exc_mux2 <= "01";
                alu_op <= "000100";
                -- mem: Nothing
                memstg_mux <= '1';
                -- wb: Nothing
                id_enable_regs <= '0';
		wait for clk_time;

		-- To test:
		-- id_ip : 000010
		-- regdest_3: 1C
		-- alu_result_3: 00018070
		-- writeback_4: 00010000
		-- regdest_4: 1C
		-- instr_addr: 00000010
		instr_in <= x"3c1d00a2";	-- Instruction 4: LUI $sp,0xa2 
		 --id: Instruction 3 (J 0x10)
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '1';    
                --ex: Instruction 2 (ADDIU $gp, $gp, -32656)
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: Instruction 1 (LUI $gp, 1)
                memstg_mux <= '0';
                -- wb: Nothing
                id_enable_regs <= '0';
		wait for clk_time;

		-- To test:
		-- regdest_2: 1D
		-- imm_2: 000000a2;
		-- regdest_4: 1C
		-- writeback_4: 00018070
		-- register_file (28): 00010000
		-- instr_addr : 00000014
		instr_in <= x"8f828010";	-- Instruction 5: LW $v0,-32752(gp)
		--id: Instruction 4
                id_regdest_mux <= "10";
                id_regshift_mux <="01";
                in_mux_pc <= '0';    
                --ex: Instruction 3
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "000001";
                -- mem: Instruction 2
                memstg_mux <= '0';
                -- wb: Instruction 1
                id_enable_regs <= '1';
		wait for clk_time;

		-- To test:
		-- reg_a_2: 00018070
		-- imm_2: FFFF8010
		-- regdest_2: 02
		-- alu_result_3: 00a20000
		-- regdest_3: 1D
		instr_in <= x"00000000";	-- Instruction 6: NOP		
                --id: Instruction 5
                id_regdest_mux <= "10";
                id_regshift_mux <="01";
                in_mux_pc <= '0';    
                --ex: Instruction 4
                exc_mux1 <= "00";
                exc_mux2 <= "01";
                alu_op <= "000100";
                -- mem: Instruction 3
                memstg_mux <= '0';
                -- wb: Instruction 2
                id_enable_regs <= '1';
		wait for clk_time;

		-- To test:
		-- reg_a_2 : 00000000
		-- ieg_b_2 : 00000000
		-- reg_shift_2: 00000
		-- regdest_2 : 00000
		-- imm_2 : 00000000
		-- regdest_3 : 02
		-- alu_result_3 : 00010080
		-- regdest_4 : 1D
		-- writeback_4 : 00a20000
		instr_in <= x"a0400000";	-- Instruction 7: SB $zero,0($v0)
                --id: Instruction 6
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Instruction 5
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: Instruction 4
                memstg_mux <= '0';
                -- wb: Instruction 3
                id_enable_regs <= '0';
                wait for clk_time;
                
		-- To test:
		-- reg_b_2: 00000000
		-- imm_2 : 00000000
		-- reg_a: 11382187
		-- regdest_3 : 00
		-- alu_result_3 : 00000000
		-- writeback_4 : 11382187
		-- regdest_4 : 02;
		instr_in <= x"af80800c";	-- Instruction 8: SW $zero,-32756($gp)
                --id: Instruction 7
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Instruction 6
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "000100";
                -- mem: Instruction 5
                memstg_mux <= '1';
                data_to_cpu <= x"11382187";
                -- wb: Instruction 4
                id_enable_regs <= '1';
                wait for clk_time;


		-- To test:
		-- reg_a_2: 00018070
		-- reg_b_2: 00000000
		-- imm_2: FFFF800c
		-- data_3: 00000000
		-- alu_result: 11382187
		-- writeback_4: 00000000
                -- regdest_4 : 00	
                -- data_from_cpu: 00000000 
		-- data_addr: 11382187
		instr_in <=x"8f82800c";		-- Instruction 9: LW $v0,-32756($gp)
		--id: Instruction 8
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Instruction 7
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: Instruction 6
                memstg_mux <= '0';
                -- wb: INstruction 5
                id_enable_regs <= '1';
		wait for clk_time;
		
		--To test
		--reg_a_2: 00018070
		-- imm_2: FFFF800C
		-- regdest_2: 02
		-- alu_result_3: 0001007C
		-- data_3: 00000000
		-- data_from_cpu: 00000000 
		-- data_addr: 10007C
		--if: Instruction 10 (NOP)
                instr_in <= x"00000000";
                --id: Instruction 9
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Instruction 8
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: Instruction 7
                memstg_mux <= '0';
                -- wb: Instruction 6
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2:         00000000
                -- reg_b_2:         00000000
                -- shift_2:         00000
                -- imm_2:           00000000
                -- regdest_2:       00
                -- alu_result_3:    0001007C 
                -- data_3:          11382187
                -- data_from_cpu:   11382187
                -- data_addr:       0001007C
                --if: Instruction 11 (SLTI $vo, $v0, 16);
                instr_in <= x"28420010";
                --id: Instruction 10
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Instruction 9
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: Instruction 8
                memstg_mux <= '0';
                -- wb: Instruction 7
                id_enable_regs <= '0';
                wait for clk_time;
                
                --To test:
                -- reg_a_2: 21871138
                -- imm_2: 10
                -- regdest_2 : 02
                -- alu_result: 00000000
                -- regdest_3: 00
                -- regdest_4: 02
                -- writeback_4: 21871138
                --if:12 (BEQZ $vo, 0x 58)
                instr_in <= x"1040000a";
                --id: 11
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 10
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "000100";
                -- mem: 9
                memstg_mux <= '1';
                data_to_cpu <=x"21871138";
                -- wb: 8
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- next instr_addr: 58
                -- alu_result: 00000000
                -- regdest_3: 02
                -- writeback_4: 000000000
                -- regdest_4 : 00
                -- if: Instruction 13 (NOP)
                instr_in <= x"00000000";
                --id: 12
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '1';    
                --ex: 11
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "001000";
                -- mem: 10
                memstg_mux <= '0';
                -- wb: 9
                id_enable_regs <= '1';
                wait for clk_time;
                
                -- To test: 
                -- reg_a_2: 00000000
                -- reg_b_2: 00000000
                -- imm_2: 00000000
                -- shift_2: 00
                -- writeback_4: 00000000
                -- regdest_4: 02
                --if: Instruction 23 (LW $v1, -32752($gp))
                instr_in <= x"8f838010";
                --id: Instruction 13
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: Instruction 12
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "000100";
                -- mem: Instruction 11
                memstg_mux <= '0';
                -- wb: Instruction 10
                id_enable_regs <= '0';
                wait for clk_time;
		
		-- To test
                -- reg_a_2: 00018070
		-- imm_2: FFFF8010
		-- regdest_2: 03
		-- alu_result_3: 00000000
		-- regdest_3: 00
		--if: 24 (NOP)
                instr_in <= x"00000000";
                --id: 23
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 13
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "000100";
                -- mem: 12
                memstg_mux <= '0';
                -- wb:
                id_enable_regs <= '1';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00000000
                -- reg_b_2: 00000000
                -- shift_2: 00
                -- imm_2: 00000000
                -- regdest_2: 00
                -- alu_result_3: 00010080
                -- regdest_3: 03
                -- writeback_4:00000000
                -- regdest_4: 00
                --if: 25 (LBU v0,0(v1))
                instr_in <= x"90620000";
                --id: 24
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 23
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: 13
                memstg_mux <= '0';
                -- wb: 12
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00C0FFEE
                -- imm_2: 00000000;
                -- regdest_2: 02
                -- alu_result_3:00000000
                -- regdest_3: 00
                -- writeback_4: 00C0FFEE
                -- regdest_4: 03
                --if: Instruction 26 (NOP)
                instr_in <= x"00000000";
                --id: 25
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 24
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "001000";
                -- mem: 23
                memstg_mux <= '1';
                data_to_cpu <= x"00C0FFEE";
                -- wb: 13
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00000000
                -- reg_b_2: 00000000
                -- shift_2: 00
                -- imm_2: 00000000
                -- regdest_2: 00
                -- alu_result_3: 00C0FFEE
                -- regdest_3: 02
                -- writeback_4: 000000000
                -- regdest_4: 00
                --if: Instruction 27 (ADDIU $v0, $v0, 1)
                instr_in <= x"24420001";
                --id: 26
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 25
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: 24
                memstg_mux <= '0';
                -- wb: 23
                id_enable_regs <= '1';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00000049
                -- imm_2: 00000001
                -- regdest_2: 02
                -- alu_result_3: 00000000
                -- regdest_3: 00
                -- writeback_4: 00000049
                -- regdest_4: 02
                --if: Instruction 28 (ANDI $v0,$v0,0xff)
                instr_in <= x"304200ff";
                --id: 27
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 26
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "001000";
                -- mem: 25
                memstg_mux <= '1';
                data_to_cpu <=x"00000049";
                -- wb: 24
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 0000004A
                -- imm_2: 000000ff
                -- regdest_2: 02
                -- alu_result_3: 0000004A
                -- regdest_3: 02
                -- writeback_4:00000000
                -- regdest_4:00
                --if: Instruction 29: (SB $vo, 0($v1))
                instr_in <= x"a0620000";
                --id: 28
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 27
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: 26
                memstg_mux <= '0';
                -- wb: 25
                id_enable_regs <= '1';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00C0FFEE
                -- reg_b_2: 0000004A
                -- imm_2: 00000000
                --alu_result_3: 0000004A
                --regdest_3: 02
                --writeback_4: 0000004A
                --regdest_4: 02
                --if: Instruction 30 (J 0x1C)
                instr_in <= x"08000007";
                --id: 29
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 28
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100100";
                -- mem: 27
                memstg_mux <= '0';
                -- wb: 26
                id_enable_regs <= '0';
                wait for clk_time;
            
        end process;
    end architecture;
