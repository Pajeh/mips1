#!/usr/bin/perl -w

# revision history
# 09/2014  AS  1.0    initial

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
# .conf file
#
my $conf_file         = shift;                    # name of .conf file
my $src_path          = shift;                    # path to source files
my $work_path         = shift;                    # work path
my $name              = shift;                    # name of test file

#
# key words
#
my $SYNTHESIS         = "SYNTHESIS";              # key word for synthesis information

my $COMMAND_FLAG      = "C";                      # data flow command flag
my $P_FLAG            = "P";                      # parameter flag
my $FOLDER_FLAG       = "F";                      # working folder flag
my $INPUT_FLAG        = "I";                      # input file flag
my $OUTPUT_FLAG       = "O";                      # output file flag
my $LOG_FLAG          = "L";                      # log file flag
my $END_FLAG          = "";                       # end of command information flag

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
my $syn_flag          = 0;                        # synthesis content found

#
# content information
#
my @synthesis         = ();                       # synthesis content
my @commands          = ();                       # data flow commands

my %cur_env           = (                         # current enviroment
              command    => "",
              folder     => "",
              input      => "",
              output     => "",
              log        => ""
                        );

my @cur_par           = ();                       # array of current parameter

#
# script creation
#
my $options           = "";                       # options for extern program call

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
unless( defined $conf_file ){ print STDERR "ERROR: no .conf file defined!\n";   exit 1; }
unless( defined $src_path  ){ print STDERR "ERROR: no source path defined!\n";  exit 1; }
unless( defined $work_path ){ print STDERR "ERROR: no working path defined!\n"; exit 1; }
unless( defined $name      ){ print STDERR "ERROR: no name defined!\n";         exit 1; }

# ____ ____ _  _ ____    ____ _ _    ____ 
# |    |  | |\ | |___    |___ | |    |___ 
#.|___ |__| | \| |       |    | |___ |___ 
#
# open .conf file
# search for synthesis information
#
open( CONF_FILE, "<", $conf_file ) 
    or die "ERROR: cannot open $conf_file file! $!\n";
    
while(<CONF_FILE>){
  ##################### KEY WORD PARSING ########################################
      if( /^\s*$/  ){                                                           # empty line
  }elsif( /^\s*--/ ){                                                           # comment line
  }elsif( /^\s*\/\/$SYNTHESIS/){                                                # synthesis information
    $syn_flag       = 1;
  }elsif( /^\s*\/\/\w+/      ){                                                 # other keyword
    $syn_flag       = 0;
  }
  ##################### CONTENT #################################################
  else{
    if( $syn_flag ){
      push( @synthesis,  $_ );
    }else{}
  }
}
    
close CONF_FILE;

#____ ____ ___ ___ _ _  _ ____ ____ 
#[__  |___  |   |  | |\ | | __ [__  
#___] |___  |   |  | | \| |__] ___] 
#
# extract settings information
#
if( @synthesis ){
  foreach( @synthesis ){
        if( /^\s*\#$COMMAND_FLAG\s+(.+)/  ){  $cur_env{command} = $1;
    }elsif( /^\s*\#$P_FLAG\s+(.+)/        ){  push( @cur_par, $1 );
    }elsif( /^\s*\#$FOLDER_FLAG\s+(.+)/   ){  $cur_env{folder}  = $1;
    }elsif( /^\s*\#$INPUT_FLAG\s+(.+)/    ){  $cur_env{input}   = $1;
    }elsif( /^\s*\#$OUTPUT_FLAG\s+(.+)/   ){  $cur_env{output}  = $1;
    }elsif( /^\s*\#$LOG_FLAG\s+(.+)/      ){  $cur_env{log}     = $1;
    }elsif( /^\s*\#$END_FLAG\s*$/         ){

      # ########## SYNPLIFY ####################
      if( $cur_env{command} eq "synplify_pro" ){

        # open tcl script
        open( CMD_FILE, ">", "${name}_netlist.tcl")
          or die "ERROR: could not open ${name}_netlist.tcl! $!\n";

        print CMD_FILE "project -new ${name}\n";                                # create new project
        print CMD_FILE "project -result_file $cur_env{output}\n";               # specify output file
        print CMD_FILE "project -log_file    reports/$cur_env{log}\n";          # cpecify log file

        close CMD_FILE;

        # add source files
        $options  = $conf_file;                         # .conf file
        $options .= " $src_path";                       # source path
        $options .= " $work_path";                      # work path
        $options .= " syn";                             # level
        $options .= " 1>>${name}_netlist.tcl";          # netlist script

        system( "conf2arg.pl $options" );

        # add implementation parameters
        open( CMD_FILE, ">>", "${name}_netlist.tcl")
          or die "ERROR: could not open ${name}_netlist.tcl! $!\n";

        # set parameter
        if( @cur_par ){
            print CMD_FILE "\n";
          foreach( @cur_par ){
            print CMD_FILE "set_option $_\n";
          }
            print CMD_FILE "\n";
        }

        # create current implementation
        print CMD_FILE "impl -add netlist -type fpga\n";
        print CMD_FILE "impl -active \"netlist\"\n";

        close CMD_FILE;
      }else{}

      # clear current environment
      clear_env();

    }else{}
  }
}else{
  print "ERROR: no synthesis information found, exit!\n";
  exit 1;
}


# ____ _  _ ___ ___  _  _ ___ 
# |  | |  |  |  |__] |  |  |  
# |__| |__|  |  |    |__|  |  

exit 0;

sub clear_env{
 
  %cur_env           = (
              command    => "",
              folder     => "",
              input      => "",
              output     => "",
              log        => ""
                        );

  @cur_par           = ();
}
