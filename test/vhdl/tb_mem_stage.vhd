-- revision history:
-- 05.08.2015     Carlos Minamisava Faria    created

entity tb_mem_stage is
end entity tb_mem_stage;

architecture behav_tb_mem_stage of tb_mem_stage is

  component mem_stage 
  end component mem_stage;

  signal 

begin

  uut: mem_stage
    PORT MAP(
    );

  process
  begin

    wait;
  end process;

end architecture behav_mem_stage;
