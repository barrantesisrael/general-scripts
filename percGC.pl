#!/usr/bin/env perl
# percGC.pl -- GC content of a FASTA
# usage: percGC.pl fastafile
# modified from http://www.oardc.ohio-state.edu/tomato/HCS806/GC-script.txt
# 2015-05-07 isradelacon@gmail.com 

use strict;
use warnings;
use Bio::SeqIO;

# original line
# die ("Usage: $0 <sequence_file> (output_file>\n"), unless (@ARGV == 2);

my $infile = $ARGV[0];

# original lines
# my ($infile,$outfile) = @ARGV;
# open (OUT,">$outfile");

my $in = Bio::SeqIO->new(-file => $infile, -format => 'fasta');
while (my $seqobj = $in->next_seq) {
    my $id = $seqobj->id;
    my $seq = $seqobj->seq;
    my $length = $seqobj->length;
    my $count = 0;
    for (my $i = 0; $i < $length; $i++) {
	my $sub = substr($seq,$i,1);
	if ($sub =~ /G|C/i) {
	    $count++;
	}
    }
    my $gc = sprintf("%.1f",$count * 100 /$length);

    print $id,"\t",$gc,"\n";

# original line
#    print OUT $id,"\t",$gc,"\n";
}

