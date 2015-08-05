-- revision history:
-- 06.07.2015     Alex Schönberger    created
-- 05.08.2015     Patrick Appenheimer    first try


entity cpu_datapath is

end entity cpu_datapath;


architecture structure_cpu_datapath of cpu_datapath is

begin

instruction_fetch:    entity work.instruction_fetch(behavioral) port map(  TODO );
instruction_decode:   entity work.instruction_decode(behavioral) port map(  TODO );
execution:            entity work.execution(behave) port map(  TODO );
memory_stage:         entity work.MemoryStage(behavioral) port map(  TODO );
write_back:           entity work.write_back(behavioral) port map(  TODO );


end architecture structure_cpu_datapath;
