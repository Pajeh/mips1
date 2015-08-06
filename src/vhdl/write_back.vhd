-- 03.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;


entity write_back is
port(

clk, rst: in std_logic;
writeback_in, regdest_in : in  std_logic_vector(31 downto 0);
writeback_out, regdest_out : out std_logic_vector(31 downto 0));



end entity write_back;


architecture behavioral of write_back is
begin


writeback_out <= writeback_in;
regdest_out <= regdest_in;


end architecture behavioral;




