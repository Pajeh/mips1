-- revision history:
-- 05.08.2015     Bahri Enis Demirtel    created

entity tb_instruction_fetch is
end entity tb_instruction_fetch;

architecture behav_tb_instruction_fetch of tb_instruction_fetch is

  component instruction_fetch 
  end component instruction_fetch;

  signal 

begin

  uut: instruction_fetch
    PORT MAP(
    );

  process
  begin

    wait;
  end process;

end architecture behav_tb_instruction_fetch;
