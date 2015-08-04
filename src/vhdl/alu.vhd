-- revision history:
-- 06.07.2015     Alex Schönberger    created

entity alu is





end entity alu;


entity add is


port( Op1: in bit_vector (31 downto 26);
s: in bit_vector (25 downto 21); 
t: in bit_vector (20 downto 16); 
d: in bit_vector (15 downto 11); 
Op2: in bit_vector (10 downto 0));

end entity add;


architecture structure_alu of alu is

begin

end architecture structure_alu;
