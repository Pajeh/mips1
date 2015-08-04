-- Testbench for the instruction decode stage
-- 2015-08-04   Lukas Jäger     created
libary IEEE;
    use IEEE.std_logic_1164.all;
library WORK;
    use WORK.cpu_pack.all;

entity instruction_decode_tb is
end instruction_decode_tb;

architecture behavioural of instruction_decode_tb is
    --  DUT
    component instruction_decode
    port(instr,ip_in, writeback, alu_result: in std_logic_vector (31 downto 0);
        regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
        clk, reset, enable_regs: in std_logic;
        reg_a, reg_b, shift_out, ip_out : out std_logic_vector (31 downto 0);
        reg_dest : out std_logic_vector (4 downto 0);
        imm : out std_logic_vector (15 downto 0)
        );
    end component;
begin
end;
            