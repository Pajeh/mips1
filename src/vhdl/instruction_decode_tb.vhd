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
        regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
        clk, reset, enable_regs: in std_logic;
        reg_a, reg_b, shift_out, ip_out : out std_logic_vector (31 downto 0);
        reg_dest : out std_logic_vector (4 downto 0);
        imm : out std_logic_vector (15 downto 0)
        );
    end component;
    
    signal instr : std_logic_vector (31 downto 0) := x"00000000";
    signal ip_in : std_logic_vector (31 downto 0) := x"00000000";
    signal writeback : std_logic_vector (31 downto 0) := x"00000000";
    signal alu_result : std_logic_vector (31 downto 0) := x"00000000";
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
end;
            