#!/usr/bin/perl
# selSeqId.pl -- greps a FASTA header and returns the sequence matching the pattern(s)
# USAGE: selSeqId.pl "pattern" fastafile [-v]
# where '-v' specifies reverse matching
# 2015-08-17 isradelacon@gmail.com

# record delimiter
$/ = "\>";
# removes quotes from pattern
$ARGV[0] =~ s/"(.*?)"/$1/;

open my $fh, '<', $ARGV[1] or die;

if ($ARGV[2] =~ /\-v/) {
while (<$fh>) {
if (/$ARGV[0]/) {next;} else {chop; print ">".$_;}
}}
else {
while (<$fh>) {
if (/$ARGV[0]/) {chop; print ">".$_;} else {next;}
}}

