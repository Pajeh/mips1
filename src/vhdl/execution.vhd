-- revision history:
-- 03.08.2015     Patrick Appenheimer    created
-- 04.08.2015     Patrick Appenheimer    added alu1
-- 04.08.2015     Patrick Appenheimer    mux1, mux2
-- 05.08.2015     Patrick Appenheimer    bugfixes

library IEEE;
  use IEEE.std_logic_1164.ALL;

library WORK;
  use WORK.all;

entity execution is
    port(
      clk                   : in  std_logic;
      rst                   : in  std_logic;
      ex_alu                : out std_logic_vector(31 downto 0);
      ex_data               : out std_logic_vector(31 downto 0);
      ex_destreg            : out std_logic_vector(4  downto 0);
      ex_alu_zero           : out std_logic_vector(0  downto 0);
      in_a                  : in  std_logic_vector(31 downto 0);
      in_b                  : in  std_logic_vector(31 downto 0);
      in_destreg            : in  std_logic_vector(4 downto 0);
      in_imm                : in  std_logic_vector(31 downto 0);
      in_ip                 : in  std_logic_vector(31 downto 0);
      in_shift              : in  std_logic_vector(4 downto 0);
      in_mux1               : in  std_logic_vector(1 downto 0);
      in_mux2               : in  std_logic_vector(1 downto 0);
      in_alu_instruction    : in  std_logic_vector(5 downto 0)
      
    );
end entity execution;

architecture behave of execution is
signal mux1_out, mux2_out: std_logic_vector(31 downto 0);
begin
  
  
  process
  begin
    ex_destreg <= in_destreg;
  
    case in_mux1 is
      -- 00
      when "00" =>
      mux1_out <= b"000_0000_0000_0000_0000_0000_0000" & in_shift;
      -- 01
      when "01" =>
      mux1_out <= x"0000_0004";
      -- 10
      when "10" =>
      mux1_out <= in_a;
      -- others
      when others => mux1_out <= (others => 'X');
    end case;
    
    case in_mux2 is
      -- 00
      when "00" =>
      mux2_out <= in_b;
      -- 01
      when "01" =>
      mux2_out <= in_imm;
      -- 10
      when "10" =>
      mux2_out <= in_ip;
      -- others
      when others => mux2_out <= (others => 'X');
    end case;
    
  end process;
  
  alu1: entity work.alu(behave) port map(mux1_out, mux2_out, in_alu_instruction, ex_alu, ex_alu_zero);
  
end behave;



