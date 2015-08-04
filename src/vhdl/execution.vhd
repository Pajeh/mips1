-- revision history:
-- 03.08.2015     Patrick Appenheimer    created

library IEEE;
  use IEEE.std_logic_1164.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity execution is
    port(
      clk                     : in  std_logic;
      rst                     : in  std_logic;
      ex_alu                  : out std_logic_vector(31 downto 0);
      ex_data                 : out std_logic_vector(31 downto 0);
      ex_destreg              : out std_logic_vector(4  downto 0);     
      in_a	              : in  std_logic_vector(31 downto 0);
      in_b	              : in  std_logic_vector(31 downto 0);
      in_destreg              : in  std_logic_vector(4 downto 0);
      in_imm	              : in  std_logic_vector(31 downto 0);
      in_ip	              : in  std_logic_vector(31 downto 0);
      in_shift	              : in  std_logic_vector(4 downto 0);
      in_mux1		      : in  std_logic_vector(1 downto 0);
      in_mux2		      : in  std_logic_vector(1 downto 0);
      
    );
end entity execution;

architecture regdest of execution is
BEGIN 
      PROCESS
      BEGIN
         WAIT UNTIL clk'EVENT AND clk='1';
         ex_destreg <= in_destreg;
      END PROCESS;
END regdest;


