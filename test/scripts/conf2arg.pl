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
# .conf file and path
#
my $conf_file         = shift;                    # name of .conf file
my $src_path          = shift;                    # path to source files
my $work_path         = shift;                    # path to working directory
my $level             = shift;                    # output specification:
                                                  #  sim - simulation 
                                                  #  ver - verification
                                                  #  syn - synthesis
                                                  #  link- link files only
#
# key words
#
my $FILES             = "FILES";                  # key word with files information
my $INCL_FLAG         = "INCL";                   # extern file include

my $L_FLAG            = "L";                      # library information specially for each file
my $C_FLAG            = "C";                      # compiler information specially for each file
my $P_FLAG            = "P";                      # parameter information specially for each file
my $T_FLAG            = "T";                      # top entity flag     - synthesis only
my $TB_FLAG           = "TB";                     # test bench flag     - verification only
my $SIM_FLAG          = "SIM";                    # simulation file     - verification only
my $SYN_FLAG          = "SYN";                    # synthesis file      - synthesis only
my $GLOB_FLAG         = "GLOB";                   # path to file is global - all
my $LINK_FLAG         = "LINK";                   # files to link flag  - all
my $LINK_GLOB         = "LINK_GLOB";              # file path is global - all

my $VAR_FLAG          = "VAR";                    # user defined variable

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
my $group_comment     = 0;                        # group comment disabled initially
my $files_flag        = 0;                        # list of files
my $line              = "";                       # current content line
my $print_line        = 1;                        # print line flag

my $src_name          = "";                       # name of source file
my $dest_name         = "";                       # name of destination link file

#
# content information
#
my @files             = ();                       # array of file information

#
# include files parsing
#
my $cur_filename      = "";                       # filename of file to include

#
# compiler information
#
my $all_comp_cmd      = " ";                      # general compiler command
my $all_com_par       = " ";                      # general compiler options
my $all_library       = " ";                      # general library  options
my $comp_cmd          = "";                       # current compiler command
my $comp_par          = "";                       # current compiler options
my $library           = "";                       # current library

#
# special files
#
my $prefix            = "";                       # relative path to files
my %link_files        = ();                       # hash table of files to be linked
my %link_glob         = ();                       # hash table of global file with global paths
my $top_module        = "";                       # top module file
my $tb_file           = "";                       # test bench file

#
# user defined variables
#
my %user_vars         = ();                       # user defined variables
my $cur_var           = "";                       # current variable

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
unless( defined $conf_file ){ print STDERR "ERROR: no .conf file defined!\n"; exit 1; }
unless( defined $src_path  ){ print STDERR "ERROR: no source path defined!\n"; exit 1; }
unless( defined $work_path ){ print STDERR "ERROR: no working path defined!\n"; exit 1; }
unless( defined $level     ){ $level = "sim"; }

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
  }elsif( /^\s*\/\/$FILES/   ){                                                 # files information
    $files_flag     = 1;
  }elsif( /^\s*\/\/\w+/      ){                                                 # other keyword
    $files_flag     = 0;
  }
  ##################### CONTENT #################################################
  else{
    if( $files_flag ){
      $line = $_;
      $line =~ s/\r\n|\n|\r//;                                                  # cut newline
      # ############ FILE INCLUDING ###############
      if( $line =~ /^\s*\#$INCL_FLAG\s+(.*)/ ){
        $cur_filename = $1;
        open( ADD_FILE, "<", "$src_path/link/$cur_filename" )
          or next;
          
        while(<ADD_FILE>){
              if( /^\s*$/  ){                                                   # empty line
          }elsif( /^\s*--/ ){                                                   # comment line
          }else{
            $line = $_;
            $line =~ s/\r\n|\n|\r//;
            push( @files, $line );
          }
        }
        
        close ADD_FILE;
      }else{
        push( @files, $line );
      }
    }else{}
  }
}
    
close CONF_FILE;

# _    _ _  _ _  _ 
# |    | |\ | |_/   
# |___ | | \| | \_  
#
# extract link and variables information
#
if( $level eq "link" ){
  if( @files ){
  foreach( @files ){
    #
    # ############ FILES TO LINK ################################################
    #
    if( /^\#$LINK_FLAG\s+(.+)\s+(.+)/ ){                                        # parse for files to link
      $link_files{$1} = $2;                                                     # add them to according hash table
    #
    # ############ FILES TO LINK WITH GLOBAL PATH ###############################
    #
    }elsif( /^\#$LINK_GLOB\s+(.+)\s+(.+)/ ){                                    # parse for files to link
      $link_glob{$1} = $2;                                                      # add them to according hash table
    #
    # ############ USER VARIABLES ###############################################
    #
    }elsif( /^\#$VAR_FLAG\s+(\w+)\s+(.+)/ ){                                    # parse for variables
      $user_vars{$1} = $2;
    }else{}
  }
  }

  #
  # link files
  #
  link_all_files();

  exit 0;
}

#____ ____ _  _ ___  _ _    ____ ____ 
#|    |  | |\/| |__] | |    |___ |__/ 
#|___ |__| |  | |    | |___ |___ |  \ 
#
# extract general compiler information from the compiler content
#
if( @files ){                                                                   # there is content information
  foreach( @files ){
        if( /^\s*\#$C_FLAG\s+(\w+)/ ){                                          # compiler flag detected
          $all_comp_cmd   = $1;
    }elsif( /^\s*\#$P_FLAG\s+(.+)$/ ){                                          # options detected
          $all_comp_par   = $1;
    }elsif( /^\s*\#$L_FLAG\s+(\w+)$/ ){                                         # library detected
          $all_library    = $1;
    }else{}
  }
}

# _    _ ___  ____ ____ ____ _   _ 
# |    | |__] |__/ |__| |__/  \_/  
# |___ | |__] |  \ |  | |  \   |   
#
# create library if not exists
#
if( $level eq "sim"){
  unless( -d $all_library ){ if( system("vlib", $all_library) != 0 ){ exit 1; }}
}

#____ _ _    ____ ____ 
#|___ | |    |___ [__  
#|    | |___ |___ ___] 
#
# parse files information and create output file
#
print "set src_path $src_path\n";                                               # define source path

if( @files ){                                                                   # there is content information
  foreach( @files ){
    $line = $_;                                                                 # get line
    $print_line = 1;                                                            # DEFAULT: print line
    
    $comp_cmd   = $all_comp_cmd;                                                # DEFAULT: general compiler command
    $comp_par   = $all_comp_par;                                                # DEFAULT: general compiler options
    $library    = $all_library;                                                 # DEFAULT: general working library
    $prefix     = "\$src_path";                                                 # DEFAULT: file path is relative

    #
    # ############ ALL: GENERAL COMPILER INFORMATION ############################
    #
    if( ($line =~ /^\s*\#$C_FLAG/) || ($line =~ /^\s*\#$P_FLAG/) || ($line =~ /^\s*\#$L_FLAG/)){
      next;
    }

    #
    # ############ ALL: GLOBAL PATH #############################################
    #
    if( $line =~ /^\s*\#$GLOB_FLAG\s+/ ){                                       # parse for global flag
      $prefix   = "";                                                           # path is global, there is no prefix
      $line =~ s/^\s*\#$GLOB_FLAG\s+//g;                                        # cut this flag out
    }
    
    #
    # ############ SIM: COMPILER INFORMATION ####################################
    #
    if( $line =~ /\#$C_FLAG\s+(\w+)/ ){                                         # parse for special compiler command
      $comp_cmd = $1;                                                           # extract special compiler command
      $line =~ s/\#$C_FLAG\s+(\w+)//g;                                          # cut this information out
    }
    
    #
    # ############ SIM: COMPILER PARAMETER INFORMATION ##########################
    #
    if( $line =~ /\#$P_FLAG\s+(.+)/ ){                                          # parse for special compiler options
      $comp_par = $1;                                                           # extract special compiler options
      $line =~ s/\#$P_FLAG\s+(.+)//g;                                           # cut this information out
    }

    #
    # ############ SIM: LIBRARY INFORMATION #####################################
    #
    if( $line =~ /\#$L_FLAG\s+(\w+)/ ){                                         # parse for special library
      $library  = $1;                                                           # extract special library name
      $line     =~ s/\#$L_FLAG\s+(\w+)//g;                                      # cut this information out
      if( $level eq "sim" ){
        unless( -d $library ){ 
          if( system("vlib", $library) != 0 ){ exit 1; }}                       # create this library if not exists
      }
    }

    #
    # ############ SYN: FILES FOR SYNTHESIS #####################################
    #
    if( $line =~ /\#$SYN_FLAG\s+(.+)/ ){                                        # parse for synthesis files
      if( $level ne "syn" ){ next; }                                            # continue only for synthesis
      $line =~ s/\#$SYN_FLAG\s+//g                                              # cut flag out
    }

    #
    # ############ SYN: TOP MODULE #############################################
    #
    if( $line =~ /\#$T_FLAG\s+(.+)/ ){                                          # parse for top module
      ($top_module) = $1 =~ /(\w+)\.v/;                                         # extract top module
      $line =~ s/\#$T_FLAG\s+//g;                                               # cut flag out
    }

    #
    # ############ SIM: TESTBENCH ##############################################
    #
    if( $line =~ /^\#$TB_FLAG\s+(.+)/ ){                                        # parse for test bench
      $tb_file = $1;                                                            # test bench file
      if( $level ne "sim" ){ $print_line = 0; }                                 # only for simulation
      $line =~ s/\#$TB_FLAG\s+//g;                                              # cut flag out
    }

    #
    # ############ SIM: SIMULATION ONLY FILES ##################################
    #
    if( $line =~ /^\#$SIM_FLAG\s+/ ){                                           # parse for simulation only files
      if( $level ne "sim" ){ $print_line = 0; }                                 # only for simulation
      $line =~ s/\#$SIM_FLAG\s+//g;                                             # cut flag out
    }

    #
    # ############ ALL: FILES TO LINK ##########################################
    #
    if( $line =~ /^\#$LINK_FLAG\s+(.+)\s+(.+)/ ){                               # parse for files to link
      $print_line = 0;                                                          # switch print off, files should only be linked
    }

    #
    # ############ ALL: FILES TO LINK WITH GLOBAL PATH #########################
    #
    if( $line =~ /^\#$LINK_GLOB\s+(.+)\s+(.+)/ ){                               # parse for files to link
      $print_line = 0;                                                          # switch print off, files should only be linked
    }

    #
    # ############ ALL: USER VARIABLES #########################################
    #
    if( $line =~ /^\#$VAR_FLAG\s+(\w+)\s+(.+)/ ){                                # parse for variables
      $user_vars{$1} = $2;
      $print_line = 0;
    }
    
    #
    # ############ ALL: OUTPUT #################################################
    #
    if( $print_line ){                                                          # only print enable lines

      ############### VARIABLES ######################
      while( $line =~ /\$\{(\w+)\}/ ){                                          # search for variables
        $cur_var = $1;
        if( exists($user_vars{$cur_var}) ){
          $line =~ s/\$\{$cur_var\}/$user_vars{$cur_var}/g;
        }
      }

      ############### SIMULATION #####################
      if( $level eq "sim" ){
        print "$comp_cmd -work $library $comp_par $prefix/$line\n";             # compiler options and files

      ############### VERIFICATION #####################
      }elsif( $level eq "ver" ){
        print "$comp_cmd -library $library $comp_par $prefix/$line\n";          # compiler options and files

      ############### SYNTHESIS #####################
      }elsif( $level eq "syn" ){
        print "add_file -lib $library $prefix/$line\n";                         # add file and specify library

      }else{}
    }
    
  }
}else{
  print STDERR "ERROR: No files defined, nothing to do!\n";
  exit 1;
}

# ___ ____ ___     _  _ ____ ___  _  _ _    ____ 
#  |  |  | |__]    |\/| |  | |  \ |  | |    |___ 
#  |  |__| |       |  | |__| |__/ |__| |___ |___ 
#
# set top module for synthesis
#
if( $level eq "syn" ){
  print "set_option -top_module $all_library.$top_module\n";
}

exit 0;

sub link_all_files{
# _    _ _  _ _  _ 
# |    | |\ | |_/  
# |___ | | \| | \_ 
#
# link files if there are some
#
if( %link_files ){

  # go to work directory
  chdir( $work_path ) 
    or die "ERROR: could not change to working directory! $!\n";

  while(($src_name, $dest_name) = each(%link_files)){
    while( $src_name =~ /\$\{(\w+)\}/ ){
      if( exists($user_vars{$1}) ){
        $cur_var = $1;
        $src_name =~ s/\$\{$cur_var\}/$user_vars{$cur_var}/g;
      }else{
        print STDERR "ERROR: no such variable $1!\n";
        exit 1;
      }
    }

    system( "ln -sf $src_path/$src_name $dest_name" );
    
  }
}

if( %link_glob ){

  # go to work directory
  chdir( $work_path ) 
    or die "ERROR: could not change to working directory! $!\n";

  while(($src_name, $dest_name) = each(%link_glob)){
    while( $src_name =~ /\$\{(\w+)\}/ ){
      if( exists($user_vars{$1}) ){
        $cur_var = $1;
        $src_name =~ s/\$\{$cur_var\}/$user_vars{$cur_var}/g;
      }else{
        print STDERR "ERROR: no such variable $1!\n";
        exit 1;
      }
    }
    
    system( "ln -sf $src_name $dest_name" );
    
  }
}
}