library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.cpu_pack.all;

entity tb_cpu_alternative is
end entity tb_cpu_alternative;

architecture behavioural of tb_cpu_alternative is

        component cpu is
                port(
                clk                     : in  std_logic;
                rst                     : in  std_logic;
                instr_addr              : out std_logic_vector(31 downto 0);
                data_addr               : out std_logic_vector(31 downto 0);
                rd_mask                 : out std_logic_vector(3  downto 0);
                wr_mask                 : out std_logic_vector(3  downto 0);
                instr_stall             : in  std_logic;
                data_stall              : in  std_logic;
                instr_in                : in  std_logic_vector(31 downto 0);
                data_to_cpu             : in  std_logic_vector(31 downto 0);
                data_from_cpu           : out std_logic_vector(31 downto 0)
                );
        end component;
        
        signal clk, rst, instr_stall, data_stall : std_logic;
        signal instr_in, data_to_cpu : std_logic_vector (31 downto 0);
        
        constant clk_time : time := 10 ns;
        
        begin
                dut: cpu port map(
                        clk => clk,
                        rst => rst,
                        instr_stall => instr_stall,
                        data_stall => data_stall,
                        instr_in => instr_in,
                        data_to_cpu => data_to_cpu
                );
                
        clk_proc : process
        begin
                clk <= '0';
                wait for clk_time / 2;
                clk <= '1';
                wait for clk_time / 2;
        end process;
        
        test_proc: process
        begin
                instr_stall <= '0';
                data_stall <= '0';
                instr_in <= x"00000000";
                data_to_cpu <= x"00000000";
                rst <= '1';
                wait for clk_time / 2;
                rst <= '0';
                wait for clk_time / 2;
                
                -- Program Prefix
                instr_in <= x"3c1c0001"; -- LUI $gp, 1
                wait for clk_time;
                instr_in <= x"279c8070"; -- ADDIU $ ǵp, $gp, -32656
                wait for clk_time;
                instr_in <= x"08000004"; -- J 0x10
                wait for clk_time;
                instr_in <= x"3c1d00a2"; -- LUI $sp, 0xA2
                wait for clk_time;
                instr_in <= x"8f828010"; -- LW $v0, -32756($gp)
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                instr_in <= x"a0400000"; -- sb	zero,0(v0)
                data_to_cpu <= x"00000080";
                wait for clk_time;
                instr_in <= x"af80800c"; -- sw	zero,-32756(gp)
                wait for clk_time;
                instr_in <= x"8f82800c"; -- lw	v0,-32756(gp)
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                instr_in <= x"28420010"; -- slti	v0,v0,16
                data_to_cpu <= x"00000000";
                wait for clk_time;
                instr_in <= x"1040000a"; -- beqz	v0,0x58
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                
                -- LOOP STARTS HERE!!!
                instr_in <= x"8f82800c"; -- lw	v0,-32756(gp)
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                instr_in <= x"24420001"; -- addiu	v0,v0,1
                wait for clk_time;
                instr_in <= x"af82800c"; -- sw	v0,-32756(gp)
                wait for clk_time;
                instr_in <= x"8f82800c"; -- lw	v0,-32756(gp)
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                instr_in <= x"28420010"; -- slti	v0,v0,16
                wait for clk_time;
                instr_in <= x"1440fff8"; -- bnez	v0,0x34
                data_to_cpu <= x"00000001";
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                
                instr_in <= x"8f82800c"; -- lw	v0,-32756(gp)
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                instr_in <= x"24420001"; -- addiu	v0,v0,1
                wait for clk_time;
                instr_in <= x"af82800c"; -- sw	v0,-32756(gp)
                wait for clk_time;
                instr_in <= x"8f82800c"; -- lw	v0,-32756(gp)
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                instr_in <= x"28420010"; -- slti	v0,v0,16
                wait for clk_time;
                instr_in <= x"1440fff8"; -- bnez	v0,0x34
                wait for clk_time;
                instr_in <= x"00000000"; -- NOP
                wait for clk_time;
                
                
        end process;
                
                
end architecture;