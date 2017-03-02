#!/usr/bin/env perl
# keeplongseq.pl -- given a multifasta with two or more sequences with
# the same ID, this script keeps and outputs the longest one.
# usage: perl keeplongseq.pl inputseq > outputseq
# 2014-04-27 isradelacon@gmail.com
# source http://www.perlmonks.org/?node_id=969160

my %seqs;

$/ = '>';                      # break lines on this instead of newline
# while(my $line = <DATA>){
while (my $line = <>){
    chomp $line;               # remove any trailing >
    next unless $line;         # skip leading blank record before first >
    my($id, $seq) = split /\s+/, $line, 2;
    $seq =~ s/[\r\n]//g;       # strip newlines and/or carriage returns from sequence
    unless($seqs{$id} and length($seqs{$id}) > length($seq)){
        $seqs{$id} = $seq;     # save it if it's a new ID or a longer sequence
    }
}

print ">$_ \n$seqs{$_}\n" for keys %seqs;
