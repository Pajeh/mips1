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
# .conf file
#
my $conf_file         = shift;                    # name of .conf file
my $src_path          = shift;                    # path to source files

#
# key words
#
my $SIGNALS           = "SIGNALS";                # key word for signals

my $P_FLAG            = "P";                      # flag for new pane
my $D_FLAG            = "D";                      # flag for devider
my $G_FLAG            = "G";                      # flag for group
my $U_FLAG            = "U";                      # flag for sub-module path
my $N_FLAG            = "N";                      # flag for new name of signal

my $R_FLAG            = "R";                      # flag for resolution
my $Z_FLAG            = "Z";                      # flag for zoom

my $V_FLAG            = "V";                      # user variable
my $INCL_FLAG         = "INCL";                   # extern file include

#
# output 
#
my $OUTPUT_HEADER     = "onerror {resume}
quietly WaveActivateNextPane {} 0\n";

my $OUTPUT_TRAILER    = "configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0\n";

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
my $signals_flag      = 0;                        # signals content found

#
# content information
#
my @signals           = ();                       # array for signals information

#
# include files parsing
#
my $cur_filename      = "";                       # filename of file to include

#
# signals parsing
#
my $line              = "";                       # current signal line

my $path              = "";                       # path information
my $group             = "";                       # current group information
my $group_expand      = "";                       # create expanded group

my $radix             = "";                       # radix information
my $label             = "";                       # label information
my $no_path           = 0;                        # path is enabled

#
# wave parsing
#
my @zoom              = ("0", "100");             # start and end time of showed wave window
my @cursors           = ("2", "98");              # cursors position
my $resolution        = "ns";                     # default resolution information

#
# user variables
#
my %user_vars         = ();                       # user variables
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
unless( defined $conf_file ){ print STDERR "ERROR: no .conf file defined!\n"; exit 1;  }
unless( defined $src_path  ){ print STDERR "ERROR: no source path defined!\n"; exit 1; }

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
  }elsif( /^\s*\/\/$SIGNALS/){                                                  # signals information
    $signals_flag     = 1;
  }elsif( /^\s*\/\/\w+/      ){                                                 # other keyword
    $signals_flag     = 0;
  }
  ##################### CONTENT #################################################
  else{
    if( $signals_flag ){
      $line = $_;
      $line =~ s/\r\n|\n|\r//;                                                  # cut newline
      # ############ FILE INCLUDING ###############
      if( $line =~ /^\s*\#$INCL_FLAG\s+(.*)/ ){
        $cur_filename = $1;
        open( ADD_FILE, "<", "$src_path/wave/$cur_filename" )
          or next;
          
        while(<ADD_FILE>){
              if( /^\s*$/  ){                                                   # empty line
          }elsif( /^\s*--/ ){                                                   # comment line
          }else{
            $line = $_;
            $line =~ s/\r\n|\n|\r//;
            push( @signals, $line );
          }
        }
        
        close ADD_FILE;
      }else{
        push( @signals, $line );
      }
    }else{}
  }
}
    
close CONF_FILE;

#___  ____ ____ ____ ____    ____ _ ____ _  _ ____ _    ____ 
#|__] |__| |__/ [__  |___    [__  | | __ |\ | |__| |    [__  
#|    |  | |  \ ___] |___    ___] | |__] | \| |  | |___ ___] 
if( @signals ){
  print $OUTPUT_HEADER;
  foreach( @signals ){
  #################### COMMANDS ##################################################
        if( /^\s*\#$P_FLAG/ ){                                                    # new pane
          print "TreeUpdate [SetDefaultTree]\n";
          print "quietly WaveActivateNextPane\n";
    }elsif( /^\s*\#$Z_FLAG\s+(\d+)\s+(\d+)/ ){                                    # cursors positions
          $zoom[0]    = $1;   $cursors[0] = $zoom[0] + 2;
          $zoom[1]    = $2;   $cursors[1] = $zoom[1] - 2;
    }elsif( /^\s*\#$V_FLAG\s+(\w+)\s+(.+)/ ){                                     # user variable
          $user_vars{$1} = $2;
    }elsif( /^\s*\#$R_FLAG\s+(\w+)/ ){
          $resolution = $1;
    }elsif( /^\s*\#$D_FLAG\s+(.+)$/ ){                                            # devider
          print "add wave -noupdate -divider $1\n";
    }elsif( /^\s*\#$U_FLAG\s+(.+)$/ ){                                            # path
          $path         = $1;
    }elsif( /^\s*\#$N_FLAG\s+(\d)$/ ){                                            # path display
          $no_path = $1;
    }elsif( /^\s*\#$G_FLAG\s+(\w+)\s*(\w*)/ ){                                    # group start
          $group        = $1;
          if( (defined $2) && ($2 eq "E") ){ 
            $group_expand = "-expand"; }                                          # group is open on start
    }elsif( /^\s*\#\s*$/ ){                                                       # group end
          $group        = "";
          $group_expand = "";
    }elsif( /^\s*\#$INCL_FLAG/ ){
    #}elsif( /^\s*\#/ ){
  #################### SIGNALS ###################################################
    }else{
      $line = $_;
      
          if( $line =~ /\#HEX\s+/ ){ $radix   = "hex";                            # hexadecimal
              $line =~ s/\#HEX\s+//g;
      }elsif( $line =~ /\#BIN\s+/ ){ $radix   = "bin";                            # binary
              $line =~ s/\#BIN\s+//g;
      }elsif( $line =~ /\#DEC\s+/ ){ $radix   = "dec";                            # decimal
              $line =~ s/\#DEC\s+//g;
      }elsif( $line =~ /\#UNS\s+/ ){ $radix   = "uns";                            # unsigned
              $line =~ s/\#UNS\s+//g;
      }else{                         $radix   = "sym";}

      while( $line =~ /\$\{(\w+)\}/ ){                                            # check for user variables in name, multiple possible
        $cur_var = $1;
        if( exists($user_vars{$cur_var}) ){                                       # check for defined variables
          $line =~ s/\$\{$cur_var\}/$user_vars{$cur_var}/g;                       # replace variable with value
        }
      }
      
      if( $line =~ /\#$N_FLAG\s+(\w+)/ ){ $label  = $1;                           # special label
          $line =~ s/\#$N_FLAG\s+(\w+)//g; 
          $line =~ s/\s//g;                                                       # cut any empty spaces inside the signal line
      }else{                                                                      # no special label
        $line =~ s/\s//g;                                                         # cut any empty spaces inside the signal line
        if( $no_path ){  $label = $line;                                          # no path visible, label is only name
        }else{           $label = "";                                             # path should be visible, no label
        }
      }
      
      print "add wave -noupdate ";
      unless( $group eq "" ){ print "$group_expand -group $group "; }
      print "-radix $radix ";
      unless( $label eq "" ){ print "-label $label "; }
      print "\{$path/$line\}\n";

      print STDERR "\\\n\{$path/$line\}";
    }
  }
  
  print "TreeUpdate [SetDefaultTree]\n";
  
  ###################### CURSORS #####################################
  print "WaveRestoreCursors {{Cursor 1} {$cursors[0] $resolution} 0} {{Cursor 2} {$cursors[1] $resolution} 0}\n";
  print "quietly wave cursor active 1\n";
  
  ###################### TRAILER #####################################
  print $OUTPUT_TRAILER;
  
  ###################### ZOOM ########################################
  print "configure wave -timelineunits $resolution\n";
  print "update\n";
  print "WaveRestoreZoom {$zoom[0] $resolution} {$zoom[1] $resolution}\n";

  
}else{
  print " ";                                                                    # print only empty string
}

exit 0;
