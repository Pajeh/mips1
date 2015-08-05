#!/bin/bash

hdllab/test/scripts/create_design.pl -a alu       	$HOME/hdllab/test/conf
hdllab/test/scripts/create_design.pl -a cpu       	$HOME/hdllab/test/conf
hdllab/test/scripts/create_design.pl -a cpu_full  	$HOME/hdllab/test/conf
hdllab/test/scripts/create_design.pl -a lab       	$HOME/hdllab/test/conf
hdllab/test/scripts/create_design.pl -a execution   $HOME/hdllab/test/conf
hdllab/test/scripts/create_design.pl -a mem_stage   $HOME/hdllab/test/conf
hdllab/test/scripts/create_design.pl -a instruction_fetch   $HOME/hdllab/test/conf
hdllab/test/scripts/create_design.pl -a write_back   $HOME/hdllab/test/conf


echo "alias sim \"create_design.pl -sim\"
alias syn \"create_design.pl -syn\"

set path=(\$path $HOME/hdllab/test/scripts)
" >> $HOME/.cshrc

exit 0
