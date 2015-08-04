##########################################################################
# ____ ____ _  _ ____ ____ ____ _    
# | __ |___ |\ | |___ |__/ |__| |    
# |__] |___ | \| |___ |  \ |  | |___ 
SHELL           = /usr/bin/X11/tcsh

##########################################################################
# ___  ____ ___ _  _ ____ 
# |__] |__|  |  |__| [__  
# |    |  |  |  |  | ___]
#
# compiler bin and library paths
#
BIN_PATH       = $(MIPS_GCC)/bin
MIPS_FLOAT     = $(MIPS_GCC)/lib/gcc/mips-elf/$(MIPS_GCC_VERSION)/soft-float

##########################################################################
# ___  ____ ____ ____ ____ ____ _  _ _  _ ____ 
# |__] |__/ |  | | __ |__/ |__| |\/| |\/| [__  
# |    |  \ |__| |__] |  \ |  | |  | |  | ___]
#
# GENERAL COMPILING
#
GCC     		   	= $(BIN_PATH)/mips-elf-gcc
AS  		       	= $(BIN_PATH)/mips-elf-as
LD         			= $(BIN_PATH)/mips-elf-ld
DISASMB         = $(BIN_PATH)/mips-elf-objdump

#
# SIMULATION ENVIRONMENT
#
FILE2OUT        = ../../scripts/file2out.pl
LST2FILES       = ../../scripts/lst2files.pl

##########################################################################
# ____ _    ____ ____ ____ 
# |___ |    |__| | __ [__  
# |    |___ |  | |__] ___] 
#
# compile flags
#
CFLAGS    = -EB
CFLAGS   += -O2 
CFLAGS   += -c -s -std=c99
CFLAGS   += -w -Wfatal-errors 
CFLAGS   += -mips1
CFLAGS   += -msoft-float
CFLAGS   += -I$(MIPS_INCLUDE)

#
# disassemble flags
#
DISFLAGS  = --disassemble-all --disassemble-zeroes

#
# linking flags
#
LFLAGS    = -Tmemory.lds
LFLAGS   += -L$(MIPS_FLOAT)
LFLAGS   += -L$(MIPS_LIB)
LFLAGS   += -s -N
LFLAGS   += -warn-once

#
# linking libraries
#
LLIBS     = -lmipsS
LLIBS    += -lgcc


#####################################################
# ___  _  _ _ _    ___  _ _  _ ____ 
# |__] |  | | |    |  \ | |\ | | __ 
# |__] |__| | |___ |__/ | | \| |__] 
boot.o: boot.asm
	$(AS) -o boot.o boot.asm

counter.lstf: counter.c boot.o
	$(GCC) $(CFLAGS) counter.c -o counter.o
	@ echo ------------ compile done ---------------
	$(LD) $(LFLAGS) -Map counter.map boot.o counter.o $(LLIBS) -o counter.axf
	@ echo ------------ link done ------------------
	$(DISASMB) $(DISFLAGS) counter.axf > counter.lst
	@ echo ------------ disassemble done -----------
	$(LST2FILES) platform.h $(MIPS_INCLUDE)/memory.h counter debug
	$(FILE2OUT) -mem counter.txt 0 256 > counter.mem
	@ echo ------------ simulation data created ----

counter: counter.lstf
	@ echo ------------ done --------------------
 
#####################################################
# CLEAN
clean:
	rm *.o
	rm counter.*
	rm counter_*
