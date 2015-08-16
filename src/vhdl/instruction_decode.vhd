-- Implementation of a 5-stage pipelined MIPS processor's instruction decode stage
-- 2015-08-03   Lukas Jäger     created
-- 2015-08-04   Lukas Jäger     added architecture and started to implement both processes
-- 2015-08-04   Lukas Jäger     added asynchronous reset
-- 2015-08-05	Lukas Jaeger	 fixed bugs that resulted from me not knowing any VHDL
-- 2015-08-05	Lukas Jaeger	 added functionality for branch logic
-- 2015-08-06	Lukas, Carlos 	 fixed bug in JAL-instruction-decode
-- 2015-08-06	Lukas		 added signed/unsigned logic for immediate-output
-- 2015-08-07	Lukas		 added signed/unsigned exceptions for LW-instructions
-- 2015-08-11   Lukas            fixed some bugs in forwarding
-- 2015-08-11	Bahri Enis Demirtel added BLEZ, BLTZ, BLTZAL, BNE
-- 2015-08-12   Lukas           fixed bug in immediate expansion and made it falling clock edge sensitive
-- 2015-08-14   Patrick           minor changes
library IEEE;
    use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

entity instruction_decode is
    port(instr,ip_in, writeback, alu_result, mem_result : in std_logic_vector (31 downto 0);
        writeback_reg, regdest_ex, regdest_mem : in std_logic_vector (4 downto 0);
        regdest_mux, regshift_mux: in std_logic_vector (1 downto 0);
        clk, reset, enable_regs: in std_logic;
        reg_a, reg_b, imm, ip_out : out std_logic_vector (31 downto 0);
        reg_dest, shift_out : out std_logic_vector (4 downto 0)
        );
end entity;

architecture behavioral of instruction_decode is
	type regfile is array (31 downto 0) of std_logic_vector (31 downto 0);
    	signal register_file : regfile;
    	signal imm_internal : std_logic_vector(31 downto 0) := x"00000000";
	signal internal_writeback : std_logic_vector(31 downto 0);
    	signal pc_imm : std_logic_vector (31 downto 0);
    	signal imm_16 : std_logic_vector (15 downto 0); 
	signal internal_wb_flag : std_logic := '0';
begin
	imm_16  <= instr (15 downto 0);

 	-- Splitting registers for R-type-instructions
    	pc_imm <= imm_internal (31 downto 2) & "00";
	-- Defines the instruction decode logic
    	logic : process (instr, ip_in, writeback, alu_result, mem_result, writeback_reg, regdest_ex, regdest_mem, regdest_mux, regshift_mux)  is
    		begin

		-- Forwarding logic for reg_a
		-- If the destination register is still used by the writeback-phase, the writeback-output is forwarded
                if ((instr (25 downto 21) = regdest_ex) and (instr (25 downto 21) /= "00000")) then 
			reg_a <= alu_result;
		-- If the destination register is still used by the memory-phase, the alu-result is forwarded
		elsif ((instr (25 downto 21) = regdest_mem) and (instr (25 downto 21) /= "00000")) then 
			reg_a <= mem_result;
                elsif ((instr (25 downto 21) = writeback_reg)and (instr (25 downto 21) /= "00000")) then
                        reg_a <= writeback;
		-- Otherwise, no forwarding is required and the register specified by rs is read
		else 
			reg_a <= register_file(to_integer(unsigned (instr (25 downto 21))));
		end if;

		
		--Forwarding logic for reg_b. Works analogously to the reg_a block above
		if ((instr (20 downto 16) = regdest_ex) and (instr (20 downto 16) /= "00000")) then 
			reg_b <= alu_result;
		elsif ((instr (20 downto 16) = regdest_mem) and (instr (20 downto 16) /= "00000")) then 
			reg_b <= mem_result;
                elsif ((instr (20 downto 16) = writeback_reg) and (instr (20 downto 16) /= "00000")) then
                        reg_b <= writeback;
		else 
			reg_b <= register_file(to_integer(unsigned (instr (20 downto 16))));
		end if;
        
        	case regshift_mux is    -- Determines the output at shift_out
            		when "00" => shift_out <= instr(10 downto 6);
            		when "01" => shift_out <= "10000";
            		when others => shift_out <= "00000";
        	end case;
        
        	case regdest_mux is     -- Determines the output at reg_dest
            		when "00" => reg_dest <= instr (15 downto 11);
            		when "01" => reg_dest <= "11111";
            		when "10" => reg_dest <= instr (20 downto 16);
            		when others => reg_dest <= "00000";
        	end case;
    	end process;

	-- Process for clocked writebacks to the register file and the asynchronous reset
	register_file_write : process (clk,reset,writeback_reg) is
    	begin
    		if (reset= '1') then    -- asynchronous reset
					for i in 0 to 31 loop
                	register_file(i) <= x"00000000";
            	end loop;
        	elsif (clk'event and clk = '0') then
				if (enable_regs = '1') then  -- If register file is enabled, write back result
					if (to_integer(unsigned (writeback_reg)) > 0) then
									register_file(to_integer(unsigned (writeback_reg))) <= writeback;
					end if;
				elsif (internal_wb_flag = '1') then
					register_file (31) <= internal_writeback;
				end if;
			end if;
    	end process;
	-- Process that defines the branch logic
	branch_logic : process (instr, ip_in, writeback, alu_result, mem_result, writeback_reg, regdest_ex, regdest_mem, regdest_mux, regshift_mux) is
	variable offset : integer;
	variable a, b : integer;
	begin
		-- Prepares values of reg_a and reg_b for comparison
		if ((instr (25 downto 21) = regdest_ex) and (instr (25 downto 21) /= "00000")) then 
			a := to_integer(signed(alu_result));
		elsif ((instr (25 downto 21) = regdest_mem) and (instr (25 downto 21) /= "00000")) then 
			a := to_integer(signed(mem_result));
                elsif ((instr (25 downto 21) = writeback_reg) and (instr (25 downto 21) /= "00000")) then
                        a := to_integer(signed(writeback));
		else 
			a := to_integer(signed(register_file(to_integer(unsigned (instr (25 downto 21))))));
		end if;

		
		if ((instr (20 downto 16) = regdest_ex) and (instr (20 downto 16) /= "00000")) then 
			b:= to_integer(signed(alu_result));
		elsif ((instr (20 downto 16) = regdest_mem) and (instr (20 downto 16) /= "00000")) then 
			b := to_integer(signed(mem_result));
                elsif ((instr (20 downto 16) = writeback_reg) and (instr (20 downto 16) /= "00000")) then
                        b := to_integer(signed(writeback));
		else 
			b := to_integer(signed(register_file(to_integer(unsigned (instr (20 downto 16))))));
		end if;


		-- Annoyingly lengthy list of if-statements for calculation of branch logic
		if (instr (31 downto 26) = "000010") then -- Jump instruction
			internal_wb_flag <= '0';
			offset := to_integer(signed(instr(25 downto 0)));
			offset := (offset * 4);
			ip_out <= ip_in (31 downto 28) & std_logic_vector(to_signed(offset,28));
		elsif ((instr (31 downto 26) = "000011") or (instr (31 downto 26) = "011101")) then --JAL(X) instruction
			internal_writeback <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4,32));
			internal_wb_flag <= '1';
			offset := to_integer(signed(instr(25 downto 0)));
			offset := offset * 4;
			ip_out <= ip_in (31 downto 28) & std_logic_vector(to_signed(offset,28));
		elsif ((instr(31 downto 26) = "000000") and (instr (20 downto 0) ="000000000000000001000")) then --JR instruction
			internal_wb_flag <= '0';
			offset := to_integer(signed(instr(25 downto 0)));
			offset := offset * 4;
			-- VHDL code d�j�-vu?
			-- This is the same forwarding logic as above for reg_a
                        if ((instr (25 downto 21) = regdest_ex) and (instr (25 downto 21) /= "00000")) then 
				ip_out <= alu_result;
			elsif ((instr (25 downto 21) = regdest_mem) and (instr (25 downto 21) /= "00000")) then 
				ip_out <= mem_result;
                        elsif ((instr (25 downto 21) = writeback_reg) and (instr (25 downto 21) /= "00000")) then
                                ip_out <= writeback;
			else 
				ip_out <= register_file(to_integer(unsigned (instr (25 downto 21))));
			end if;
                elsif (instr (31 downto 26) = "000100") then        --BEQ
                        internal_wb_flag <= '0';
                        if (a = b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in));
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;
		elsif ((instr (31 downto 26) = "000001") and (instr (20 downto 16) = "00001")) then --BGEZ instruction
			internal_wb_flag <= '0';
			b :=0;
                        if (a >= b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in));
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;
		elsif ((instr (31 downto 26) = "000001") and (instr (20 downto 16) = "10001")) then --BGEZAL instruction
			internal_wb_flag <= '1';
			internal_writeback <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4,32));
			b :=0;
                        if (a >= b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in));
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;
		elsif ((instr (31 downto 26) = "000111")and(instr (20 downto 16)="00000")) then -- BGTZ
			internal_wb_flag <= '0';
			b :=0;
			report "The value of 'a' is " & integer'image(a);
			if (a > b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in));
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;		
		elsif ((instr (31 downto 26) = "000110")and(instr (20 downto 16)="00000")) then -- BLEZ
			internal_wb_flag <= '0';
			b :=0;
			if (a <= b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in));
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;		
		elsif ((instr (31 downto 26) = "000001")and(instr (20 downto 16)="00000")) then -- BLTZ
			internal_wb_flag <= '0';
			b :=0;
			if (a < b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in));
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;
		elsif ((instr (31 downto 26) = "000001")and(instr (20 downto 16)="10000")) then -- BLTZAL
			internal_wb_flag <= '1';
			internal_writeback <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4,32));
			b :=0;
			if (a < b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in));
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;							
		elsif (instr (31 downto 26) = "000101") then -- BNE
			internal_wb_flag <= '0';
			if (a /= b) then
                                offset := to_integer(signed(instr(15 downto 0)));
                                offset := offset * 4;
                                offset := offset + to_integer (signed(ip_in)) - 4;
                                ip_out <= std_logic_vector(to_signed(offset,32));
                        else
                                ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
                        end if;
		else
			ip_out <= std_logic_vector(to_unsigned(to_integer(unsigned(ip_in)) + 4, 32));
		end if;
	end process;

	imm_expand : process (instr) is
	begin
                imm <= std_logic_vector(to_signed(to_integer(signed (instr (15 downto 0))),32));
	end process;
end architecture;

-- FSM-signal-Howto:
--
-- regdest_mux:
-- 00: if instruction is of R-type
-- 01: if regdest must be set to 31 (JAL?)
-- 10: if instruction is of I-type
-- 11: NEVER EVER EVER!!!
--
-- regshift_mux:
-- 00: if instruction is of R-type
-- 01: if shift must be 16 (No idea which instruction uses that...)
-- 10: if you like non-deterministic behaviour
-- 11: if you love non-deterministic behaviour
--
-- enable_regs:
-- 1: if the writeback-stage just finished an R-type- or I-type-instruction (except for JR)
-- 0: if the writeback-stage just finished a J-type-instruction or JR

