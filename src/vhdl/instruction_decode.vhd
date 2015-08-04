-- Implementation of a 5-stage pipelined MIPS processor's instruction decode stage
-- 2015-08-03   Lukas Jäger     created
-- 2015-08-04   Lukas Jäger     added architecture and started to implement both processes
library IEEE:
    use IEEE.std_logic_1164.all;
library WORK;
    use WORK.cpu_pack.all;
entity instruction_decode is
    port(instr,ip_in, writeback, alu_result: in std_logic_vector (31 downto 0);
        writeback_reg, regdest_ex, regdest_mem : in std_logic_vector (4 downto 0);
        regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
        clk, reset, enable_regs: in std_logic;
        reg_a, reg_b, imm : out std_logic_vector (31 downto 0);
        reg_dest, shift_out : out std_logic_vector (4 downto 0)
        );
end entity;

architecture behavioural of instruction_decode is
    variable register_file  is array (32) of std_logic_vector (31 downto 0);
    signal rd, rs, rt : std_logic_vector(4 downto 0);
    signal imm_16 : std_logic_vector (15 downto 0) <= instr (15 downto 0);
    imm <= X"0000" & imm_16;
    rd <= instr (15 downto 11);
    rt <= instr (20 downto 16);
    rs <= instr (25 downto 21);
    
    process logic is
    begin
        case rs is
            when '';
            when others reg_a <= register_file(rs);
        end case;
    end process;

    process register_file_write (clk) is
    begin
        if (clk = '1' & enable_regs = '1') then
            register_file(writeback_reg) <= writeback;
        end if;
    end process;
end architecture;