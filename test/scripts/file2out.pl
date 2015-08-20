#!/usr/bin/perl -w
use strict;
use warnings;

# revision history
# 05/2014  AS  1.0    initial

#################################################################################
use Fatal qw( open );
use Switch;

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
my $input             = "";                       # input file
my $output            = "";                       # output file

my $txt_format        = "'4/1 \"%02X\"\"\\n\"'";  # default output .txt format


#my $length            = shift;                    # length of the output file entries
#my $start             = shift;                    # start address

#
# line configurations
#
my $LINE_LIMIT        = 32;                       # line address limit

#
# DRAM
#
my $DRAM_BANKS        = 4;                        # number of DRAM banks
my $DRAM_ZERO_WORD    = "00000000";               # for zero padding

my $DRAM_3D_BANKS     = 8;                        # number of 3D DRAM banks
my $DRAM_3D_WORD      = 4;                        # 4 * 32 bit = 3D DRAM word
my $DRAM_ND_WORD      = 32;                       # 32 * 32 bit = 1024 No Delay DRAM word

#################################################################################
#__      __     _____  _____          ____  _      ______  _____ 
#\ \    / /\   |  __ \|_   _|   /\   |  _ \| |    |  ____|/ ____|
# \ \  / /  \  | |__) | | |    /  \  | |_) | |    | |__  | (___  
#  \ \/ / /\ \ |  _  /  | |   / /\ \ |  _ <| |    |  __|  \___ \ 
#   \  / ____ \| | \ \ _| |_ / ____ \| |_) | |____| |____ ____) |
#    \/_/    \_\_|  \_\_____/_/    \_\____/|______|______|_____/ 
#################################################################################
#
# command line options
#
my %par_arguments     =(  
                        -hex        => 4,         # .bin -> .txt
                        -e_switch   => 2,         # .txt -> .txt endian switch
                        -mem        => 5,         # .txt -> .mem
                        -fill       => 2,         # .txt -> .txt
                        -to_dram    => 2,         # .txt -> dram.mem
                        -to_3d      => 3,         # .txt -> 3d_dram.mem
                        -txt        => 5,         # .mem -> .txt
                        -from_dram  => 2,         # dram.mem -> .txt
                        -from_3d    => 2,         # 3d_dram.mem -> .txt
                        -bin        => 3          # .txt -> .bin
    );
my $parameter         = "";
my %parameters        = ();

#
# parsing
#
my $line              = "";                       # current line
my @bytes             = ();                       # current bytes
my @bytes_rest        = ();                       # rest from previous extraction
my $start_flag        = 0;                        # no start option
my $length_flag       = 0;                        # length limit indication

#
# DRAM
#
my $dram_file_name    = "";                       # current file name
my @file_handles      = ();                       # output file handles
my $file_handle;                                  # current file handle

my $bank_idx          = 0;                        # current bank index
my $right_flag        = 0;                        # flag for current word site
my @idx_str           = ();                       # array for current string index per bank
my @line_str          = ();                       # array for current string per bank
my @word_str          = ();                       # array for current line substring

my @dram_out          = ();                       # output array
my $out_idx           = 0;                        # index of output array
my @words             = ();                       # each words in a data string

#
# address
#
my $addr              = 0;                        # current address
my $hex_addr          = "";                       # hex string of address
my $cur_length        = 0;                        # current length
my $line_addr         = 0;                        # line address

#
# parsing
#
my @chars             = ();                       # hex chars from input line
my $idx               = 0;                        # index of char array
my $i                 = 0;                        # index of first char
my $j                 = 0;                        # index of second char

#
# length
#
my $filelength        = 0;                        # file length -> does not work inside switch
my $hex_length        = "";                       # file length in hex format


#################################################################################
# ____  ______ _____ _____ _   _ 
#|  _ \|  ____/ ____|_   _| \ | |
#| |_) | |__ | |  __  | | |  \| |
#|  _ <|  __|| | |_ | | | | . ` |
#| |_) | |___| |__| |_| |_| |\  |
#|____/|______\_____|_____|_| \_|
#################################################################################
# ____ ____ _  _ _  _ ____ _  _ ___     _    _ _  _ ____    ___  ____ ____ ____ _  _ ____ ___ ____ ____ 
# |    |  | |\/| |\/| |__| |\ | |  \    |    | |\ | |___    |__] |__| |__/ |__| |\/| |___  |  |___ |__/ 
# |___ |__| |  | |  | |  | | \| |__/    |___ | | \| |___    |    |  | |  \ |  | |  | |___  |  |___ |  \ 
#
# first parameter = direction
#
$parameter  = shift;

if( exists($par_arguments{$parameter}) ){                                       # check for valid parameter

  # ############# DIRECTORY ############################
  $parameters{DIR} = $parameter;    $parameters{IDX} = 1;                       # set directory and start index

  # ############# OPTIONS ##############################
  $parameter = shift;                                                           # get next parameter
  while(defined $parameter){                                                    # if exists
    $parameters{$parameters{IDX}} = $parameter;                                 # store it with current index
    $parameters{IDX}++;                                                         # update index
    $parameter = shift;                                                         # get next parameter
  }

  # ############# SANITY CHECK #########################
  if( $parameters{IDX} < 2 ){                                                   # at least directory and input file are expected                        
    print "WARNING: Incorrect number of arguments, exit!\n";
    print_help();
    exit 1;
  }

  # ############### INPUT FILE #########################
  $parameters{INPUT}  = $parameters{1};                                         # set input file
  $filelength         = -s $parameters{INPUT};                                  # get file length
  
}else{                                                                          # parameter invalid
  print "WARNING: No parameter \"$parameter\" defined, exit!\n";                
  print_help();
  exit 1;
}


# ___  _ ____ ____ ____ ___ ____ ____ _   _    ____ _ _ _ _ ___ ____ _  _ 
# |  \ | |__/ |___ |     |  |  | |__/  \_/     [__  | | | |  |  |    |__| 
# |__/ | |  \ |___ |___  |  |__| |  \   |      ___] |_|_| |  |  |___ |  | 
#
# different routines depending on directory
#
switch( $parameters{DIR} ){
  # ############################# FROM BIN TO .TXT ##########################################
  # ___  _ _  _          ___ _  _ ___ 
  # |__] | |\ |    __     |   \/   |  
  # |__] | | \|           |  _/\_  |    
  case "-hex" { 

    if( $parameters{IDX} == 4 ){ $parameters{FORMAT} = $parameters{3};                      # check for format option
    }else{                       $parameters{FORMAT} = $txt_format;}                        # else default

    # write file length at first 4 bytes
    # print -s $parameters{INPUT};
    #$bank_idx = -s $parameters{INPUT};
    #print "$filelength\n";
    $hex_length = sprintf( '%08x', $filelength );
    print "$hex_length\n";

    system( "hexdump -v -e $parameters{FORMAT} $parameters{INPUT}" );                       # call extern function

  }

  # ############################# FROM .TXT TO .TXT ENDIAN SWITCH ###########################
  case "-e_switch" { 

    # open input file                                                     
    open IN_FILE, "< $parameters{INPUT}"
      or die "ERROR: cannot open $parameters{INPUT}! $!\n";

    # ############ PRINT INTPUT FILE #####################
    while(<IN_FILE>){ 

      $line = $_;                                                                           # get current line
      chomp( $line );                                                                       # cut newline character

      $line =~ s/(.{2})/$1 /g;                                                              # insert space every 2 characters = 1 byte
      @bytes = split( /\s+/, $line );                                                       # extract bytes

      print "$bytes[3]$bytes[2]$bytes[1]$bytes[0]\n";
      
    }

    # close input file
    close IN_FILE;
  }

  # ############################ FROM .TXT to DRAM.MEM ######################################
  case "-to_dram" {

    if( $parameters{IDX} == 3 ){ $parameters{PREFIX} = $parameters{2}; }                    # prefix of the output files
    else{ print "ERROR: PREFIX of the output file is mandatory here!\n";
          print_help();
          exit 1; }


    for( $bank_idx = 0; $bank_idx < $DRAM_BANKS; $bank_idx++ ){                             # open output file for each DRAM bank
      local *DRAM_FILE;

      open( DRAM_FILE, "> ${parameters{PREFIX}}_DRAM_in_$bank_idx.mem" )                    # compose output file name
        or die "ERROR: cannot create ${parameters{PREFIX}}_DRAM_in_$bank_idx.mem file! $!\n";

        push( @file_handles, *DRAM_FILE );                                                  # add file handle to array

        push( @idx_str, 0   );                                                              # preset index for line string
        push( @line_str, "" );                                                              # preset line string per bank
        push( @word_str, "" );                                                              # preset word string per line
    }

    # open input file                                                     
    open IN_FILE, "< $parameters{INPUT}"
      or die "ERROR: cannot open $parameters{INPUT}! $!\n";

    # ########## INPUT FILE READ #########################
    # $bank_idx = 0;                                                                          # reset current index

    # while(<IN_FILE>){

    #   $line = $_;                                                                           # get current line
    #   chomp($line);                                                                         # cut newline character

    #   $line_str[$bank_idx] = $line.$line_str[$bank_idx];                                    # append current line from left to line string
    #   $idx_str[$bank_idx++]++;                                                              # increment line and bank index

    #   if( ($bank_idx == $DRAM_BANKS) && ($idx_str[$DRAM_BANKS - 1] == $DRAM_BANKS) ){       # if bank index run to number of banks
    #                                                                                         # and line index is equal to number of banks -> lines are full
        
    #     for( $bank_idx = 0; $bank_idx < 4; $bank_idx++ ){                                   # write lines to output files
    #       print {$file_handles[$bank_idx]} "$line_str[$bank_idx]\n";
    #     }

    #     for( $bank_idx = 0; $bank_idx < $DRAM_BANKS; $bank_idx++ ){                         # and reset lines and bank index
    #       $line_str[$bank_idx]  = "";
    #       $idx_str[$bank_idx]   = 0;
    #     }
    #   }

    #   if( $bank_idx == $DRAM_BANKS ){ $bank_idx = 0; }                                      # all banks hast an current bank entry

    # }

    $bank_idx = $DRAM_BANKS - 1;

    while(<IN_FILE>){

      $line = $_;
      chomp( $line );

      $line =~ s/(.{4})/$1 /g;
      @words = split( /\s+/, $line );

      $word_str[$bank_idx] = $word_str[$bank_idx].$words[0];    $bank_idx--;
      $word_str[$bank_idx] = $word_str[$bank_idx].$words[1];    $bank_idx--;

      if( $bank_idx == -1 ){

        $idx_str[$right_flag]++;
        $bank_idx = $DRAM_BANKS - 1;

      }

      if( $idx_str[$right_flag] == $DRAM_BANKS ){

        if( $right_flag ){
          for( $bank_idx = 0; $bank_idx < $DRAM_BANKS; $bank_idx++ ){
          
            print {$file_handles[$bank_idx]} $word_str[$bank_idx].$line_str[$bank_idx]."\n";

            $word_str[$bank_idx] = "";
            $line_str[$bank_idx] = "";
          }

          $idx_str[$right_flag]   = 0;
          $right_flag             = 0;

        } else {
          for( $bank_idx = 0; $bank_idx < $DRAM_BANKS; $bank_idx++ ){
            $line_str[$bank_idx] = $word_str[$bank_idx];
            $word_str[$bank_idx] = "";
          }

          $idx_str[$right_flag]   = 0;
          $right_flag             = 1;
        }

        $bank_idx--;
      }
    }

    close IN_FILE;                                                                          # infile is read complete

    # ########## ZERO PADDING ###########################
    # while( $idx_str[$DRAM_BANKS - 1] != $DRAM_BANKS ){                                      # bank lines are not full but could contain data
  
    #   $line = $DRAM_ZERO_WORD;

    #   $line_str[$bank_idx] = $line.$line_str[$bank_idx];
    #   $idx_str[$bank_idx++]++;

    #   if( ($bank_idx == $DRAM_BANKS) && ($idx_str[$DRAM_BANKS - 1] == $DRAM_BANKS) ){
        
    #     for( $bank_idx = 0; $bank_idx < 4; $bank_idx++ ){
    #       print {$file_handles[$bank_idx]} "$line_str[$bank_idx]\n";
    #     }
    #   }

    #   if( $bank_idx == $DRAM_BANKS ){ $bank_idx = 0; }
    # }

    while( $idx_str[1] != $DRAM_BANKS ){

      @words = ("0000", "0000");

      $word_str[$bank_idx] = $word_str[$bank_idx].$words[0];    $bank_idx--;
      $word_str[$bank_idx] = $word_str[$bank_idx].$words[1];    $bank_idx--;

      if( $bank_idx == -1 ){

        $idx_str[$right_flag]++;
        $bank_idx = $DRAM_BANKS - 1;

      }

      if( $idx_str[$right_flag] == $DRAM_BANKS ){

        if( $right_flag ){
          for( $bank_idx = 0; $bank_idx < $DRAM_BANKS; $bank_idx++ ){
          
            print {$file_handles[$bank_idx]} $word_str[$bank_idx].$line_str[$bank_idx]."\n";

            $word_str[$bank_idx] = "";
            $line_str[$bank_idx] = "";
          }

          $right_flag             = 0;

        } else {
          for( $bank_idx = 0; $bank_idx < $DRAM_BANKS; $bank_idx++ ){
            $line_str[$bank_idx] = $word_str[$bank_idx];
            $word_str[$bank_idx] = "";
          }

          $right_flag             = 1;
        }

        $bank_idx--;
      }
    }

    # ########### CLOSE OUTPUT FILES ###################
    foreach $file_handle ( @file_handles ){ close $file_handle; }                           # close all output files

  }

  # ############################ FROM .TXT to 3D_DRAM.MEM ###################################
  # ___ _  _ ___          ___     ___  ____ ____ _  _ 
  #  |   \/   |     __    |  \    |  \ |__/ |__| |\/| 
  #  |  _/\_  |           |__/    |__/ |  \ |  | |  | 
  case "-to_3d" {

    if( $parameters{IDX} > 2 ){ $parameters{PREFIX} = $parameters{2}; }                    # prefix of the output files
    else{ print "ERROR: PREFIX of the output file is mandatory here!\n";
          print_help();
          exit 1; }

    if( $parameters{IDX} == 4 ){ $parameters{NO_DELAY} = 1; }                                # no delay definition
    else{ $parameters{NO_DELAY} = 0; }


    unless( $parameters{NO_DELAY} ){

      for( $bank_idx = 0; $bank_idx < $DRAM_3D_BANKS; $bank_idx++ ){                        # open output file for each DRAM bank
        local *DRAM_FILE;

        open( DRAM_FILE, "> ${parameters{PREFIX}}_3D_DRAM_in_$bank_idx.mem" )               # compose output file name
          or die "ERROR: cannot create ${parameters{PREFIX}}_3D_DRAM_in_$bank_idx.mem file! $!\n";

          push( @file_handles, *DRAM_FILE );                                              # add file handle to array

          push( @idx_str, 0   );                                                              # preset index for line string
          push( @line_str, "" );                                                              # preset line string per bank
          push( @word_str, "" );                                                              # preset word string per line
      }
    }

    # open input file                                                     
    open IN_FILE, "< $parameters{INPUT}"
      or die "ERROR: cannot open $parameters{INPUT}! $!\n";


    # ########## INPUT FILE READ #########################
    if( $parameters{NO_DELAY} ){

      push( @idx_str, 0   );                                                              # preset index for line string
      push( @line_str, "" );                                                              # preset line string per bank


      while(<IN_FILE>){

        # read line
        $line = $_;                                                                           # get current line
        chomp($line);                                                                         # cut newline character

        # change from little to big endian
        $line =~ s/(.{2})/$1 /g;                                                              # insert space every 2 characters = 1 byte
        @bytes = split( /\s+/, $line );                                                       # extract bytes

        if( $#bytes == 2 ){ $bytes[3] = "00"; }
        if( $#bytes == 1 ){ $bytes[3] = "00"; $bytes[2] = "00"; }
        if( $#bytes == 0 ){ $bytes[3] = "00"; $bytes[2] = "00"; $bytes[1] = "00"; }


        $line = "$bytes[3]$bytes[2]$bytes[1]$bytes[0]";                                       # change byte endianess

        $line_str[0] = $line.$line_str[0];                                                    # append current line from left to line string
        $idx_str[0]++;                                                                        # increment line index

        if( $idx_str[0] == $DRAM_ND_WORD ){                                                   # line is full
          print "$line_str[0]\n";                                                             # write line

          $line_str[0]  = "";                                                                 # reset line string
          $idx_str[0]   = 0;                                                                  # reset line index
        }
      }

          # ########## ZERO PADDING ###########################
      while( $idx_str[0] != $DRAM_ND_WORD ){                                                  # one line is not full
  
        $line = $DRAM_ZERO_WORD;

        $line_str[0] = $line.$line_str[0];                                                    # append current line from left to line string
        $idx_str[0]++;                                                                        # increment line index

        if( $idx_str[0] == $DRAM_ND_WORD ){                                                   # line is full
          print "$line_str[0]\n";                                                             # write line
        }
      }
    
    }else{
    $bank_idx = 0;                                                                          # reset current index

    while(<IN_FILE>){

      $line = $_;                                                                           # get current line
      chomp($line);                                                                         # cut newline character

      # change from little to big endian
      $line =~ s/(.{2})/$1 /g;                                                              # insert space every 2 characters = 1 byte
      @bytes = split( /\s+/, $line );                                                       # extract bytes

      if( $#bytes == 2 ){ $bytes[3] = "00"; }
      if( $#bytes == 1 ){ $bytes[3] = "00"; $bytes[2] = "00"; }
      if( $#bytes == 0 ){ $bytes[3] = "00"; $bytes[2] = "00"; $bytes[1] = "00"; }

      $line = "$bytes[3]$bytes[2]$bytes[1]$bytes[0]";                                       # change byte endianess

      $line_str[$bank_idx] = $line.$line_str[$bank_idx];                                    # append current line from left to line string
      $idx_str[$bank_idx]++;                                                                # increment line index

      if( $idx_str[$bank_idx] == $DRAM_3D_WORD ){                                           # line is full
        print {$file_handles[$bank_idx]} "$line_str[$bank_idx]\n";                          # write line to output file

        $line_str[$bank_idx]  = "";                                                         # reset line string
        $idx_str[$bank_idx]   = 0;                                                          # reset line index
        $bank_idx++;                                                                        # increment bank index
      }

      if( $bank_idx == $DRAM_3D_BANKS ){ $bank_idx = 0; }                                   # reset bank index
    }

    # ########## ZERO PADDING ###########################
    while( $idx_str[$bank_idx] != $DRAM_3D_WORD ){                                          # one line is not full
  
      $line = $DRAM_ZERO_WORD;

      $line_str[$bank_idx] = $line.$line_str[$bank_idx];                                    # append current line from left to line string
      $idx_str[$bank_idx]++;                                                                # increment line index

      if( $idx_str[$bank_idx] == $DRAM_3D_WORD ){                                           # line is full
        print {$file_handles[$bank_idx]} "$line_str[$bank_idx]\n";                          # write line to output file
      }
    }

    # ########### CLOSE OUTPUT FILES ###################
    foreach $file_handle ( @file_handles ){ close $file_handle; }                           # close all output files
    }
  }

  # ############################# FROM .TXT TO .TXT #########################################
  case "-fill" {

    if( $parameters{IDX} == 3 ){ $parameters{LIMIT} = $parameters{2}; }                    # check for start address
    else{ print "ERROR: address is mandatory here!\n";
          print_help();
          exit 1; }

    # open input file                                                     
    open IN_FILE, "< $parameters{INPUT}"
      or die "ERROR: cannot open $parameters{INPUT}! $!\n";

    # ############ PRINT INTPUT FILE #####################
    while(<IN_FILE>){ 
      print $_;                                                                            # print input file to output

      $addr++;
    }

    # close input file
    close IN_FILE;

    # ############# PRINT ZEROS ##########################
    while( $addr < $parameters{LIMIT} ){
      print "$DRAM_ZERO_WORD\n";
      $addr++;
    }

  }

  # ############################# FROM .TXT TO .MEM #########################################
  case "-mem" {

    if( $parameters{IDX} == 3 ){ $addr = $parameters{2}; $start_flag = 4;}                  # check for start address
    if( $parameters{IDX} == 4 ){ $addr = $parameters{2}; $start_flag = 4;                   # check for length content
                                                         $length_flag = $parameters{3};}

    # open input file                                                     
    open IN_FILE, "< $parameters{INPUT}"
      or die "ERROR: cannot open $parameters{INPUT}! $!\n";

    # ########## INPUT FILE READ #########################
    while(<IN_FILE>){

      #if( $start_flag ){                                                                    # start address is set
        $hex_addr = sprintf( '@%x', $addr );                                                # format output address string
      #}

      $line = $_;                                                                           # get current line
      $line =~ s/(.{2})/$1 /g;                                                              # insert space every 2 characters = 1 byte
      print "$hex_addr $line";                                                              # print it out with given address string

      $cur_length += 4;                                                                     # update length
      #$addr       += $start_flag;                                                           # update address
      $addr += 4;

      if( $length_flag ){                                                                   # check length
        if( $cur_length >= $length_flag ){ last; }                                          # cancel if reached
      }
    }

    close IN_FILE;

    # ########### LENGTH ZERO PADDING ####################
    if( $length_flag ){                                                                     # only for given length

      if( $cur_length < $length_flag ){ print "\n"; }                                       # add newline

      while( $cur_length < $length_flag ){                                                  # and not arrived length

        if( $start_flag ){                                                                  # if address should also be printed out
          $hex_addr = sprintf( '@%x', $addr );                                              # format address string
        }

        $line = "00 00 00 00\n";                                                            # output line ist constant
        print "$hex_addr $line";                                                            # print it out

        $cur_length += 4;                                                                   # update length
        $addr       += $start_flag;                                                         # update address

      } # while
    } # length_flag
  } # -hex

  # ############################## FROM .MEM TO .TXT #########################################
  case "-txt"  {

    if( $parameters{IDX} == 3 ){ $addr = $parameters{2}; $start_flag = 4;}                  # check for start address option
    if( $parameters{IDX} == 4 ){ $addr = $parameters{2}; $start_flag = 4;                   # check for length options
                                                         $length_flag = $parameters{3};}

    $filelength = 0;                                                                        # reset file length information

    # open input file
    open IN_FILE, "< $parameters{INPUT}"
      or die "ERROR: cannot open $parameters{INPUT}! $!\n";

    # ############ INPUT FILE READ ######################
LINE: while(<IN_FILE>){

      @bytes = split( /\s+/, $_ );                                                          # extract bytes

      if( $bytes[0] =~ /^\@(\d+)/ ){                                                        # line contains address information = valid data

        unless( $filelength ){                                                              # file length is not extracted
          $filelength = hex( "$bytes[1]$bytes[2]$bytes[3]$bytes[4]" );                      # read file length
          splice( @bytes, 1, 4 );                                                           # remove this information from output
          $length_flag = $filelength + 1;                                                   # set length flag
        }

        # if( $start_flag ){                                                                  # check for start address
        #   if( $addr > hex($1) ){                                                            # if not already reached
        #     next LINE;                                                                      # examine next line
        #   }
        # }

        splice( @bytes, 0, 1, @bytes_rest );                                                # replace addres field with reset of previous extraction
        @bytes_rest = ();                                                                   # clear this array

        while( (scalar @bytes) > 3 ){                                                       # there are more than 3 bytes in the working array

          print "$bytes[0]$bytes[1]$bytes[2]$bytes[3]\n";                                   # print word
          splice( @bytes, 0, 4 );                                                           # cut it

          $cur_length += 4;                                                                 # update length

          if( $length_flag ){                                                               # if length is set
            if( $cur_length > $length_flag ){ last LINE; }                                  # examine and exit if reached
          }
        }

        splice( @bytes_rest, 0, 0, @bytes );                                                # update rest
      }

    }

    close IN_FILE;

    # ############# LENGTH ZERO PADDING #################
    if( $length_flag ){                                                                     # length is given
      while( $cur_length < $length_flag ){                                                  # and not already reached
        print "00000000\n";                                                                 # print zero out
        $cur_length += 4;                                                                   # update length
      }
    }

  }

  # ################################ FRAOM DRAM.TXT to .TXT #################################
  case "-from_dram" {

    if( $parameters{IDX} == 2 ){ $parameters{PREFIX} = $parameters{INPUT}; }                # prefix of input files
    else{ print "ERROR: PREFIX of the input file is mandatory here!\n";
          print_help();
          exit 1; }

    # ############ READ FROM EACH OUTPUT FILE SEPARATELY
    for( $idx = 0; $idx < $DRAM_BANKS; $idx++ ){                                            # there should be one output file per bank

      open( OUT_FILE, "< ${parameters{PREFIX}}_DRAM_out_$idx.mem" )                         # open output file
        or die "ERROR: cannot open ${parameters{PREFIX}}_DRAM_out_$idx.mem file! $!\n";

      # ############## READ OUTPUT FILE ################
      # while(<OUT_FILE>){

      #   if( /^\@(\w+)\s(\w+)/ ){                                                            # detect address information

      #     $line = $2;                                                                       # get only data string
      #     $line =~ s/(.{8})/$1 /g;                                                          # split data into word strings
      #     @words = split( /\s+/, $line );                                                   # and put them separately an an array

      #     for( $bank_idx = 0; $bank_idx < $DRAM_BANKS; $bank_idx++ ){                       # distribute words to output array
      #       $dram_out[$idx + $out_idx + $bank_idx*4] =                                      # current index + file index and offset is bank number
      #           $words[$DRAM_BANKS - 1 - $bank_idx];                                        # words are composed from right to left (wrong direction)
      #     }

      #     $out_idx += $DRAM_BANKS * 4;                                                      # update output index
      #   }
      # }      

      # $out_idx = 0;                                                                        # reset output index

      while(<OUT_FILE>){

        if( /^\@(\w+)\s(\w+)/ ){

          $line = $2;
          $line =~ s/(.{4})/$1 /g;
          @words = split( /\s+/, $line );

          # reorder words
          for( $bank_idx = 0; $bank_idx < 4; $bank_idx++ ){

            $line = $words[$bank_idx];
            $words[$bank_idx] = $words[$bank_idx + 4];
            $words[$bank_idx + 4] = $line;
          }

          if( $idx < 2 ){ $i = 1; } else{ $i = 0; }

          for( $bank_idx = 0; $bank_idx <= $#words; $bank_idx++ ){

            $j = $out_idx + 2*$bank_idx + $i;

            if( $idx % 2 ){
              $dram_out[$j] = $words[$bank_idx].$dram_out[$j];
            } else {
              $dram_out[$j] = $words[$bank_idx];
            }
          }

          $out_idx += $DRAM_BANKS * 4;

        }
      }

      $out_idx = 0;

      # ############ CLOSE OUTPUT FILE #################
      close OUT_FILE;
    }

    # ############## PRINT OUTPUT ######################
    $filelength = hex( $dram_out[0] );

    print "length is $filelength\n";
    # for( $out_idx = 0; $out_idx < $#dram_out; $out_idx++ ){
    #   print "$dram_out[$out_idx]\n";
    # }

  }

  # ################################ FRAOM 3D DRAM.MEM to .TXT #################################
  # ___     ___  ____ ____ _  _          ___ _  _ ___ 
  # |  \    |  \ |__/ |__| |\/|    __     |   \/   |  
  # |__/    |__/ |  \ |  | |  |           |  _/\_  |  
  case "-from_3d" {

    if( $parameters{IDX} > 1 ){ $parameters{PREFIX} = $parameters{INPUT}; }                # prefix of input files
    else{ print "ERROR: PREFIX of the input file is mandatory here!\n";
          print_help();
          exit 1; }

    if( $parameters{IDX} == 3 ){ $parameters{NO_DELAY} = 1; }                                # no delay definition
    else{ $parameters{NO_DELAY} = 0; }

    if( $parameters{NO_DELAY} ){

      open( OUT_FILE, "< ${parameters{PREFIX}}" )                                            # open output file
        or die "ERROR: cannot open ${parameters{PREFIX}}_3D_DRAM_out.mem file! $!\n";

      $out_idx = 0;

      while(<OUT_FILE>){

        if( /^\@(\w+)\s(\w+)/ ){

          $line = $2;
          $line =~ s/(.{8})/$1 /g;
          @words = split( /\s+/, $line );

          for( $i = 0; $i < $DRAM_ND_WORD; $i++ ){

            # change from little to big endian
            $line  = $words[$DRAM_ND_WORD - $i - 1];

            $line =~ s/(.{2})/$1 /g;                                                          # insert space every 2 characters = 1 byte
            @bytes = split( /\s+/, $line );                                                   # extract bytes
            $line = "$bytes[3]$bytes[2]$bytes[1]$bytes[0]";

            # $dram_out[$j] = $words[$DRAM_3D_WORD - $i - 1];
            $dram_out[$out_idx] = $line;
            $out_idx++;
          }
        }
      }

      # ############ CLOSE OUTPUT FILE #################
      close OUT_FILE;

    } else {

    # ############ READ FROM EACH OUTPUT FILE SEPARATELY
    for( $idx = 0; $idx < $DRAM_3D_BANKS; $idx++ ){                                         # there should be one output file per bank

      open( OUT_FILE, "< ${parameters{PREFIX}}_3D_DRAM_out_$idx.mem" )                      # open output file
        or die "ERROR: cannot open ${parameters{PREFIX}}_DRAM_out_$idx.mem file! $!\n";

      $out_idx = $idx * $DRAM_3D_WORD;

      # ############## READ OUTPUT FILE ################
      while(<OUT_FILE>){

        if( /^\@(\w+)\s(\w+)/ ){

          $line = $2;
          $line =~ s/(.{8})/$1 /g;
          @words = split( /\s+/, $line );

          for( $i = 0; $i < $DRAM_3D_WORD; $i++ ){
            $j = $out_idx + $i;

            # change from little to big endian
            $line  = $words[$DRAM_3D_WORD - $i - 1];
            $line =~ s/(.{2})/$1 /g;                                                          # insert space every 2 characters = 1 byte
            @bytes = split( /\s+/, $line );                                                   # extract bytes
            $line = "$bytes[3]$bytes[2]$bytes[1]$bytes[0]";

            # $dram_out[$j] = $words[$DRAM_3D_WORD - $i - 1];
            $dram_out[$j] = $line;
          }

          $out_idx += $DRAM_3D_BANKS * $DRAM_3D_WORD;
        }
      }      

      # ############ CLOSE OUTPUT FILE #################
      close OUT_FILE;
    }
    }

    # ############## PRINT OUTPUT ######################
    $filelength = hex( $dram_out[0] );
    $filelength = ($filelength / 4) + 1;

    for( $out_idx = 1; $out_idx < $filelength; $out_idx++ ){
      print "$dram_out[$out_idx]\n";
    }
  }

  # ################################# FROM .TXT TO .BIN #####################################
  case "-bin"  {

    if( $parameters{IDX} == 3){                                                             # check for output file name
      $parameters{OUTPUT} = $parameters{2};                                                 # set output file name
    }else{                                                                                  # output file name is mandatory
      print "ERROR: Output file should be specivied on bin mode!\n";
      print_help();
      exit 1;
    }

    # open input file
    open IN_FILE, "< $parameters{INPUT}"
      or die "ERROR: cannot open $parameters{INPUT}! $!\n";
    #open output file
    open OUT_FILE, "> $parameters{OUTPUT}"
      or die "ERROR: cannot open $parameters{OUTPUT}! $!\n";

    print "$parameters{INPUT} -> $parameters{OUTPUT}\n";                                    # print user information

    binmode(OUT_FILE);                                                                      # set mode

    # ############# INPUT FILE READ ###################
    while(<IN_FILE>){
      $line   = $_;                                                                         # get current line
      $line   =~ s/(.{2})/$1 /g;                                                            # insert space every 2 characters = 1 byte
      @bytes  = split( /\s/, $line );                                                       # extract bytes
      foreach( @bytes ){ print OUT_FILE pack( 'C1', hex($_) ); }                            # write these bytes to output file
    }

    close OUT_FILE;
    close IN_FILE;    

  }

  # ################################ UNKNOWN DIRECTORY ######################################
  else          { 
    print "WARNING: Undefined direction $parameters{DIR}, nothing to do!\n";
    print_help();
    exit 0;
  }
}

exit 0;
#################################################################################
#   _____ _    _ ____  ______ _    _ _   _  _____ _______ _____ ____  _   _  _____ 
#  / ____| |  | |  _ \|  ____| |  | | \ | |/ ____|__   __|_   _/ __ \| \ | |/ ____|
# | (___ | |  | | |_) | |__  | |  | |  \| | |       | |    | || |  | |  \| | (___  
#  \___ \| |  | |  _ <|  __| | |  | | . ` | |       | |    | || |  | | . ` |\___ \ 
#  ____) | |__| | |_) | |    | |__| | |\  | |____   | |   _| || |__| | |\  |____) |
# |_____/ \____/|____/|_|     \____/|_| \_|\_____|  |_|  |_____\____/|_| \_|_____/ 
#################################################################################
#
# help string
#

sub print_help{
  print STDERR "usage: file2out.pl DIR INPUT [OUTPUT] [PREFIX] [OPTIONS]
creates formatted data depending on DIR

Examples: 
  file2out.pl -mem program.txt
  file2out.pl -txt data.mem 100 300
  
DIR can be:
  -hex  .bin -> .txt
  -mem  .txt -> .mem
  -txt  .mem -> .txt
  -bin  .txt -> .bin OUTPUT is mandatory here

  -fill           .txt -> .txt zero padding address is mandatory
  -to_dram        .txt -> dram.mem PREFIX is mandatory here
  -from_dram  dram.mem -> .txt PREFIX is mandatory here

  -to_3d          .txt -> 3d_dram.mem PREFIX is mandatory here
  -from_3d 3d_dram.mem -> .txt PREFIX is mandatory here

  -e_switch       .txt -> .txt with ENDIAN switch
  
OPTIONS can be:
  start  start address
  length meximal length, zero padded
";
}