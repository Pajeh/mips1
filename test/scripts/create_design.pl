#!/usr/bin/perl -w
###################################################################################################
# --------------------------------------------------------------------------
# >>>>>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<
# --------------------------------------------------------------------------
# TITLE:       CREATE DESIGN
# AUTHOR:      Alex Schoenberger (Alex.Schoenberger@ies.tu-darmstadt.de)
# COMMENT:     script for control design creation automatisation
#
# www.ies.tu-darmstadt.de
# TU Darmstadt
# Institute for Integrated Systems
# Merckstr. 25
#
# 64283 Darmstadt - GERMANY
# --------------------------------------------------------------------------
# PROJECT:       Digital Design automatisation scripts
# FILENAME:      create_design.pl
# --------------------------------------------------------------------------
# COPYRIGHT: 
#  This project is distributed by GPLv2.0
#  Software placed into the public domain by the author.
#  Software 'as is' without warranty.  Author liable for nothing.
# --------------------------------------------------------------------------
# DESCRIPTION:
#    test case manipulation and help scripts call
#
#
# --------------------------------------------------------------------------
# Revision History
# --------------------------------------------------------------------------
# Revision   Date    Author     CHANGES
# 1.0      4/2014    AS         initial
# --------------------------------------------------------------------------
###################################################################################################
use utf8;
use Fatal qw( open );
use Tie::File;

# help message
if( ($#ARGV < 0) || ($#ARGV > 2) || ($ARGV[0] =~ /(-h)+/) ){
  print_help();
  exit 0;
}

###################################################################################################
 ######   #######  ##    ##  ######  ########    ###    ##    ## ########  ######  
##    ## ##     ## ###   ## ##    ##    ##      ## ##   ###   ##    ##    ##    ## 
##       ##     ## ####  ## ##          ##     ##   ##  ####  ##    ##    ##       
##       ##     ## ## ## ##  ######     ##    ##     ## ## ## ##    ##     ######  
##       ##     ## ##  ####       ##    ##    ######### ##  ####    ##          ## 
##    ## ##     ## ##   ### ##    ##    ##    ##     ## ##   ###    ##    ##    ## 
 ######   #######  ##    ##  ######     ##    ##     ## ##    ##    ##     ######  
###################################################################################################
#
# environment constants
#
my $pwd_path            = `pwd`;
my $home_path           =  $ENV{'HOME'};
my $dev_path            =  $ENV{'DEV_PATH'};
my $work_path           = "$home_path/WORK";
my $config_path         = "$work_path/.config";
my $list_file           = "$config_path/test_list.txt";

#
# execution $test_parameter{level}
#
use constant LEVEL    => {  
      create    => "create",
      load      => "l",
      compile   => "c",
      elab      => "e",
      syn       => "s",
      open      => "o",
      restore   => "r",
      batch     => "b",
      gui       => "gui",
      cb        => "cb",
      lb        => "lb",
      new       => "lc",
      all       => "lcb"
    };

###################################################################################################
##     ##    ###    ########  ####    ###    ########  ##       ######## 
##     ##   ## ##   ##     ##  ##    ## ##   ##     ## ##       ##       
##     ##  ##   ##  ##     ##  ##   ##   ##  ##     ## ##       ##       
##     ## ##     ## ########   ##  ##     ## ########  ##       ######   
 ##   ##  ######### ##   ##    ##  ######### ##     ## ##       ##       
  ## ##   ##     ## ##    ##   ##  ##     ## ##     ## ##       ##       
   ###    ##     ## ##     ## #### ##     ## ########  ######## ######## 
###################################################################################################
#
# command line options
#
my %par_arguments      =(  
      -a    => 3,     # add test file
      -r    => 2,     # remove test file
      -l    => 1,     # list all test files
                
      -tb   => 2,     # create config file

      -sim  => 3,     # start simulation test
      -ver  => 3,     # start verification test
      -syn  => 3,     # start synthesis test
                
      -h    => 1      # print help
    );
my $parameter         = "";                 # current command line parameter
my %cl_option         = ();                 # command line options

#
# parsing variables
#
my $test_name         = "";                 # current name of test
my $test_level        = "";                 # current level
my $path              = "";                 # source path
my $global_option     = "";                 # simulation, verification or synthesis
my $test_flag         = 0;                  # found flag


#
# test cases
#
my @lines             = ();
my %test_parameter    = ();
my $compile_only      = 0;


#
# temp/help variable
#
my $idx               = 0;


###################################################################################################
########  ########  ######   #### ##    ## 
##     ## ##       ##    ##   ##  ###   ## 
##     ## ##       ##         ##  ####  ## 
########  ######   ##   ####  ##  ## ## ## 
##     ## ##       ##    ##   ##  ##  #### 
##     ## ##       ##    ##   ##  ##   ### 
########  ########  ######   #### ##    ## 
###################################################################################################
#
# ENVIRONMENT
#
unless( -d $work_path   ){ mkdir $work_path;               }                                      # create working directory
unless( -d $config_path ){ mkdir $config_path;             }                                      # create config directory
unless( -e $list_file   ){ system("touch", "$list_file");  }                                      # create test case list file


###################################################################################################
######## ########  ######  ########    ######     ###     ######  ########  ######  
   ##    ##       ##    ##    ##      ##    ##   ## ##   ##    ## ##       ##    ## 
   ##    ##       ##          ##      ##        ##   ##  ##       ##       ##       
   ##    ######    ######     ##      ##       ##     ##  ######  ######    ######  
   ##    ##             ##    ##      ##       #########       ## ##             ## 
   ##    ##       ##    ##    ##      ##    ## ##     ## ##    ## ##       ##    ## 
   ##    ########  ######     ##       ######  ##     ##  ######  ########  ######  
###################################################################################################
#
# COMMAND LINE OPTIONS
#
$parameter   = shift;

# __  __          _   _ _    _ _____  _    _ _            _______ _____ ____  _   _ 
#|  \/  |   /\   | \ | | |  | |  __ \| |  | | |        /\|__   __|_   _/ __ \| \ | |
#| \  / |  /  \  |  \| | |  | | |__) | |  | | |       /  \  | |    | || |  | |  \| |
#| |\/| | / /\ \ | . ` | |  | |  ___/| |  | | |      / /\ \ | |    | || |  | | . ` |
#| |  | |/ ____ \| |\  | |__| | |    | |__| | |____ / ____ \| |   _| || |__| | |\  |
#|_|  |_/_/    \_\_| \_|\____/|_|     \____/|______/_/    \_\_|  |_____\____/|_| \_|
if( exists($par_arguments{$parameter}) ){                                       # check parameter for availability

  # ############### MAIN PARAMETER ##############################################
  $cl_option{MAIN} = $parameter;           $cl_option{IDX} = 1;                 # main command line option

  # ############### NAME ########################################################
  $parameter = shift; 
  if( defined $parameter ){                                                     # name commmand line option
    $cl_option{NAME} = $parameter;         $cl_option{IDX} = 2;

  # ############### LEVEL #######################################################
    $parameter = shift; 
    if( defined $parameter ){                                                   # level/path command line option
      $cl_option{LEVEL} = $parameter;      $cl_option{IDX} = 3;}
    else{
      if( ($cl_option{MAIN} eq "-sim") ||
          ($cl_option{MAIN} eq "-ver") ||
          ($cl_option{MAIN} eq "-syn") ){
      $cl_option{LEVEL} = "gui";           $cl_option{IDX} = 3;}
    }
  }
                          
  unless( $cl_option{IDX} == $par_arguments{$cl_option{MAIN}} ){                # check for correct number of arguments
    print "WARNING: Incorrect number of arguments, exit!\n";
    print_help(); 
    exit 1;
  }
}else{
  print "WARNING: No parameter \"$parameter\" defined, exit!\n";
  print_help();
  exit 1;
}


#____ ___  ___     ___ ____ ____ ___ 
#|__| |  \ |  \     |  |___ [__   |  
#|  | |__/ |__/     |  |___ ___]  |  
if   ( $cl_option{MAIN} eq "-a" ){                                              # check for "add test case" parameter
  #
  # check for double entry
  #
  open (TEST_LIST, "<", $list_file )                                           # open test list file
    or die "ERROR: cannot open $list_file! $!\n";

  while(<TEST_LIST>){
    if( /^\s*(\w+)\s+(.+)$/ ){
      if( $1 eq $cl_option{NAME} ){
        $test_flag    = 1;
        print "WARNING: There is an existing test case with the name \"$cl_option{NAME}\"!\n";
      }
    }
  }
    
  close TEST_LIST;

  unless( $test_flag ){
    system("echo \"$cl_option{NAME} $cl_option{LEVEL}\" >> $list_file" );       # add test case
  }

  exit 0;
  
#____ ____ _  _ ____ _  _ ____    ___ ____ ____ ___ 
#|__/ |___ |\/| |  | |  | |___     |  |___ [__   |  
#|  \ |___ |  | |__|  \/  |___     |  |___ ___]  |      
}elsif( $cl_option{MAIN} eq "-r" ){                                          # check for "remove" parameter
  
  tie @lines, 'Tie::File', $list_file 
    or die "ERROR: cannot open $list_file! $!\n";
    
  $idx = 0;
  foreach( @lines ){
    if( /^\s*$cl_option{NAME}/ ){                                             # search for test case
      splice( @lines, $idx, 1);                                               # remove this test case
    }
    $idx++;
  }
    
  untie @lines;

  exit 0;
 
#_    _ ____ ___    ___ ____ ____ ___    ____ ____ ____ ____ ____ 
#|    | [__   |      |  |___ [__   |     |    |__| [__  |___ [__  
#|___ | ___]  |      |  |___ ___]  |     |___ |  | ___] |___ ___]   
}elsif( $cl_option{MAIN} eq "-l" ){                                           # check for "list" parameter
  
  open (TEST_LIST, "<", $list_file )                                          # open test list file
    or die "ERROR: cannot open $list_file! $!\n";
    
  while(<TEST_LIST>){ print $_; }                                             # print its content
    
  close TEST_LIST;

  exit 0;

#____ ____ ____ ____ ___ ____     ____ ____ _  _ ____    ____ _ _    ____ 
#|    |__/ |___ |__|  |  |___     |    |  | |\ | |___    |___ | |    |___ 
#|___ |  \ |___ |  |  |  |___    .|___ |__| | \| |       |    | |___ |___     
}elsif( $cl_option{MAIN} eq "-tb"){                                           # check for "testbench" parameter
  
  print_default_conf( $cl_option{NAME} );

  exit 0;

# ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
# [__  | |\/| |  | |    |__|  |  | |  | |\ | 
# ___] | |  | |__| |___ |  |  |  | |__| | \| 
}elsif( $cl_option{MAIN} eq "-sim" ){
  $global_option = "sim";

# _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
# |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
#  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
}elsif( $cl_option{MAIN} eq "-ver" ){
  $global_option = "ver";

# ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
# [__   \_/  |\ |  |  |__| |___ [__  | [__  
# ___]   |   | \|  |  |  | |___ ___] | ___]                                           
}elsif( $cl_option{MAIN} eq "-syn" ){
  $global_option = "syn";
  
}else{
  print "WARNING: No parameter $cl_option{MAIN} defined, exit!\n";
  print_help();
  exit 1;
}
    
# ________   ________ _____ _    _ _______ _____ ____  _   _ 
#|  ____\ \ / /  ____/ ____| |  | |__   __|_   _/ __ \| \ | |
#| |__   \ V /| |__ | |    | |  | |  | |    | || |  | |  \| |
#|  __|   > < |  __|| |    | |  | |  | |    | || |  | | . ` |
#| |____ / . \| |___| |____| |__| |  | |   _| || |__| | |\  |
#|______/_/ \_\______\_____|\____/   |_|  |_____\____/|_| \_|
#
# open test list file and search for test case
#  
open (TEST_LIST, "<", $list_file ) or die "ERROR: cannot open $list_file! $!\n";
  while( <TEST_LIST> ){ 
    if( /^\s*(\w+)\s+(.+)$/ ){ $test_cases{$1} = $2; }}                      # extract all test cases
close TEST_LIST;

$test_name  = $cl_option{NAME};
$test_level = $cl_option{LEVEL};
  
if( exists($test_cases{$test_name}) ){
  $test_parameter{level} = "gui";                                            # default level
  %test_parameter = ( 
    src_path  => $test_cases{$test_name},
    test_name => $test_name,
    level     => $test_level,
    conf_file => "$test_cases{$test_name}/${test_name}.conf",
    test_path => "$work_path/${test_name}"
  );

  get_env();
            
          if( $test_parameter{level} eq LEVEL->{load}   ){ create_files();
      }elsif( $test_parameter{level} eq LEVEL->{compile}){ compile_src();
      }elsif( $test_parameter{level} eq LEVEL->{elab}   ){ create_elab();
      }elsif( $test_parameter{level} eq LEVEL->{syn}    ){ start_synthesis();
      }elsif( $test_parameter{level} eq LEVEL->{open}   ){ open_elab();
      }elsif( $test_parameter{level} eq LEVEL->{restore}){ restore();
      }elsif( $test_parameter{level} eq LEVEL->{batch}  ){ start_batch();
      }elsif( $test_parameter{level} eq LEVEL->{gui}    ){ start_gui();
      }elsif( $test_parameter{level} eq LEVEL->{new}    ){ create_files();
                                                           compile_src();
      }elsif( $test_parameter{level} eq LEVEL->{cb}     ){ compile_src();
                                                           start_batch();
      }elsif( $test_parameter{level} eq LEVEL->{lb}     ){ create_files();
                                                           start_batch();
      }elsif( $test_parameter{level} eq LEVEL->{all}    ){ create_files();
                                                           compile_src();
                                                           start_batch();
      }elsif( $test_parameter{level} eq LEVEL->{create} ){ system( "testgui.pl $test_parameter{conf_file}" );
      }else{}
}else{
  print "WARNING: No test \"$test_name\" found, exit!\n";
  exit 1;
} 

exit 0;
# ###################################################################################################
# ######## ##    ## ########  
# ##       ###   ## ##     ## 
# ##       ####  ## ##     ## 
# ######   ## ## ## ##     ## 
# ##       ##  #### ##     ## 
# ##       ##   ### ##     ## 
# ######## ##    ## ########  
# ###################################################################################################


###################################################################################################
 ######  ##     ## ########  ######## ##     ## ##    ##  ######  ######## ####  #######  ##    ##  ######  
##    ## ##     ## ##     ## ##       ##     ## ###   ## ##    ##    ##     ##  ##     ## ###   ## ##    ## 
##       ##     ## ##     ## ##       ##     ## ####  ## ##          ##     ##  ##     ## ####  ## ##       
 ######  ##     ## ########  ######   ##     ## ## ## ## ##          ##     ##  ##     ## ## ## ##  ######  
      ## ##     ## ##     ## ##       ##     ## ##  #### ##          ##     ##  ##     ## ##  ####       ## 
##    ## ##     ## ##     ## ##       ##     ## ##   ### ##    ##    ##     ##  ##     ## ##   ### ##    ## 
 ######   #######  ########  ##        #######  ##    ##  ######     ##    ####  #######  ##    ##  ###### 
###################################################################################################
##################################
#     # ####### #       ######  
#     # #       #       #     # 
#     # #       #       #     # 
####### #####   #       ######  
#     # #       #       #       
#     # #       #       #       
#     # ####### ####### #       
##################################
#
# print help string and exit
#
sub print_help{
  print "usage: create_design.pl [OPTION] [NAME] [LEVEL|PATH]
provides digital design automatisation flow

Examples: 
  create_design.pl -l
  create_design.pl -a   my_test \$HOME/my_path
  create_design.pl -tb  my_test
  create_design.pl -sim my_test c
  create_design.pl -ver my_test cr
  create_design.pl -syn my_test b
  
OPTION can be:
  -a    append a test indicated by name
  -r    remove a test indicated by name
  -l    list all registered tests

  -tb   create a .conf file sceleton, name of test needed

  -sim  simulate   design depending on LEVEL
  -ver  ferificate design depending on LEVEL
  -syn  synthesise design depending on LEVEL

  -h    display this message
  
LEVEL can be:
  create    start GUI configuration manager

  l     create or update working files
  c     compile/synthesise sources
  e     create elaboration/mapping file
  s     create bit file/synthesise design
  o     open existing elaboration file and start command line mode
  r     start simulation from checkpoint
  b     start in command line mode
  gui   start gui [DEFAULT LEVEL]

  lc    create/update files, compile
  cb    compile and start batch simulation
  lcb   create/update, compile and start batch simulation
";
}

#######################################################################################################################
 #####  ######  #######    #    ####### #######    ####### #######  #####  #######    ######  ####### #     #  #####  #     # 
#     # #     # #         # #      #    #             #    #       #     #    #       #     # #       ##    # #     # #     # 
#       #     # #        #   #     #    #             #    #       #          #       #     # #       # #   # #       #     # 
#       ######  #####   #     #    #    #####         #    #####    #####     #       ######  #####   #  #  # #       ####### 
#       #   #   #       #######    #    #             #    #             #    #       #     # #       #   # # #       #     # 
#     # #    #  #       #     #    #    #             #    #       #     #    #       #     # #       #    ## #     # #     # 
 #####  #     # ####### #     #    #    #######       #    #######  #####     #       ######  ####### #     #  #####  #     # 
sub print_default_conf{

  local $l_test_name      = shift;            # test name
  local @all_files        = glob("*");        # all file in the working directory
  
#  _____ ____  _   _ ______   ______ _____ _      ______ 
# / ____/ __ \| \ | |  ____| |  ____|_   _| |    |  ____|
#| |   | |  | |  \| | |__    | |__    | | | |    | |__   
#| |   | |  | | . ` |  __|   |  __|   | | | |    |  __|  
#| |___| |__| | |\  | |      | |     _| |_| |____| |____ 
# \_____\____/|_| \_|_|      |_|    |_____|______|______|
  open CONF_FILE, "> $l_test_name.conf" or
    die "ERROR:Could not create file $l_test_name.conf! $!\n";
    
  print CONF_FILE "//ENV
--#WORK /platform/lib     -- library path relative to \$DEV_PATH
#SIM ModelSIM
-- #SIM NSIM
-- #VER Onespin
-- #SYN FPGA Xilinx
-- #SYN Chip


//FILES
#L work             -- working library
#C vcom             -- general compiling command
#P -explicit -93    -- general compiling parameter

\n";

  foreach( @all_files ){ print CONF_FILE "$_\n"; }

  print CONF_FILE "

//SIMULATOR
#S vsim
#P -t ns -novopt

#T top
#R -all

--//SCRIPTS

--//VERIFICATION

--//SYNTHESIS

//SIGNALS
#Z 0 100    -- time points between wave windows should be open
#R ns       -- wave resolution
#N 1        -- cut paths from signal names

//END
";
  close CONF_FILE;
  
  
#____ ___  ___     ____ ___ ____ _ _  _ ____ 
#|__| |  \ |  \    [__   |  |__/ | |\ | | __ 
#|  | |__/ |__/    ___]  |  |  \ | | \| |__] 
                                            
  print "create_design.pl -a $l_test_name $pwd_path";
  
} # print_default_conf

#######################################################################################################################
#   _____ ______ _______    ______ _   ___      __
#  / ____|  ____|__   __|  |  ____| \ | \ \    / /
# | |  __| |__     | |     | |__  |  \| |\ \  / / 
# | | |_ |  __|    | |     |  __| | . ` | \ \/ /  
# | |__| | |____   | |     | |____| |\  |  \  /   
#  \_____|______|  |_|     |______|_| \_|   \/    
sub get_env{

  #
  # KEY WORDS
  #
  local $ENV_KEYWORD      = "ENV";              # key word for environment specification

  local $WORK_FLAG        = "WORK";             # compilation   information flag
  local $SIM_FLAG         = "SIM";              # simulation    information flag
  local $VER_FLAG         = "VER";              # verification  information flag
  local $SYN_FLAG         = "SYN";              # synthesis     information flag

  #
  # parsing
  #
  local $env_flag         = 0;                  # environment content flag

  # ____ ____ _  _ ____    ____ _ _    ____ 
  # |    |  | |\ | |___    |___ | |    |___ 
  #.|___ |__| | \| |       |    | |___ |___ 
  #
  # open .conf file
  # search for create information
  #
  open( IN_CONF_FILE, "<", $test_parameter{conf_file} ) 
    or die "ERROR: cannot open $test_parameter{conf_file} file! $!\n";
    
  while(<IN_CONF_FILE>){
    ##################### KEY WORD PARSING ########################################
        if( /^\s*$/  ){                                                           # empty line
    }elsif( /^\s*--/ ){                                                           # comment line
    }elsif( /^\s*\/\/$ENV_KEYWORD/){                                              # creation specification
      $env_flag      = 1;
    
    }elsif( /^\s*\/\/\w+/      ){                                                 # other keyword
      $env_flag      = 0;
      last;
    }
    ##################### CONTENT #################################################
    else{
      if( $env_flag ){
            if( /^\s*\#$WORK_FLAG\s+(.+)/ ){
              $test_parameter{sim_path} = $dev_path.$1;
              $compile_only              = 1;
        }elsif( /^\s*\#$SIM_FLAG\s+(\w+)/ ){
              $test_parameter{sim_path} = "$work_path/$test_name/simulation/$1";
        }elsif( /^\s*\#$VER_FLAG\s+(\w+)/ ){
              $test_parameter{ver_path} = "$work_path/$test_name/verification/$1";
        }elsif( /^\s*\#$SYN_FLAG\s+(\w+)\s*(\w*)/ ){
            if( defined $2 ){
              $test_parameter{syn_path} = "$work_path/$test_name/synthesis/$1/$2";
            }else{
              $test_parameter{syn_path} = "$work_path/$test_name/synthesis/$1";
            }
        }else{}
      }else{}
    }
  }

  close IN_CONF_FILE;
} # sub get_env

###################################################################################################
######## ##     ## ########  ######  ##     ## ######## ######## 
##        ##   ##  ##       ##    ## ##     ##    ##    ##       
##         ## ##   ##       ##       ##     ##    ##    ##       
######      ###    ######   ##       ##     ##    ##    ######   
##         ## ##   ##       ##       ##     ##    ##    ##       
##        ##   ##  ##       ##    ## ##     ##    ##    ##       
######## ##     ## ########  ######   #######     ##    ######## 
###################################################################################################
######################################################################################   
#  _____ _____  ______       _______ ______   ______ _____ _      ______  _____ 
# / ____|  __ \|  ____|   /\|__   __|  ____| |  ____|_   _| |    |  ____|/ ____|
#| |    | |__) | |__     /  \  | |  | |__    | |__    | | | |    | |__  | (___  
#| |    |  _  /|  __|   / /\ \ | |  |  __|   |  __|   | | | |    |  __|  \___ \ 
#| |____| | \ \| |____ / ____ \| |  | |____  | |     _| |_| |____| |____ ____) |
# \_____|_|  \_\______/_/    \_\_|  |______| |_|    |_____|______|______|_____/ 
sub create_files{
  
  local $l_options      = "";

  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

    # ############## LIBRARY CREATION ##############################
    if( $compile_only ){
      # go to work directory
      chdir( $test_parameter{sim_path} )
        or die "ERROR: could not change to compilation directory! $!\n";

      # create links
      $l_options  = $test_parameter{conf_file};                    # .conf file
      $l_options .= " $test_parameter{src_path}";                  # source path
      $l_options .= " $test_parameter{sim_path}";                  # simulation path
      $l_options .= " link";                                       # link level

      system("conf2arg.pl $l_options");

      # create simulation file
      $l_options  = $test_parameter{conf_file};                    # .conf file
      $l_options .= " $test_parameter{src_path}";                  # source path
      $l_options .= " $test_parameter{sim_path}";                  # simulation path
      $l_options .= " $test_parameter{test_name}";                 # name of test
      $l_options .= " 0";                                          #
      $l_options .= " 1>simulate_$test_parameter{test_name}.tcl";  # output script

      system("conf2sim.pl $l_options" );

    # ############### TEST CASE ####################################
    }else{
      
      # create test case environment
      unless( -d $test_parameter{test_path}                 ){ mkdir $test_parameter{test_path}; }
      unless( -d "$test_parameter{test_path}/simulation"    ){ mkdir "$test_parameter{test_path}/simulation"; }
      unless( -d  $test_parameter{sim_path}                 ){ mkdir  $test_parameter{sim_path};  }

      # go to work directory
      chdir( $test_parameter{sim_path} ) 
        or die "ERROR: could not change to simulation directory! $!\n";
  
      # create links
      $l_options  = $test_parameter{conf_file};                    # .conf file
      $l_options .= " $test_parameter{src_path}";                  # source path
      $l_options .= " $test_parameter{sim_path}";                  # simulation path
      $l_options .= " link";                                       # link level

      system("conf2arg.pl $l_options");

      # create simulation file
      $l_options  = $test_parameter{conf_file};                    # .conf file
      $l_options .= " $test_parameter{src_path}";                  # source path
      $l_options .= " $test_parameter{sim_path}";                  # simulation path
      $l_options .= " $test_parameter{test_name}";                 # name of test
      $l_options .= " 0";                                          #
      $l_options .= " 1>simulate_$test_parameter{test_name}.tcl";  # output script

      system("conf2sim.pl $l_options" );

      $l_options   = "'log \\'";
      $l_options  .= " 1>log_$test_parameter{test_name}.do";
      system("echo $l_options" );                                 # prepare log file

      # create wave file
      $l_options  = "$test_parameter{conf_file}";                 # .conf file
      $l_options .= " $test_parameter{src_path}";                 # source path
      $l_options .= " 1>wave_$test_parameter{test_name}.do";      # output wave file
      $l_options .= " 2>>log_$test_parameter{test_name}.do";      # output log file

      system("conf2wave.pl $l_options" );
    }

  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

    # create test case environment
    unless( -d $test_parameter{test_path}                 ){ mkdir $test_parameter{test_path}; }
    unless( -d "$test_parameter{test_path}/verification"  ){ mkdir "$test_parameter{test_path}/verification"; }
    unless( -d  $test_parameter{ver_path}                 ){ mkdir  $test_parameter{ver_path};  }

    # go to working directory
    chdir( $test_parameter{ver_path} )
      or die "ERROR:Could not change to verification directory! $!\n";

    # create links
    $l_options  = $test_parameter{conf_file};                    # .conf file
    $l_options .= " $test_parameter{src_path}";                  # source path
    $l_options .= " $test_parameter{ver_path}";                  # verification path
    $l_options .= " link";                                       # link level

    system("conf2arg.pl $l_options");;

    # create verification script file
    $l_options  = "$test_parameter{conf_file}";                 # .conf file
    $l_options .= " $test_parameter{src_path}";                 # source path
    $l_options .= " $test_parameter{ver_path}";                 # verification path
    $l_options .= " $test_parameter{test_name}";                # name of the test
    $l_options .= " 1>ver_$test_parameter{test_name}.tcl";      # output script

    system( "conf2ver.pl $l_options" );

  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){

    # create test case environment
    unless( -d $test_parameter{test_path}                   ){ mkdir $test_parameter{test_path}; }
    unless( -d "$test_parameter{test_path}/synthesis"       ){ mkdir "$test_parameter{test_path}/synthesis";      }
    unless( -d "$test_parameter{test_path}/synthesis/FPGA"  ){ mkdir "$test_parameter{test_path}/synthesis/FPGA"; }
    unless( -d "$test_parameter{test_path}/synthesis/ASIC"  ){ mkdir "$test_parameter{test_path}/synthesis/ASIC"; }
    unless( -d  $test_parameter{syn_path}                   ){ mkdir  $test_parameter{syn_path};  }

    unless( -d  "$test_parameter{syn_path}/reports"         ){ mkdir  "$test_parameter{syn_path}/reports";        }
    unless( -d  "$test_parameter{syn_path}/results"         ){ mkdir  "$test_parameter{syn_path}/results";        }
    unless( -d  "$test_parameter{syn_path}/netlist"         ){ mkdir  "$test_parameter{syn_path}/netlist";        }

    # go to working directory
    chdir( $test_parameter{syn_path} )
      or die "ERROR:Could not change to synthesis directory! $!\n";

    # create links
    $l_options  = $test_parameter{conf_file};                    # .conf file
    $l_options .= " $test_parameter{src_path}";                  # source path
    $l_options .= " $test_parameter{syn_path}";                  # synthesis path
    $l_options .= " link";                                       # link level

    system("conf2arg.pl $l_options");

    # create synthesis script files
    $l_options  = "$test_parameter{conf_file}";                 # .conf file
    $l_options .= " $test_parameter{src_path}";                 # source path
    $l_options .= " $test_parameter{syn_path}";                 # synthesis path
    $l_options .= " $test_parameter{test_name}";                # name of the test

    system( "conf2syn.pl $l_options" );

  }else{}
  
} # create_files

######################################################################################   
#  _____ ____  __  __ _____ _____ _      ______    _____  ____  _    _ _____   _____ ______  _____ 
# / ____/ __ \|  \/  |  __ \_   _| |    |  ____|  / ____|/ __ \| |  | |  __ \ / ____|  ____|/ ____|
#| |   | |  | | \  / | |__) || | | |    | |__    | (___ | |  | | |  | | |__) | |    | |__  | (___  
#| |   | |  | | |\/| |  ___/ | | | |    |  __|    \___ \| |  | | |  | |  _  /| |    |  __|  \___ \ 
#| |___| |__| | |  | | |    _| |_| |____| |____   ____) | |__| | |__| | | \ \| |____| |____ ____) |
# \_____\____/|_|  |_|_|   |_____|______|______| |_____/ \____/ \____/|_|  \_\\_____|______|_____/ 
                                                                                                  
sub compile_src{

  local $l_options      = "";
  
  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

    # go to work directory
    chdir( $test_parameter{sim_path} ) 
      or die "ERROR: could not change to simulation directory! $!\n";
    
    system( "vsim -c -do \"source simulate_$test_parameter{test_name}.tcl;c;q\"");
  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

    # go to work directory
    chdir( $test_parameter{ver_path} )
      or die "ERROR: could not change to verfication directory! $!\n";
    
    system( "onespin --gui=no -i ver_$test_parameter{test_name}.tcl");
  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){

    # go to work directory
    chdir( $test_parameter{syn_path} )
      or die "ERROR: could not change to synthesis directory! $!\n";

    $l_options        = "-batch";                                                   # command line mode
    $l_options       .= " -runall";                                                 # create netlist
    $l_options       .= " -log /dev/zero";                                          # remove std output
    $l_options       .= " $test_parameter{test_name}_netlist.tcl";                  # project file

    system( "synplify_pro $l_options" );

    # if( system( "synplify_pro $l_options") ){
    #   system( "cat reports/$test_parameter{test_name}.srr" );
    # }else{
    #   system( "cp netlist/$test_parameter{test_name}.edf results/$test_parameter{test_name}.edf" );
    # }

  }else{}
}

######################################################################################   
#  _____ _____  ______       _______ ______    ______ _               ____  
# / ____|  __ \|  ____|   /\|__   __|  ____|  |  ____| |        /\   |  _ \ 
#| |    | |__) | |__     /  \  | |  | |__     | |__  | |       /  \  | |_) |
#| |    |  _  /|  __|   / /\ \ | |  |  __|    |  __| | |      / /\ \ |  _ < 
#| |____| | \ \| |____ / ____ \| |  | |____   | |____| |____ / ____ \| |_) |
# \_____|_|  \_\______/_/    \_\_|  |______|  |______|______/_/    \_\____/ 
#
#
#
sub create_elab{

  local $l_options      = "";

  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

  $l_options      = "$test_parameter{conf_file}";           # .conf file
  $l_options     .= " $test_parameter{src_path}";           # source files path
  $l_options     .= " $test_parameter{sim_path}";           # simulation path
  $l_options     .= " $test_parameter{test_name}";          # test name
  $l_options     .= " 1";                                   # create elab

  # go to work directory
  chdir( $test_parameter{sim_path} ) 
    or die "ERROR: could not change to simulation directory! $!\n";

  system( "conf2sim.pl $l_options" );

  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){

    # go to work directory
    chdir( $test_parameter{syn_path} )
      or die "ERROR: could not change to synthesis directory! $!\n";

    $l_options        = "-batch";                                                   # command line mode
    $l_options       .= " -log /dev/zero";                                          # remove std output
    $l_options       .= " $test_parameter{test_name}_syn.prj";                      # project file

    if( system( "synplify_pro $l_options") ){
      system( "cat netlist/$test_parameter{test_name}.srr" );
    }

    # link report file
    unless( -e "reports/synthesis_$test_parameter{test_name}.log" ){
      system( "ln -sf $test_parameter{syn_path}/netlist/$test_parameter{test_name}.srr 
               reports/synthesis_$test_parameter{test_name}.log" );
    }

    # copy output file
    system( "cp netlist/$test_parameter{test_name}.edn results/$test_parameter{test_name}.edn" );
    

  }else{}
}

######################################################################################
#   _______     ___   _ _______ _    _ ______  _____ _____  _____ 
#  / ____\ \   / / \ | |__   __| |  | |  ____|/ ____|_   _|/ ____|
# | (___  \ \_/ /|  \| |  | |  | |__| | |__  | (___   | | | (___  
#  \___ \  \   / | . ` |  | |  |  __  |  __|  \___ \  | |  \___ \ 
#  ____) |  | |  | |\  |  | |  | |  | | |____ ____) |_| |_ ____) |
# |_____/   |_|  |_| \_|  |_|  |_|  |_|______|_____/|_____|_____/ 
sub start_synthesis{
  local $l_options      = "";

  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

  $l_options      = "$test_parameter{conf_file}";           # .conf file
  $l_options     .= " $test_parameter{src_path}";           # source files path
  $l_options     .= " $test_parameter{sim_path}";           # simulation path
  $l_options     .= " $test_parameter{test_name}";          # test name
  $l_options     .= " 4";                                   # open log file

  # go to work directory
  chdir( $test_parameter{sim_path} ) 
    or die "ERROR: could not change to simulation directory! $!\n";

  system( "conf2sim.pl $l_options" );

    # print "WARNING:This level doesnot exists for simulation!\n";
    # print_help();

  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){


  }else{}
}
######################################################################################
#  ____  _____  ______ _   _    ______ _               ____  
# / __ \|  __ \|  ____| \ | |  |  ____| |        /\   |  _ \ 
#| |  | | |__) | |__  |  \| |  | |__  | |       /  \  | |_) |
#| |  | |  ___/|  __| | . ` |  |  __| | |      / /\ \ |  _ < 
#| |__| | |    | |____| |\  |  | |____| |____ / ____ \| |_) |
# \____/|_|    |______|_| \_|  |______|______/_/    \_\____/ 
#                                                            
#
#
sub open_elab{

  local $l_options      = "";

  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

  $l_options      = "$test_parameter{conf_file}";           # .conf file
  $l_options     .= " $test_parameter{src_path}";           # source files path
  $l_options     .= " $test_parameter{sim_path}";           # simulation path
  $l_options     .= " $test_parameter{test_name}";          # test name
  $l_options     .= " 2";                                   # open elab

  # go to work directory
  chdir( $test_parameter{sim_path} ) 
    or die "ERROR: could not change to simulation directory! $!\n";

  system( "conf2sim.pl $l_options" );

  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){


  }else{}

}

######################################################################################   
# _____  ______  _____ _______ ____  _____  ______ 
#|  __ \|  ____|/ ____|__   __/ __ \|  __ \|  ____|
#| |__) | |__  | (___    | | | |  | | |__) | |__   
#|  _  /|  __|  \___ \   | | | |  | |  _  /|  __|  
#| | \ \| |____ ____) |  | | | |__| | | \ \| |____ 
#|_|  \_\______|_____/   |_|  \____/|_|  \_\______|
sub restore{

  local $l_options      = "";

  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

  $l_options      = "$test_parameter{conf_file}";           # .conf file
  $l_options     .= " $test_parameter{src_path}";           # source files path
  $l_options     .= " $test_parameter{sim_path}";           # simulation path
  $l_options     .= " $test_parameter{test_name}";          # test name
  $l_options     .= " 3";                                   # restore checkpoint

  # go to work directory
  chdir( $test_parameter{sim_path} ) 
    or die "ERROR: could not change to simulation directory! $!\n";

  system( "conf2sim.pl $l_options" );

  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){


  }else{}
}


######################################################################################   
#  _____ _______       _____ _______   ____       _______ _____ _    _ 
# / ____|__   __|/\   |  __ \__   __| |  _ \   /\|__   __/ ____| |  | |
#| (___    | |  /  \  | |__) | | |    | |_) | /  \  | | | |    | |__| |
# \___ \   | | / /\ \ |  _  /  | |    |  _ < / /\ \ | | | |    |  __  |
# ____) |  | |/ ____ \| | \ \  | |    | |_) / ____ \| | | |____| |  | |
#|_____/   |_/_/    \_\_|  \_\ |_|    |____/_/    \_\_|  \_____|_|  |_|
sub start_batch{

  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

  # go to work directory
  chdir( $test_parameter{sim_path} ) 
    or die "ERROR: could not change to simulation directory! $!\n";
  
  system( "vsim -c -do \"source simulate_$test_parameter{test_name}.tcl;batch\" ");

  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){

    print "WARNING:There is no batch mode for synthesis, use -s for bit file creation!\n";

  }else{}
}

######################################################################################   
#  _____ _______       _____ _______    _____ _    _ _____ 
# / ____|__   __|/\   |  __ \__   __|  / ____| |  | |_   _|
#| (___    | |  /  \  | |__) | | |    | |  __| |  | | | |  
# \___ \   | | / /\ \ |  _  /  | |    | | |_ | |  | | | |  
# ____) |  | |/ ____ \| | \ \  | |    | |__| | |__| |_| |_ 
#|_____/   |_/_/    \_\_|  \_\ |_|     \_____|\____/|_____|
sub start_gui{

  # ____ _ _  _ _  _ _    ____ ___ _ ____ _  _ 
  # [__  | |\/| |  | |    |__|  |  | |  | |\ | 
  # ___] | |  | |__| |___ |  |  |  | |__| | \|                                            
      if( $global_option eq "sim" ){

    # go to work directory
  chdir( $test_parameter{sim_path} ) 
    or die "ERROR: could not change to simulation directory! $!\n";
    
  system( "vsim -do \"source simulate_$test_parameter{test_name}.tcl;gui\" ");
  # _  _ ____ ____ _ ____ _ ____ ____ ___ _ ____ _  _ 
  # |  | |___ |__/ | |___ | |    |__|  |  | |  | |\ | 
  #  \/  |___ |  \ | |    | |___ |  |  |  | |__| | \| 
  }elsif( $global_option eq "ver" ){

    # go to work directory
    chdir( $test_parameter{ver_path} )
      or die "ERROR: could not change to verfication directory! $!\n";
    
    system( "onespin -i ver_$test_parameter{test_name}.tcl");
  # ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
  # [__   \_/  |\ |  |  |__| |___ [__  | [__  
  # ___]   |   | \|  |  |  | |___ ___] | ___] 
  }elsif( $global_option eq "syn" ){

        # go to work directory
    chdir( $test_parameter{syn_path} )
      or die "ERROR: could not change to synthesis directory! $!\n";

    system( "synplify_pro $test_parameter{test_name}_netlist.tcl") 

  }else{}  
}
