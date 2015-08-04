-- Implementation of a 5-stage pipelined MIPS processor's instruction decode stage
-- 2015-08-03   Lukas Jäger     created
-- 2015-08-04   Lukas Jäger     added architecture and started to implement both processes
-- 2015-08-04   Lukas Jäger     added asynchronous reset
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
    -- The MIPS' register file
    variable register_file  is array (32) of std_logic_vector (31 downto 0);
    signal rd, rs, rt : std_logic_vector(4 downto 0);
    signal imm_16 : std_logic_vector (15 downto 0) := instr (15 downto 0);
    imm := X"0000" & imm_16;        -- Imm is the subvector of instr from 15 to 0 and it is padded with leading zeros for further processing.
    
    -- Splitting registers for R-type-instructions
    rd := instr (15 downto 11);
    rt := instr (20 downto 16);
    rs := instr (25 downto 21);
    
    -- Defines the instruction decode logic
    process logic is
    begin
        case rs is                                      -- Determining the output at reg_a
            -- If regdest is still used in the writeback stage, its input is forwarded
            when regdest_mem => reg_a <= writeback;  
            -- If regdest is still used in the memory stage, its input is forwarded
            when regdest_ex => reg_a <= alu_result;
            -- No forwarding required, reg_a is just read from the register file
            when others => reg_a <= register_file(rs);
        end case;
        case rt is
            -- Works analogously to the determination of reg_a.
            when regdest_mem => reg_b <= writeback;
            when regdest_ex => reg_b <= alu_result;
            when others => reg_b <= register_file(rt);
        end case;
    end process;

    -- Process for clocked writebacks to the register file and the asynchronous reset
    process register_file_write (clk,reset) is
    begin
        if (reset= '1') then    -- asynchronous reset
            for index in 0 to 31 loop
                register_file(i) <= x"00000000";
        elsif (clk = '1' & enable_regs = '1') then  -- If register file is enabled, write back result
            register_file(writeback_reg) <= writeback;
        end if;
    end process;
end architecture;
