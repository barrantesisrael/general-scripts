#!/usr/bin/perl 
# renamefastaids.pl -- replaces FASTA ids with others from a list
#  USAGE: $ perl renamefastaids.pl newnamelist infile.fasta > outfile.fasta
#  where newnamelist contains the new ids (one per line)
#  modified from https://www.biostars.org/p/103089/#103106
# 2016-07-06 isradelacon@gmail.com

use strict;
use warnings;

my @arr;

while (<>) {
    chomp;
    push @arr, $_ if length;
    last if eof;
}

while (<>) {
    print /^>/ ? ">".shift(@arr) . "\n" : $_;
}

