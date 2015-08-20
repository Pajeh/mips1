#!/usr/bin/perl -w

my $line  = "";
my $bin   = "";

my @words = ();
my @bytes = ();
my $bits  = ();

my $idx   = 0;
my $addr  = 0;

while(<STDIN>){
  $line = $_;
  @words = split( /\s+/, $line );

  for( $idx = 1; $idx < 5; $idx++ ){
    @bytes = split( //, $words[$idx]);

    print "    -- send 0x$bytes[0]$bytes[1] over UART\n";
    print "    rx    <= '0';  wait for 205 ns;       -- start bit\n";

    $bin = hexadezimal2bin( $bytes[0] );
    @bits = split( //, $bin );

    print "    rx    <= '$bits[0]';  wait for 205 ns;       -- '$bits[0]'\n";
    print "    rx    <= '$bits[1]';  wait for 205 ns;       -- '$bits[1]'\n";
    print "    rx    <= '$bits[2]';  wait for 205 ns;       -- '$bits[2]'\n";
    print "    rx    <= '$bits[3]';  wait for 205 ns;       -- '$bits[3]'\n";
    print "    \n";

    $bin = hexadezimal2bin( $bytes[1] );
    @bits = split( //, $bin );

    print "    rx    <= '$bits[0]';  wait for 205 ns;       -- '$bits[0]'\n";
    print "    rx    <= '$bits[1]';  wait for 205 ns;       -- '$bits[1]'\n";
    print "    rx    <= '$bits[2]';  wait for 205 ns;       -- '$bits[2]'\n";
    print "    rx    <= '$bits[3]';  wait for 205 ns;       -- '$bits[3]'\n";
    print "    \n";

    print "    rx    <= '1';  wait for 205 ns;       -- stop bit\n";
    print "                   wait for 20  ns;\n";
    print "    \n";
  }

  $addr++;  if( $addr == 64 ){ last; }
}

sub hexadezimal2bin{

  local $byte = shift;

      if( $byte eq "0" ){ return "0000"; 
  }elsif( $byte eq "1" ){ return "0001";
  }elsif( $byte eq "2" ){ return "0010";
  }elsif( $byte eq "3" ){ return "0011";
  }elsif( $byte eq "4" ){ return "0100";
  }elsif( $byte eq "5" ){ return "0101";
  }elsif( $byte eq "6" ){ return "0110";
  }elsif( $byte eq "7" ){ return "0111";
  }elsif( $byte eq "8" ){ return "1000";
  }elsif( $byte eq "9" ){ return "1001";
  }elsif( $byte eq "a" ){ return "1010";
  }elsif( $byte eq "b" ){ return "1011";
  }elsif( $byte eq "c" ){ return "1100";
  }elsif( $byte eq "d" ){ return "1101";
  }elsif( $byte eq "e" ){ return "1110";
  }elsif( $byte eq "f" ){ return "1111";
  }else{}
}