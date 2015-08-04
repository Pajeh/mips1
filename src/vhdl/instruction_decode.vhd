-- Implementation of a 5-stage pipelined MIPS processor's instruction decode stage
-- 2015-08-03   Lukas Jäger     created

library IEEE:
    use IEEE.std_logic_1164.all;
library WORK;
    use WORK.cpu_pack.all;
entity instruction_decode is
    port(instr,ip_in, writeback, alu_result: in std_logic_vector (31 downto 0);
        writeback_reg : in std_logic_vector (4 downto 0);
        regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
        clk, reset, enable_regs: in std_logic;
        reg_a, reg_b : out std_logic_vector (31 downto 0);
        reg_dest, shift_out : out std_logic_vector (4 downto 0);
        imm : out std_logic_vector (15 downto 0)
        );
end entity;

architecture behavioural of instruction_decode is

process is
begin
end process;