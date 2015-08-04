#!/usr/bin/perl -w

# revision history
# 02/2014  AS  1.0    initial

#################################################################################
use Fatal qw( open );

# help message
#if( ($#ARGV < 3) ){
#  print "ERROR: not enough command line parameter!\n";
#  exit 0;
#}

#################################################################################
#  _____ ____  _   _  _____ _______       _   _ _______ _____ 
# / ____/ __ \| \ | |/ ____|__   __|/\   | \ | |__   __/ ____|
#| |   | |  | |  \| | (___    | |  /  \  |  \| |  | | | (___  
#| |   | |  | | . ` |\___ \   | | / /\ \ | . ` |  | |  \___ \ 
#| |___| |__| | |\  |____) |  | |/ ____ \| |\  |  | |  ____) |
# \_____\____/|_| \_|_____/   |_/_/    \_\_| \_|  |_| |_____/ 
#################################################################################
#
# command line parameter
#
my $platform_file   = shift;                    # path to platform.h file
my $memory_file     = shift;                    # path to memory.h file
my $main            = shift;                    # name of project
my $data_flag       = shift;                    # data category
my $path            = shift;                    # path to files

#
# heap initial value
#
my $HEAP_INIT       = "01a20000";               # initial heap value

#
# key words
#
my $NOC_INFO        = "NOC_INFO";               # main information
my $MEM_INFO        = "MEM";                    # memory address and length information

#
# output
#
my $FNCT_SIM_HEADER  = "library IEEE;
  use IEEE.std_logic_1164.ALL;\n
entity functions is
  generic (
    CORE        : string(2 downto 1);
    ADDR_LIMIT  : integer
  );
  port (
    addr      : in integer
  );
end entity functions;\n\n
architecture behav_functions of functions is\n
begin\n
  process( addr )
  begin
    if addr <= ADDR_LIMIT then
      case addr is\n";

my $FNCT_SIM_TRAILER= "       when others     => 
      end case;
    end if;
  end process;\n
end behav_functions;\n";

my $HEAP_TRACK_HEADER  = "library IEEE;
  use IEEE.std_logic_1164.ALL;\n
library PLASMA;
  use PLASMA.plasma_pack.ALL;\n
entity heap_tracking is
  generic(
    CORE        : string(2 downto 1)
  );
  port (
    clk         : in std_logic;
    addr        : in t_plasma_word;
    we          : in std_logic;
    data        : in t_plasma_word
  );
end entity heap_tracking;\n\n
architecture behav_heap_tracking of heap_tracking is
begin
  process( clk )
  begin
    if rising_edge( clk ) then
      if we = '1' then\n";

my $HEAP_TRACK_TRAILER = "        end if;
      end if;
    end if;
  end process;
end architecture behav_heap_tracking;\n";

#################################################################################
#__      __     _____  _____          ____  _      ______  _____ 
#\ \    / /\   |  __ \|_   _|   /\   |  _ \| |    |  ____|/ ____|
# \ \  / /  \  | |__) | | |    /  \  | |_) | |    | |__  | (___  
#  \ \/ / /\ \ |  _  /  | |   / /\ \ |  _ <| |    |  __|  \___ \ 
#   \  / ____ \| | \ \ _| |_ / ____ \| |_) | |____| |____ ____) |
#    \/_/    \_\_|  \_\_____/_/    \_\____/|______|______|_____/ 
#################################################################################
#
# parsing
#
my $code_flag       = 0;                        # code section indication
my $heap_flag       = 0;                        # heap initial value found flag
my $sdata_flag      = 0;                        # sdata section

my $addr            = 0;                        # current address
my $double_addr     = 0;                        # variable for double address check
my $h_addr          = "";                       # hex formatted current address
my $prev_addr       = -4;                       # previous address to 0 is -4
my $fnct            = "";                       # current function label
my $code            = "";                       # machine code
my $line            = "";                       # assembler code
my $length          = 0;                        # length of boot.o part
my $message         = "";                       # current simulation message

my $core_idx        = 0;                        # core index
my $msg_idx         = 0;                        # simulation message index
my $core_number     = 0;                        # limit for vhdl type

#
# content information
#
my %noc_info        = ();                       # container for general noc info
my %mem_info        = ();                       # container for memory info
my $heap_addr       = 0;                        # heap pointer address

#
# function table
#
my %fnct_map        = ();                       # function table

#################################################################################
# ____  ______ _____ _____ _   _ 
#|  _ \|  ____/ ____|_   _| \ | |
#| |_) | |__ | |  __  | | |  \| |
#|  _ <|  __|| | |_ | | | | . ` |
#| |_) | |___| |__| |_| |_| |\  |
#|____/|______\_____|_____|_| \_|
#################################################################################
#
# parameter sanity check
#
unless( defined $platform_file  ){ print STDERR "ERROR: no platform.h file defined!\n"; exit 1; }
unless( defined $memory_file    ){ print STDERR "ERROR: no memory.h file defined!\n";   exit 1; }
unless( defined $main           ){ print STDERR "ERROR: no project name defined!\n";    exit 1; }
unless( defined $data_flag      ){ print STDERR "ERROR: no data category defined!\n";   exit 1; }
unless( defined $path           ){ $path = ""; }


# #########################################################
# ___  _    ____ ___ ____ ____ ____ _  _ 
# |__] |    |__|  |  |___ |  | |__/ |\/| 
# |    |___ |  |  |  |    |__| |  \ |  | 
#
# simulation platform information
# open platform.h file and search for key words
#
open( PLATFORM_FILE, "<", $platform_file ) 
    or die "ERROR: cannot open platform.h file! $!\n";

$noc_info{main} = $main;

while(<PLATFORM_FILE>){
  if( /^\s*\#define\s+${NOC_INFO}_(\w+)\s+(\w+)/          ){
            if( $1 eq "DRAM"        ){ $noc_info{dram}        = $2;              # DRAM emulation
        }elsif( $1 eq "3D_DRAM"     ){ $noc_info{fmr}         = $2;              # 3D DRAM emulation
        }else{}
  }else{}
}

close PLATFORM_FILE;

# #########################################################
# _  _ ____ _  _ ____ ____ _   _ 
# |\/| |___ |\/| |  | |__/  \_/  
# |  | |___ |  | |__| |  \   |   
#
# special memory addresses
#
open( MEMORY_FILE, "<", $memory_file ) 
    or die "ERROR: cannot open memory.h file! $!\n";

while(<MEMORY_FILE>){
      if( /^\s*\#define\s+${MEM_INFO}_(\w+)\s+(\w+)/          ){
            if( $1 eq "PROG_START"  ){ $mem_info{prog_start}  = hex($2);
        }elsif( $1 eq "INDT_START"  ){ $mem_info{idata_start} = hex($2);
        }elsif( $1 eq "OUTD_START"  ){ $mem_info{odata_start} = hex($2);
        }else{}
  }else{}
}
    
close MEMORY_FILE;


# #########################################################
#___  ____ ___ ____    ____ ____ ____ ____ ___ _ ____ _  _ 
#|  \ |__|  |  |__|    |    |__/ |___ |__|  |  | |  | |\ | 
#|__/ |  |  |  |  |    |___ |  \ |___ |  |  |  | |__| | \| 
#
# if execution file is there
# only simulation input data file can be created
#
if( $data_flag eq "sim" ){
  if( -e "${path}$noc_info{main}.txt" ){
    create_sim_input();
  }else{ print "ERROR: No ${path}$noc_info{main}.txt file found, create it first!\n"; exit 1; }
  exit 0;
}elsif( $data_flag eq "debug" ){

# #########################################################
# ____ _  _ _  _ ____ ___ _ ____ _  _    ___ ____ ___  _    ____ 
# |___ |  | |\ | |     |  | |  | |\ |     |  |__| |__] |    |___ 
# |    |__| | \| |___  |  | |__| | \|     |  |  | |__] |___ |___  
#
# open map file and search for .text section and global pointer initialisation
# create simulation report file with address and function name
# creat function table file
#
open MAP_FILE,        "< ${path}$noc_info{main}.map",
    or die "ERROR: Could not open ${path}$noc_info{main}.map $!\n";             # map file with function address information
open FNCT_SIM_FILE,   "> $noc_info{main}_functions.vhd",
    or die "ERROR: Could not create fnct_message.vhd $!\n";                     # simulation debug information
open FNCT_LIST_FILE,  "> $noc_info{main}_fnct_list.txt",
    or die "ERROR: Could not create fnct_list.txt $!\n";                        # function table with address and function names
            
print FNCT_SIM_FILE $FNCT_SIM_HEADER;
      
while(<MAP_FILE>){
      
  ###### .TEXT SECTION ######
  if( $code_flag ){                                                             # .text section
        
    if( /^\s*(0x\w+)\s+(\w+)$/ ){
      $addr     = hex($1);                                                      # extract address
      $fnct     = $2;                                                           # extract function name
            
      $fnct_map{$addr} = $fnct;                                                 # add hash entry for each function
      if( $addr != $double_addr ){                                              # remove double entries
        print FNCT_SIM_FILE "       when $addr  => report CORE &\" $fnct\";\n"; # add function debug entry
      }
      print FNCT_LIST_FILE"$addr $fnct\n";                                      # add function table entry

      $double_addr = $addr;
          
    # END OF .TEXT SECTION
    }elsif( /^\s\*\(\.gnu\.warning/ ){ $code_flag = 0; last;                    # detect end of .text section
    }elsif( /^\.data/               ){ $code_flag = 0; last;                    # detect end of .text section
    }else{}
        
  ##### SECTION DETECTION ######
  }else{  
    if( /^\s*\.text/        ){ $code_flag = 1; }                                # detect begin of .text section
  }
}
  
print FNCT_SIM_FILE $FNCT_SIM_TRAILER;

close FNCT_LIST_FILE;
close FNCT_SIM_FILE;
close MAP_FILE;

# sanity check
if( $code_flag ){ print "ERROR: no end of .txt section detected, exit!\n"; exit 1; }

# #########################################################
# ___  ____ ___  _  _ ____    ____ _ _    ____ 
# |  \ |___ |__] |  | | __    |___ | |    |___ 
# |__/ |___ |__] |__| |__]    |    | |___ |___ 
#
# open disassembled file and add function name information
#
#
open LST_FILE, "< ${path}$noc_info{main}.lst",
    or die "ERROR: Could not open $noc_info{main}.lst $!\n";                    # open dissasembled file
open LSTF_FILE, "> $noc_info{main}.lstf",
    or die "ERROR: Could not create $noc_info{main}.lstf $!\n";                 # create debugging file
open TXT_FILE, "> $noc_info{main}.txt",
    or die "ERROR: Could not create $noc_info{main}.txt $!\n";                  # create program file
open HEAP_FILE, "> $noc_info{main}_heap.vhd",
    or die "ERROR: Could not create $noc_info{main}_heap.vhd $!\n";             # create heap tracking file

print HEAP_FILE $HEAP_TRACK_HEADER;
      
while(<LST_FILE>){
  if( $code_flag ){
    if( /^\s*(\w+):\s*(\w+)\s*(.*)/ ){
      $addr = hex($1);                                                          # extract address
      $h_addr = sprintf( '%02x', $addr );                                       # format address as hex string
      $code   = $2;                                                             # extract hex-code
      $line   = $3;                                                             # extract assembler mnemonics
      
      ###### PROGRAMM FILE ######
      # address gap
      if( $addr != ($prev_addr + 4) ){                                          # detect address gap
        while( $addr != ($prev_addr + 4) ){                                     # fill this gap
          print TXT_FILE "00000000\n";                                          # with zeros
          $prev_addr += 4;                                                      # full while gap
        }
      }
      
      print TXT_FILE "$code\n";                                                 # write hex-code to program file
      $prev_addr += 4;                                                          # update previous address for address gap detection
      
      ##### DEBUG FILE ######
      if( exists($fnct_map{$addr}) ){                                           # if this addres is one of function addresses ...
        print LSTF_FILE " $h_addr: $code $line \t\t\t $fnct_map{$addr}\n";      # ... add function name into debugging file
      }else{
        print LSTF_FILE " $h_addr: $code $line\n";                              # ... unless copy line
      }

      ##### HEAP POINTER ADDRESS ######
      #if( $sdata_flag ){
        if( $code eq $HEAP_INIT ){
          if( $heap_flag ){ print STDERR "WARNING: Heap pointer address found twice, take the first occurance!\n";
          }else{
            $heap_addr = sprintf( '%08x', $addr );
            $heap_flag = 1;

            print HEAP_FILE "        if (addr >= x\"$heap_addr\") and (addr <= ";
            $heap_addr = sprintf( '%08x', $addr + 12 );

            print HEAP_FILE "x\"$heap_addr\") then
          report \"heap_addr \" & CORE & \" \" & sv2string(data);\n";
          }
        }
      #}
      
    }else{                                                                      # end of assembler commands
      $code_flag = 0;
    }
  }else{
    if( /^\s*\w+\s+<\.(\w+)/ ){
      if( ($1 eq "text") || ($1 eq "rodata") || ($1 eq "data") || ($1 eq "sdata") || ($1 eq "sbss") ){
        $code_flag = 1;
        if( $1 eq "sdata" ){ $sdata_flag = 1; }
      }
    }
  }
} # LST_FILE

unless( $heap_flag ){ print STDERR "WARNING: No heap pointer address found!\n"; }

print HEAP_FILE $HEAP_TRACK_TRAILER;

#
# ZERO padding of .txt file
#
while( $prev_addr < $mem_info{idata_start} - 4 ){
  print TXT_FILE "00000000\n";
  $prev_addr += 4;
}
  
close HEAP_FILE;
close TXT_FILE;
close LSTF_FILE;
close LST_FILE;



  # ____ _ _  _    _  _ ____ ____ ____ ____ ____ ____ 
  # [__  | |\/|    |\/| |___ [__  [__  |__| | __ |___ 
  # ___] | |  |    |  | |___ ___] ___] |  | |__] |___ 
  #
  # 
  #
  open SIM_MESSAGE, "> $noc_info{main}_sim.tcl"
    or die "ERROR: could not create $noc_info{main}_sim.tcl file $!\n";

  ################## SIM MESSAGE ########################
  if( (-e "${path}$noc_info{main}.sim") && (! -z "${path}$noc_info{main}.sim") ){              # create sim message only if .sim file exists and not empty
    open SIM_STRING_FILE, "< ${path}$noc_info{main}.sim",
      or die "ERROR: Could not open ${path}$noc_info{main}.sim $!\n";

    print SIM_MESSAGE "proc print_message { {core 0} {index \"0\"} {value \"0\"} } {\n";
    print SIM_MESSAGE " global now\n";

    print SIM_MESSAGE "  switch -- \$index {\n";

    while(<SIM_STRING_FILE>){
      $h_addr       = int2hex( $msg_idx );
      $message      = $_; $message =~ s/\r\n|\n|\r//g;                          # get message and cut newline

      print SIM_MESSAGE "    $h_addr { echo \$now ns: core \$core : $message \$value }\n";

      $msg_idx++; 
    }

    print SIM_MESSAGE "  }\n}\n\n";  
  
    close SIM_STRING_FILE;
  }

  close SIM_MESSAGE;

}else{}

exit 0;
#################################################################################
#  _____ _    _ ____  ______ _    _ _   _  _____ _______ _____ ____  _   _  _____ 
# / ____| |  | |  _ \|  ____| |  | | \ | |/ ____|__   __|_   _/ __ \| \ | |/ ____|
#| (___ | |  | | |_) | |__  | |  | |  \| | |       | |    | || |  | |  \| | (___  
# \___ \| |  | |  _ <|  __| | |  | | . ` | |       | |    | || |  | | . ` |\___ \ 
# ____) | |__| | |_) | |    | |__| | |\  | |____   | |   _| || |__| | |\  |____) |
#|_____/ \____/|____/|_|     \____/|_| \_|\_____|  |_|  |_____\____/|_| \_|_____/ 
#################################################################################
#
# format input integer value to hex string
#
sub int2hex {
  local $in_value = shift;

  local $i_string = sprintf( '%08X', $in_value );
  return "  \"32'h$i_string\"";
}

#
# create simulation input files
#
sub create_sim_input {
  #_  _ ____ _  _ ____ ____ _   _ 
  #|\/| |___ |\/| |  | |__/  \_/  
  #|  | |___ |  | |__| |  \   |   
  #
  # create simulation memory file from program and data files
  #
  # data input file check
  unless( -e "$noc_info{main}_data.txt" ){ print "ERROR: no data file found!\n"; exit 1; }

  # append input data to instruction code
  system("cat ${path}$noc_info{main}.txt $noc_info{main}_data.txt > $noc_info{main}_mem.txt");

  # create memory input file(s)
  if( $noc_info{dram} == 1 ){ system("file2out.pl -to_3d $noc_info{main}_mem.txt $noc_info{main}");         # 3D DRAM emulation

                             # create generic memory input files
                            system("file2out.pl -to_3d $noc_info{main}_mem.txt $noc_info{main} no_delay > $noc_info{main}_3D_DRAM_FMR.mem");
  }else                     { system("file2out.pl -mem $noc_info{main}_mem.txt > $noc_info{main}_in.mem"); }    # generic memory model

}
