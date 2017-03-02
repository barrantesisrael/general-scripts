#!/usr/bin/perl
# fastastats.pl
# source http://seqanswers.com/forums/showthread.php?t=15856
# 2015-04-17 isradelacon@gmail.com

use warnings;
use strict;
use Statistics::Descriptive;

my $stat = Statistics::Descriptive::Full->new();
my (%distrib);
my @bins = qw/100 500 1000 10000 100000 500000 1000000/;

my $fastaFile = shift;
open (FASTA, "<$fastaFile");
$/ = ">";

my $junkFirstOne = <FASTA>;

while (<FASTA>) {
	chomp;
	my ($def,@seqlines) = split /\n/, $_;
	my $seq = join '', @seqlines;
	$stat->add_data(length($seq));
}


%distrib = $stat->frequency_distribution(\@bins);

print "Total fragments:\t" . $stat->count() . "\n";
print "Total nt:\t" . $stat->sum() . "\n";
print "Mean length:\t" . $stat->mean() . "\n";
print "Median length:\t" . $stat->median() . "\n";
print "Mode length:\t" . $stat->mode() . "\n";
print "Max length:\t" . $stat->max() . "\n";
print "Min length:\t" . $stat->min() . "\n";
print "Length\t# Seqs\n";
foreach (sort {$a <=> $b} keys %distrib) {
	print "$_\t$distrib{$_}\n";
}
