-- Testbench for the instruction decode stage
-- 2015-08-04   Lukas Jäger     created
-- 2015-08-04   Lukas Jäger     added test cases for forwarding
-- 2015-08-05	Lukas Jaeger	 adjusted dut to new interface
-- 2015-08-05	Lukas Jaeger	 added expected data for ip_out
library IEEE;
    use IEEE.std_logic_1164.all;

entity instruction_decode_tb is
end instruction_decode_tb;

architecture behavioural of instruction_decode_tb is
    --  DUT
    component instruction_decode
    port(instr,ip_in, writeback, alu_result: in std_logic_vector (31 downto 0);
        writeback_reg, regdest_ex, regdest_mem : in std_logic_vector (4 downto 0);
        regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
        clk, reset, enable_regs: in std_logic;
        reg_a, reg_b, imm, ip_out : out std_logic_vector (31 downto 0);
        reg_dest, shift_out : out std_logic_vector (4 downto 0)
        );
    end component;
    
    signal instr : std_logic_vector (31 downto 0) := x"00000000";
    signal ip_in : std_logic_vector (31 downto 0) := x"00000000";
    signal writeback : std_logic_vector (31 downto 0) := x"00000000";
    signal alu_result : std_logic_vector (31 downto 0) := x"00000000";
    signal writeback_reg : std_logic_vector (4 downto 0) := "00001";
    signal regdest_mem : std_logic_vector (4 downto 0) := "00000";
    signal regdest_ex : std_logic_vector (4 downto 0) := "00000";
    signal regdest_mux : std_logic_vector (1 downto 0) := "00";
    signal regshift_mux : std_logic_vector (1 downto 0) := "00";
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal enable_regs : std_logic := '0';
    -- Tweak clock frequency here
    constant clk_time : time := 10 ns;
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
        enable_regs => enable_regs,
	regdest_ex => regdest_ex,
	regdest_mem => regdest_mem
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
        reset <= '0';
        wait for 5 ns;
        reset <= '1';
        wait for 5 ns;
        enable_regs <= '1';
        -- Writing some test values to the register file:
        -- r1 becomes 01234567
        writeback_reg <= "00001";
        writeback <= x"01234567";
        wait for clk_time;
        
        -- r2 becomes 76543210
        writeback_reg <= "00010";
        writeback <= x"76543210";
        wait for clk_time;
        enable_regs <= '0';
	writeback_reg <= "00000";
	wait for clk_time;
        -- Real testing starts here
        

        
        --inserting an add-instruction that adds r1 and r2 to r3
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: 76543210
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 0000303C
        instr <= x"00221820";
        wait for clk_time;
        
        -- inserting an add instruction that adds r1 and r2 to r3 while r2 is still in memory stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: fedcba98
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 0000303C
        alu_result <= x"fedcba98";
        regdest_ex <= "00010";
        instr <= x"00221820";
        wait for clk_time;
        regdest_ex <= "00000";
        
        -- inserting an add instruction that adds r1 and r2 to r3 while r2 is still in writeback stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: 01101001
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 0000303C
        writeback <= x"01101001";
        regdest_mem <= "00010";
        instr <= x"00221820";
        wait for clk_time;
        regdest_mem <= "00000";
        
        -- inserting an add instruction that adds r1 and r2 to r3 while r2 is still in both stages
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: 01101001
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 0000303C
        regdest_ex <= "00010";
        regdest_mem <= "00010";
        instr <= x"00221820";
        wait for clk_time;
        regdest_mem <= "00000";
        regdest_ex <= "00000";
        
        -- inserting an add instruction that adds r1 and r2 to r3 while r1 is still in memory stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: fedcba98
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 0000303C
        regdest_ex <= "00001";
        instr <= x"00221820";
        wait for clk_time;
        regdest_ex <= "00000";
        
        -- inserting an add instruction that adds r1 and r2 to r3 while r1 is still in writeback stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: 01101001
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 0000303C
        writeback <= x"01101001";
        regdest_mem <= "00001";
        instr <= x"00221820";
        wait for clk_time;
        regdest_mem <= "00000";

        -- inserting an add instruction that adds r1 and r2 to r3 while r2 is still in both stages
        --outputs should be (all vals in hex notation):
        --  reg_a: 01234567
        --  reg_b: 01101001
        --  reg_dest: 3;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 0000303C
        regdest_ex <= "00001";
        regdest_mem <= "00001";
        instr <= x"00221820";
        wait for clk_time;
        regdest_mem <= "00000";
        regdest_ex <= "00000";
        
        -- inserting an addi instruction that adds abcd in hex notation to r1 and stores it in r2
        -- outputs should be (all vals in hex notation):
        -- reg_a: 01234567
        -- reg_b: 00000000;
        -- reg_dest: 2;
        -- imm: 0000abcd
        -- shift: 0
	-- ip_out: fffeaf34
        instr <= x"2422abcd";
        wait for clk_time;
        
	-- Jump Register - Jump to the address contained in register $s
	-- encoding 0000 00ss sss0 0000 0000 0000 0000 1000
	-- Test: jump using register 1 value. Encoding 0020_0008
        -- reg_a: 01234567
        -- reg_b: 00000000;
        -- reg_dest: 2;
        -- imm: 0000abcd
        -- shift: 0
	-- ip_out: 01234567
        instr <= x"00200008";
        wait for clk_time;

	-- Jump 
	-- ip_out : 02af37bc
	ip_in <= x"01010101";
	instr <= x"08abcdef";
	wait for clk_time;

	-- JAL
	-- ip_out : 02af37bc
	instr <= x"0cabcdef";
	wait for clk_time;
        
        
	-- Forwarding test for regdest_ex and alu_result using a jump
	 -- jump to register value instruction that r1 is still in memory stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 
        --  reg_b: 
        --  reg_dest: ;
        --  imm: 1820
        --  shift: 0
	--  ip_out: fedcba98
        alu_result <= x"fedcba98";
        regdest_ex <= "00001";
        instr <= x"00200008";
        wait for clk_time;
        regdest_ex <= "00000";
        wait for clk_time;

	-- Forwarding test for regdest_ex and alu_result using a jump
	 -- jump to register value instruction that r2 is still in memory stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 
        --  reg_b: 
        --  reg_dest: ;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 1edf2a98
        alu_result <= x"1edf2a98";
        regdest_ex <= "00010";
        instr <= x"00400008";
        wait for clk_time;
        regdest_ex <= "00000";
        wait for clk_time;        

	-- Forwarding test for regdest_mem and writeback using a jump
	 -- jump to register value instruction that r1 is still in writeback stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 
        --  reg_b: 
        --  reg_dest: ;
        --  imm: 1820
        --  shift: 0
	--  ip_out: fedcba98
        writeback <= x"fedcba98";
        regdest_mem <= "00001";
        instr <= x"00200008";
        wait for clk_time;
        regdest_mem <= "00000";
        wait for clk_time;

	-- Forwarding test for regdest_mem and writeback using a jump
	 -- jump to register value instruction that r2 is still in writeback stage
        --outputs should be (all vals in hex notation):
        --  reg_a: 
        --  reg_b: 
        --  reg_dest: ;
        --  imm: 1820
        --  shift: 0
	--  ip_out: 1edf2a98
        writeback <= x"1edf2a98";
        regdest_mem <= "00010";
        instr <= x"00400008";
        wait for clk_time;
        regdest_mem <= "00000";
        wait for clk_time;  
        
    end process;
end;
            
