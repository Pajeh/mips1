-- revision history:
-- 2015-08-06       Lukas Jaeger        created
-- 2015-08-07	Lukas Jaeger		added instructions of counter-example
-- 2015-08-10       Lukas jaeger        Made it more clear

library IEEE;
  use IEEE.std_logic_1164.ALL;
  use IEEE.numeric_std.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity tb_datapath is
end entity tb_datapath;

architecture behavioural of tb_datapath is
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
		-- imm_2: FFFF8070
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
		-- alu_result_3: 00008070
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
		-- writeback_4: 00008070
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
		-- reg_a_2: 00008070
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
		-- alu_result_3 : 00000080
		-- regdest_4 : 1D
		-- writeback_4 : 00a20000
		instr_in <= x"a0400000";	-- Instruction 7: SB $zero,0($v0)
                --id: Instruction 6
                id_regdest_mux <= "00";
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
		-- reg_a: 00000084
		-- regdest_3 : 00
		-- alu_result_3 : 00000000
		-- writeback_4 : 00000084
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
                data_to_cpu <= x"00000084";
                -- wb: Instruction 4
                id_enable_regs <= '1';
                wait for clk_time;


		-- To test:
		-- reg_a_2: 00008070
		-- reg_b_2: 00000000
		-- imm_2: FFFF800c
		-- data_3: 00000000
		-- alu_result: 00000084
		-- writeback_4: 00000000
                -- regdest_4 : 00	
                -- data_from_cpu: 00000000 
		-- data_addr: 00000084
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
		--reg_a_2: 00008070
		-- imm_2: FFFF800C
		-- regdest_2: 02
		-- alu_result_3: 0000007C
		-- data_3: 00000000
		-- data_from_cpu: 00000000 
		-- data_addr: 0000007C
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
                -- alu_result_3:    0000007C
                -- data_addr:       0001007C
                --if: Instruction 11 (SLTI $0o, $v0, 16);
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
                -- reg_a_2: 00000000
                -- imm_2: 00000010
                -- regdest_2 : 02
                -- alu_result: 00000000
                -- regdest_3: 00
                -- regdest_4: 02
                -- writeback_4: 00000000
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
                data_to_cpu <=x"00000000";
                -- wb: 8
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- id_ip: 34
                -- alu_result_3 : 00000000
                -- regdest_3: 02
                -- writeback_4: 00000000
                -- regdest_4: 00
                --if: 13 (NOP)
                instr_in <= x"00000000";
                --id: 12
                id_regdest_mux <= "10";
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
                
                --To test:
                --reg_a_2: 00000000
                --reg_b_2: 00000000
                --regdest_2: 00
                --writeback_4: 00000000
                --regdest_4: 02
                --if: 14 (LW $v0, -32756($gp)
                instr_in <= x"8f82800c";
                --id: 13
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 12
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "001000";
                -- mem: 11
                memstg_mux <= '0';
                -- wb: 10
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00008070
                -- imm_2: FFFF800C
                -- regdest_2: 02
                -- alu_result_3: 00000000
                -- regdest_3: 00
                --if: 15 (NOP)
                instr_in <= x"00000000";
                --id: 14
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 13
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "001000";
                -- mem: 12
                memstg_mux <= '0';
                -- wb: 11
                id_enable_regs <= '1';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00000000
                -- reg_b_2: 00000000
                -- regdest_2:00
                -- alu_result_3: 0000007C
                -- regdest_3: 02
                -- writeback_4: 00000000
                -- regdest_4: 00
                --if: 16 (ADDIU: $v0, $v0, 1)
                instr_in <= x"24420001";
                --id: 15
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 14
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem:13
                memstg_mux <= '0';
                -- wb:12
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00000000
                -- imm_2: 00000001
                -- regdest_2: 02
                -- alu_result_3: 00000000
                -- regdest_2: 00
                -- writeback_4: 00000000
                -- regdest_4: 02
                --if: 17 (SW $v0, -32756($gp))
                instr_in <= x"af82800c";
                --id: 16
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 15
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "001000";
                -- mem: 14
                memstg_mux <= '1';
                data_to_cpu <= x"00000000";
                -- wb:
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test
                -- reg_a_2: 00008070
                -- imm_2: FFFF800C
                -- regdest_2: 02
                -- alu_result_3: 00000001
                -- regdest_3: 02
                -- writeback_4: 00000000
                -- regdest_4: 00
                --if: 18 (LW $v0, -32756($gp))
                instr_in <= x"8f82800c";
                --id: 17
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 16
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: 15
                memstg_mux <= '0';
                -- wb: 14
                id_enable_regs <= '1';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00008070
                -- imm_2: FFFF800C
                -- regdest_2: 02
                -- alu_result_3: 0000007C
                -- data_addr: 0000007C
                -- data_3: 00000001
                -- data_from_cpu: 00000001
                -- writeback_4: 00000000
                -- regdest_4: 00
                --if: 19 (NOP)
                instr_in <= x"00000000";
                --id: 18
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 17
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: 16
                memstg_mux <= '0';
                -- wb: 15
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test:
                -- reg_a_2: 00000000
                -- reg_b_2: 00000000
                -- regdest_2: 00
                -- alu_result_3: 0000007C
                -- regdest_3: 02
                --if: 20 (SLTI $v0, $v0, 16)
                instr_in <= x"28420010";
                --id: 19
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 18
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "100000";
                -- mem: 17
                memstg_mux <= '1';
                data_to_cpu <= x"00000001";
                -- wb: 16
                id_enable_regs <= '1';
                wait for clk_time;
                
                
                -- To test:
                -- reg_a_2: 00000001
                -- imm_2: 00000010
                -- regdest_2: 02
                -- alu_result_3: 00000000
                -- regdest_3: 00
                -- writeback_4: 00000001
                -- regdest_4: 02
                --if: 21 (BNEZ $v0, 0x34)
                instr_in <= x"1440fff8";
                --id: 20
                id_regdest_mux <= "10";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 19
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "001000";
                -- mem: 18
                memstg_mux <= '1';
                -- wb: 17
                id_enable_regs <= '0';
                wait for clk_time;
                
                -- To test: 
                -- id_ip : 00000034;
                -- alu_result_3: 00000001
                -- regdest_3: 02
                -- writeback_4: 00000001
                -- regdest_4: 02
                --if: 22 (NOP)
                instr_in <= x"00000000";
                --id: 21
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '1';    
                --ex: 20
                exc_mux1 <= "10";
                exc_mux2 <= "01";
                alu_op <= "001000";
                -- mem:19
                memstg_mux <= '0';
                -- wb: 18
                id_enable_regs <= '1';
                wait for clk_time/2;
                in_mux_pc <= '0';
                wait for clk_time / 2;
                
                -- To test:
                
                --if: 14 (LW $v0, -327556($gp))
                instr_in <= x"8f82800c";
                --id: 22
                id_regdest_mux <= "00";
                id_regshift_mux <="00";
                in_mux_pc <= '0';    
                --ex: 21
                exc_mux1 <= "10";
                exc_mux2 <= "00";
                alu_op <= "001000";
                -- mem: 20
                memstg_mux <= '0';
                -- wb: 19
                id_enable_regs <= '0';
                wait for clk_time;
            
        end process;
    end architecture;
