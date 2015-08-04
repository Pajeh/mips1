-- revision history:
-- 06.07.2015     Alex Schönberger    created

library IEEE;
  use IEEE.std_logic_1164.ALL;

library WORK;
  use WORK.cpu_pack.all;

entity cpu is
    port(
      clk                     : in  std_logic;
      rst                     : in  std_logic;
      instr_addr              : out std_logic_vector(31 downto 0);
      data_addr               : out std_logic_vector(31 downto 0);
      rd_mask                 : out std_logic_vector(3  downto 0);
      wr_mask                 : out std_logic_vector(3  downto 0);
      instr_stall             : in  std_logic;
      data_stall              : in  std_logic;
      instr_in                : in  std_logic_vector(31 downto 0);
      data_to_cpu             : in  std_logic_vector(31 downto 0);
      data_from_cpu           : out std_logic_vector(31 downto 0)
    );
end entity cpu;

architecture structure_cpu of cpu is

begin

  --
  -- control logic
  --
  -- u1_control: cpu_control
  --   -- GENERIC MAP(  )
  --   PORT MAP( 
  --   );

  --
  -- datapath
  --
  -- u2_datapath: cpu_datapath
  --   -- GENERIC MAP( )
  --   PORT MAP(
  --   );

end architecture structure_cpu;