-- 03.08.2015     Bahri Enis Demirtel    created


library IEEE;
  use IEEE.std_logic_1164.ALL;


entity write_back is
port(

clk : in std_logic; 
rst : in std_logic;
writeback_in : in  std_logic_vector(31 downto 0);
regdest_in : in  std_logic_vector(4 downto 0);
writeback_out : out std_logic_vector(31 downto 0);
regdest_out : out std_logic_vector(4 downto 0)
);


end entity write_back;


architecture behavioral of write_back is

begin

process (rst, clk, writeback_in, regdest_in) is
	begin

		if(rst = '0') then
		writeback_out <= x"0000_0000";		
		regdest_out <= b"00000";
		
		
		
		else

			writeback_out <= writeback_in;
			regdest_out <= regdest_in;

		end if;
	end process ; 
end architecture behavioral;
