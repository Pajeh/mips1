-- Revision history:
-- 2015-08-12       Lukas Jaeger        created

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library WORK;
use WORK.all;

entity control_pipeline is
    port(
      clk                   	: in  std_logic;
      rst                   	: in  std_logic;
      rd_mask   	        : out std_logic_vector(3  downto 0);
      wr_mask		        : out std_logic_vector(3  downto 0);
      instr_stall       	: in  std_logic;
      data_stall        	: in  std_logic;
      instr_in              	: in  std_logic_vector(31 downto 0);
      alu_op            	: out std_logic_vector(5 downto 0);
      exc_mux1              	: out std_logic_vector(1 downto 0);
      exc_mux2              	: out std_logic_vector(1 downto 0);
      exc_alu_zero		: in  std_logic_vector(0 downto 0);
      memstg_mux        	: out std_logic;
      id_regdest_mux    	: out std_logic_vector (1 downto 0);
      id_regshift_mux       	: out std_logic_vector (1 downto 0);
      id_enable_regs		: out std_logic;
      in_mux_pc             	: out std_logic;
      stage_control		: out std_logic_vector (4 downto 0)
    );
end entity control_pipeline;

architecture behavioural of control_pipeline is
    signal instr_1, instr_2, instr_3, instr_4, instr_5 : std_logic_vector (31 downto 0);
   
    begin
    
    pipeline: process(clk, rst) is
    begin
            if (rst = '1') then
                    instr_1 <= x"00000000";
                    instr_2 <= x"00000000";
                    instr_3 <= x"00000000";
                    instr_4 <= x"00000000";
                    instr_5 <= x"00000000";
            elsif (rising_edge(clk)) then
                    instr_1 <= instr_in;
                    instr_2 <= instr_1;
                    instr_3 <= instr_2;
                    instr_4 <= instr_3;
                    instr_5 <= instr_4;
            end if;
    end process;
    
    id: process (instr_1) is
    begin
            if (instr_1(31 downto 26) = "000000") then -- R-type instructions
                    id_regdest_mux <= "00";
                    id_regshift_mux <= "00";
                    if (instr_1(20 downto 0) = "000000000000000001000") then -- JR-instruction
                            in_mux_pc <= '1';
                    else
                            in_mux_pc <= '0';
                    end if;
            else    -- I-Type- and J-Type instructions. They can go together, because nobody cares about
                    -- the alu-result of a J-Type, so it does not matter, which value is yielded to ex
                    id_regdest_mux <= "10";
                    if (instr_1(31 downto 26) = "001111") then  -- LUI needs a shift
                            id_regshift_mux <= "01";
                    elsif ((instr_1(31 downto 26) = "000010") -- J
                        or (instr_1 (31 downto 26) = "000011") -- JAL
                        or (instr_1 (31 downto 26) = "011101") -- JALX
                        or (instr_1 (31 downto 26) = "000100") -- BEQ
                        or (instr_1 (31 downto 26) = "000001") -- BGEZ
                        or (instr_1 (31 downto 26) = "000111") -- BGTZ
                        or (instr_1 (31 downto 26) = "000110") -- BLEZ
                        or (instr_1 (31 downto 26) = "000101") -- BEQZ
                        ) then
                            id_regshift_mux <= "00";
                            in_mux_pc <= '1';                    
                        else 
                            id_regshift_mux <= "00";
                            in_mux_pc <= '0';
                    end if;                
            end if;
                
    end process;
    
    ex: process (instr_2) is
    begin
            if (instr_2 (31 downto 26) = "001111") then --LUI
                    exc_mux1 <= "00";
                    exc_mux2 <= "01";
                    alu_op <="000100";
            elsif ((instr_2 (31 downto 26) = "001001") --ADDIU 
                or (instr_2 (31 downto 26) = "100011") --LW
                or (instr_2 (31 downto 26) = "101011") --SW
                or (instr_2 (31 downto 26) = "101000") --SB
                or (instr_2 (31 downto 26) = "100100") --LBU
                )then
                    exc_mux1 <="10";
                    exc_mux2 <="01";
                    alu_op <="100000";
            elsif (instr_2 (31 downto 26) = "001010") then --SLTI
                    exc_mux1 <="10";
                    exc_mux2 <="01";
                    alu_op <="001000";
            elsif (instr_2 (31 downto 26) = "001100") then --ANDI
                    exc_mux1 <="10";
                    exc_mux2 <="01";
                    alu_op <="100100";
            else --if (instr_2 (31 downto 26) = "000000") then -- NOP and other R-types and Ops, where the result does not matter
                    exc_mux1 <= "10";
                    exc_mux2 <= "00";
                    alu_op <= "000100";
            end if;            
    end process;
    
    mem: process (instr_3) is
    begin
            if (instr_3 (31 downto 26) = "100011") then --LW
                    memstg_mux <= '1';
                    rd_mask <= "1111";
                    wr_mask <= "0000";
            elsif (instr_3 (31 downto 26) = "100100") then --LBU
                    memstg_mux <= '1';
                    rd_mask <= "0001";
                    wr_mask <= "0000";
            elsif (instr_3 (31 downto 26) = "101011") then --SW
                    memstg_mux <= '0';
                    rd_mask <= "0000";
                    wr_mask <= "1111";
            elsif (instr_3 (31 downto 26) = "101000") then --SB
                    memstg_mux <= '0';
                    rd_mask <= "0000";
                    wr_mask <= "0001";
            else 
                    memstg_mux <= '0';
                    rd_mask <= "0000";
                    wr_mask <= "0000";
            end if;
    end process;
    
    wb: process (instr_4) is
    begin
            if ((instr_4 (31 downto 26) = "001111") or --LUI
            (instr_4 (31 downto 26) = "001001") or --ADDIU
            (instr_4 (31 downto 26) = "100011") or --LW
            (instr_4 (31 downto 26) = "100100") or --LBU
            (instr_4 (31 downto 26) = "001010") or --SLTI
            (instr_4 (31 downto 26) = "001100") --ANDI
            ) then
                    id_enable_regs <= '1';
            else
                    id_enable_regs <= '0';
            end if;
    end process;
    
    stall: process (data_stall, instr_stall) is
    begin
            if (data_stall = '1' or instr_stall = '1') then
                    stage_control = "00000";
            else
                    stage_control = "11111";
            end if;
    end;
    
end architecture;