-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 07.08.2015     Patrick Appenheimer   cpu_datapath instanciated
-- 10.08.2015     Bahri Enis Demirtel cpu_control added

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

signal alu_op               : std_logic_vector(5 downto 0);
signal exc_mux1             : std_logic_vector(1 downto 0);
signal exc_mux2             : std_logic_vector(1 downto 0);
signal exc_alu_zero         : std_logic_vector(0 downto 0);
signal memstg_mux           : std_logic;
signal id_regdest_mux       : std_logic_vector (1 downto 0);
signal id_regshift_mux      : std_logic_vector (1 downto 0);
signal id_enable_regs       : std_logic;
signal in_mux_pc            : std_logic;
signal stage_control        : std_logic_vector (4 downto 0);




begin

  
  -- control logic
   u1_control: entity work.cpu_control(structure_cpu_control)
	PORT MAP(clk, rst, rd_mask, wr_mask, instr_stall, data_stall, instr_in, data_to_cpu, 
			 data_from_cpu, alu_op, exc_mux1, exc_mux2, exc_alu_zero, memstg_mux, id_regdest_mux, id_regshift_mux,
			 id_enable_regs, in_mux_pc, stage_control
	);
  
  
  
  
  -- datapath
   u2_datapath: entity work.cpu_datapath(structure_cpu_datapath)
     PORT MAP(clk, rst, instr_addr, data_addr, instr_in, data_to_cpu, data_from_cpu, alu_op, exc_mux1, exc_mux2,
              exc_alu_zero, memstg_mux, id_regdest_mux, id_regshift_mux, id_enable_regs, in_mux_pc, stage_control
     );

end architecture structure_cpu;
