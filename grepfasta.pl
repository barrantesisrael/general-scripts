#!/usr/bin/perl
# grepfasta.pl -- returns FASTA records matching an expression on their ids
# USAGE: perl grepfasta.pl file(s) 'searchTerm [searchTerm]' [>outFile]
# modified from https://www.biostars.org/p/64149/#64162
# 2015-11-20 isradelacon@gmail.com
use strict;
use warnings;

my $term = join '|', map "\Q$_\E", split ' ', pop;
my $found;

while (<>) {
    if (/^>/) {
        $found = /$term/i ? 1 : 0;
        print if $found;
	next;
    }
    print if $found;
}

