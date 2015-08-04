#!/usr/bin/perl -w

# revision history
# 04/2014  AS  1.0    initial

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

my $T_FLAG            = "T";                      # technology
my $D_FLAG            = "D";                      # device
my $P_FLAG            = "P";                      # package
my $S_FLAG            = "S";                      # speed

my $F_FLAG            = "F";                      # frequency

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
my $syn_flag          = 0;                        # verification content found

#
# content information
#
my @syn_lines        = ();                        # synthesis information lines
my %syn_info         = ();                        # synthesis information

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
      push( @syn_lines,    $_ );
    }else{}
  }
}
    
close CONF_FILE;

# ____ _   _ _  _ ___ _  _ ____ ____ _ ____ 
# [__   \_/  |\ |  |  |__| |___ [__  | [__  
# ___]   |   | \|  |  |  | |___ ___] | ___] 
#
# synthesis information
#
if( @syn_lines ){
  foreach( @syn_lines ){
        if( /^\s*\#$T_FLAG\s+(.+)$/ ){
      $syn_info{technology} = $1;
    }elsif( /^\s*\#$D_FLAG\s+(.+)$/ ){
      $syn_info{device} = $1;
    }elsif( /^\s*\#$P_FLAG\s+(.+)$/ ){
      $syn_info{package} = $1;
    }elsif( /^\s*\#$S_FLAG\s+(.+)$/ ){
      $syn_info{speed} = $1;
    }elsif( /^\s*\#$F_FLAG\s+(.+)$/ ){
      $syn_info{freq} = $1;
    }else{}
  }
}

# ____ _  _ ___ ___  _  _ ___ 
# |  | |  |  |  |__] |  |  |  
# |__| |__|  |  |    |__|  |  
#
# project content
#
# source files
system("conf2arg.pl $conf_file $src_path $work_path syn");                      # files information
print "\n";

# implementation attributes
print "impl -add netlist -type fpga\n";
print "set_option -num_critical_paths 5 \n";
print "set_option -project_relative_includes 1 \n";
print "\n";

# device options
print "set_option -technology   $syn_info{technology}\n";
print "set_option -part         $syn_info{device}\n";
print "set_option -package      $syn_info{package}\n";
print "set_option -speed_grade  $syn_info{speed}\n";
print "\n";

# compilation/mapping options
print "set_option -frequency    $syn_info{freq}\n";
print "set_option -symbolic_fsm_compiler 1\n";
print "set_option -resource_sharing 1\n";
print "\n";

# place and route options
print "\n";

# output
print "project -result_file \"$name.edn\"\n";
print "\n";

# start command
print "impl -active \"netlist\"\n";
print "\n";
