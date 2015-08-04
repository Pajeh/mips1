#!/usr/bin/perl -w

# revision history
# 02/2014  AS  1.0    initial

#################################################################################
use Fatal qw( open );

#################################################################################
#  _____ ____  _   _  _____ _______       _   _ _______ _____ 
# / ____/ __ \| \ | |/ ____|__   __|/\   | \ | |__   __/ ____|
#| |   | |  | |  \| | (___    | |  /  \  |  \| |  | | | (___  
#| |   | |  | | . ` |\___ \   | | / /\ \ | . ` |  | |  \___ \ 
#| |___| |__| | |\  |____) |  | |/ ____ \| |\  |  | |  ____) |
# \_____\____/|_| \_|_____/   |_/_/    \_\_| \_|  |_| |_____/ 
#################################################################################
#
# .conf file
#
my $conf_file         = shift;                    # name of .conf file
my $src_path          = shift;                    # path to source files
my $work_path         = shift;                    # path to working directory
my $name              = shift;                    # name of test file
my $level             = shift;                    # level flag

#
# key words
#
my $SIMULATOR         = "SIMULATOR";              # key word for simulator information
my $SCRIPTS           = "SCRIPTS";                # key word for additional tcl scripte

my $SIM_FLAG          = "S";                      # simulation command
my $OPT_FLAG          = "P";                      # simulator options
my $TOP_FLAG          = "T";                      # top module information
my $RUN_FLAG          = "R";                      # simulation run information

my $INCL_FLAG         = "INCL";                   # extern file include

my $CONST_FLAG        = "CONST";                  # script contains constant information

#
# output
#

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
my $group_comment     = 0;                        # group comment
my $simulator_flag    = 0;                        # simulator content found
my $scripts_flag      = 0;                        # scripts content found
my $line              = "";                       # current content line

#
# content information
#
my @simulator         = ();                       # array of simulator information
my @scripts           = ();                       # array of additional scripts
my @constants         = ();                       # array of scripts with constants information

#
# simulator information
#
my $sim_cmd           = "";                       # simulation command
my $sim_par           = "";                       # simulation options
my $sim_top           = "";                       # simulation top module
my $sim_run           = "-all";                   # simulation time
my $sim_val           = 0;                        # simulation time value

#
# help variables
#
my $idx               = 0;                        # current array index

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
unless( defined $conf_file ){ print STDERR "ERROR: no .conf file defined!\n"; exit 1;  }
unless( defined $src_path  ){ print STDERR "ERROR: no source path defined!\n"; exit 1; }
unless( defined $work_path ){ print STDERR "ERROR: no working path defined!\n"; exit 1; }
unless( defined $name      ){ print STDERR "ERROR: no name defined!\n"; exit 1; }
unless( defined $level     ){ $level = 0; }


# ____ ____ _  _ ____    ____ _ _    ____ 
# |    |  | |\ | |___    |___ | |    |___ 
#.|___ |__| | \| |       |    | |___ |___ 
#
# open .conf file
# search for compiler and files information
#
open( CONF_FILE, "<", $conf_file ) 
    or die "ERROR: cannot open $conf_file file! $!\n";
    
while(<CONF_FILE>){
  if( $group_comment ){ if(/^\s*--\//){ $group_comment = 0; }else{ next; }
  }else{ if(/^\s*--\//){ $group_comment = 1; }}
  ##################### KEY WORD PARSING ########################################
      if( /^\s*$/  ){                                                           # empty line
  }elsif( /^\s*--/ ){                                                           # comment line
  }elsif( /^\s*\/\/$SIMULATOR/){                                                # simulator information
    $simulator_flag   = 1;
    $scripts_flag     = 0;
  }elsif( /^\s*\/\/$SCRIPTS/){                                                  # additional tcl scripts information
    $simulator_flag   = 0;
    $scripts_flag     = 1;
  }elsif( /^\s*\/\/\w+/      ){                                                 # other keyword
    $simulator_flag   = 0;
    $scripts_flag     = 0;
  }
  ##################### CONTENT #################################################
  else{
    if( $simulator_flag ){
      $line = $_;
      $line =~ s/\r\n|\n|\r//;                                                  # cut newline
      # ############ FILE INCLUDING ###############
      if( $line =~ /^\s*\#$INCL_FLAG\s+(.*)/ ){
        $cur_filename = $1;
        open( ADD_FILE, "<", "$src_path/vopt/$cur_filename" )
          or next;
          
        while(<ADD_FILE>){
              if( /^\s*$/  ){                                                   # empty line
          }elsif( /^\s*--/ ){                                                   # comment line
          }else{
            $line = $_;
            $line =~ s/\r\n|\n|\r//;
            push( @simulator, $line );
          }
        }
        
        close ADD_FILE;
      }else{
        push( @simulator, $line );
      }
    }elsif( $scripts_flag ){
      if( /^\s*\#$CONST_FLAG\s+(.+)$/ ){
        push( @constants, $1 );
      }else{
        push( @scripts, $_ );
      }
    }else{}
  }
}
    
close CONF_FILE;

#____ _ _  _ _  _ _    ____ ___ ____ ____ 
#[__  | |\/| |  | |    |__|  |  |  | |__/ 
#___] | |  | |__| |___ |  |  |  |__| |  \ 
#
# extract general simulator information from the content
#
if( @simulator ){  
  foreach( @simulator ){    
        if( /^\s*\#$SIM_FLAG\s+(\w+)/ ){
          $sim_cmd = $1;
    }elsif( /^\s*\#$OPT_FLAG\s+(.+)$/ ){
          $sim_par .= " $1";
    }elsif( /^\s*\#$TOP_FLAG\s+(.+)$/ ){
          $sim_top = $1;
    }elsif( /^\s*\#$RUN_FLAG\s+(-all|\d+)\s*(\w*)/ ){
          $sim_val = $1;    $sim_run = $sim_val;
          if( defined $2 ){ $sim_run = "$1 $2"; }
    }else{}    
  }

# ############## LIBRARY CREATION ONLY ################
}else{

  print "proc c {} {";                                                           # compile
  system("conf2arg.pl $conf_file $src_path $work_path sim");
  print "}\n";

  print "\nproc q {} { exit -f }\n";                                             # exit

  exit 0;
}

#____ ____ _  _ _ ___ _   _    ____ _  _ ____ ____ _  _ 
#[__  |__| |\ | |  |   \_/     |    |__| |___ |    |_/  
#___] |  | | \| |  |    |      |___ |  | |___ |___ | \_ 
if( $sim_cmd eq "" ){print STDERR "ERROR: No simulator defined, nothing to do!\n";  exit 1}
if( $sim_top eq "" ){print STDERR "ERROR: No top module defined, nothing to do!\n"; exit 1}

#____ _  _ ___ ___  _  _ ___ 
#|  | |  |  |  |__] |  |  |  
#|__| |__|  |  |    |__|  |  
#
# create output function
#
# gui       - gui simulation with all short cuts
# batch     - batch simulation
#
    if( $level == 1 ){                                                        # elaboration file creation
  system( "$sim_cmd -elab $sim_top.elab $sim_par work.$sim_top\n" );  exit 0;
}elsif( $level == 2 ){                                                        # elaboration file open
  system( "$sim_cmd -c -load_elab $sim_top.elab -do \"source simulate_$name.tcl;batch_run\"\n" );  exit 0;
}elsif( $level == 3 ){                                                        # restore checkpoint
  system( "$sim_cmd -c -restore checkpoint_$name.cpt -do \"source simulate_$name.tcl;run -all\"\n" ); exit 0;
}elsif( $level == 4 ){                                                        # open log
  system( "$sim_cmd -view gold.wlf -do \"source simulate_$name.tcl;do wave_$name.do\"\n" ); exit 0;
}else{}


############ GENERAL FUNCTIONS #####################
print "proc c {} {";                                                           # compile
system("conf2arg.pl $conf_file $src_path $work_path sim");
print "}\n";

print "\nproc r {} { restart -f\n";                                            # restart
print "              run $sim_run\n";
print "             }\n";

print "\nproc rr {} { c\n";                                                    # compile and restart
print "             r\n";
print "            }\n";

print "\nproc rs {} { source sim_message.tcl\n";                               # load new sim message, compile and restart
print "               rr\n";
print "             }\n";

print "\nproc n {} {delete wave *\n";                                          # update wave
print "             do wave_$name.do\n";
print "            }\n";

print "\nproc batch_run {} {\n";                                               # batch simulation run
print "run $sim_run\n";
print "}\n\n";

print "\nproc chk_create { {number 0} } {\n";                                  # checkpoint creation
print "checkpoint chk_${name}_\$number.cpt\n";
print "}\n\n";

print "\nproc q {} { exit -f }\n";                                             # exit

############ GUI SIMULATION ########################
print "\nproc gui {} {";
print "\n$sim_cmd $sim_par work.$sim_top\n";                                   # simulation start command
if( @scripts ){                                                                # additional tcl scripts if available
  foreach( @scripts ){ print "source $_"; }
}
print "do wave_$name.do\n";                                                    # wave definitions
print "run $sim_run\n";                                                        # simulator run command
print "}\n\n";

############ BATCH SIMULATION ######################
print "proc batch {} {\n";
print "$sim_cmd $sim_par work.$sim_top\n";                                     # simulation start command
if( @scripts ){                                                                # additional tcl scripts if available
  foreach( @scripts ){ print "source $_"; }
}
print "batch_run\n";
print "}\n\n";

if( @constants ){                                                              # additional constants or tcl scripts with constants
  foreach( @constants ){
    if( /(\w+)\s+(.+)$/ ){                                                     # tcl constant
      print "set $1 $2\n";
    }else{                                                                     # tcl constant script
      print "source $_";
    }    
  }
}

exit 0;
