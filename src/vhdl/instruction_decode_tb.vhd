-- Testbench for the instruction decode stage
-- 2015-08-04   Lukas Jäger     created
libary IEEE;
    use IEEE.std_logic_1164.all;
library WORK;
    use WORK.cpu_pack.all;
use textio.all;

entity instruction_decode_tb is
end instruction_decode_tb;

architecture behavioural of instruction_decode_tb is
    --  DUT
    component instruction_decode
    port(instr,ip_in, writeback, alu_result: in std_logic_vector (31 downto 0);
        writeback_reg, regdest_ex, regdest_mem : in std_logic_vector (4 downto 0);
        regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
        clk, reset, enable_regs: in std_logic;
        reg_a, reg_b, imm : out std_logic_vector (31 downto 0);
        reg_dest, shift_out : out std_logic_vector (4 downto 0)
        );
    end component;
    
    signal instr : std_logic_vector (31 downto 0) := x"00000000";
    signal ip_in : std_logic_vector (31 downto 0) := x"00000000";
    signal writeback : std_logic_vector (31 downto 0) := x"00000000";
    signal alu_result : std_logic_vector (31 downto 0) := x"00000000";
    signal writeback_reg : std_logic_vector (4 downto 0) := '00001';
    signal regdest_mem : std_logic_vector (4 downto 0) := '00000';
    signal regdest_ex : std_logic_vector (4 downto 0) := '00000';
    signal regdest_mux : std_logic_vector (1 downto 0) := '00';
    signal regshift_mux : std_logic_vector (1 downto 0) := '00';
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable_regs : std_logic := '0';
    -- Tweak clock frequency here
    constant clk_time = 10ns;
begin
    dut: instruction_decode port map(
        instr => instr, 
        ip_in => ip_in,
        writeback => writeback,
        writeback_reg => writeback_reg,
        alu_result => alu_result,
        regdest_mux => regdest_mux,
        regshift_mux => regshift_mux,
        clk => clk,
        reset => reset,
        enable_regs => enable_regs
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
        enable_regs = '1';
        -- Writing some test values to the register file:
        -- r1 becomes 01234567
        writeback_reg <= 00001;
        writeback <= x"01234567";
        wait for clk_time;
        
        -- r2 becomes 76543210
        writeback_reg <= 00010;
        writeback <= x"7654321";
        wait for clk_time;
        
        -- Real testing starts here
        enable_regs <= '0';
        
        --inserting an add-instruction that adds r1 and r2 to r3
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: 76543210
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
        instr <= x"00221820";
        wait for clk_time;
    end process;
end;
            