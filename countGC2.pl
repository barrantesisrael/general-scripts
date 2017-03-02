#!/opt/perl5.6/bin/perl -w

#    AUTHOR: Peter Hraber, pth@santafe.edu
#     USAGE: countGC.pl <infile>
#   PURPOSE: calculates the GC ratio from sequences in a file, both 
#            considering and ignoring Ns
# REFERENCE: Hraber PT, Weller JW (2001) Genome Biol 2(9):R0037

# 2015-10-08 isradelacon@gmail.com
# input FASTA should be modified to have one sequence per line, e.g.:
# $ perl -pe '/^>/ ? print "\n" : chomp' original.fasta | tail -n+2 > input.fasta

use strict;

my $myname="countGC.pl";
my $infile;

if ($ARGV[0]) {
  $infile = $ARGV[0];
}
else {
  die ("USAGE: $myname <infile>\n\n");
}

open (IF, "< $infile") || die ("$myname ERROR: could not open $infile ($!)\n");

print "#length","\t","GC","\t","GC/length","\t","GC/non-Ns","\n";

while (<IF>) {

# 2015-10-08 isradelacon@gmail.com
# omit FASTA header lines
if (/>/) {next;}

  my $gc_count = 0;
  my $gcat_count = 0;
  my $seq = uc($_);
  my @seq = split(//,$seq);

  for (my $i = 0; $i < $#seq; $i++) {
    if ($seq[$i] eq "C" || $seq[$i] eq "G") 
      { $gc_count++; }
    if ($seq[$i] ne "N") 
      { $gcat_count++; }
  }
  printf "%d\t%d\t%9.7f\t%9.7f\n", $#seq, $gc_count, 
                                   $gc_count/$#seq,
                                   $gc_count/$gcat_count
  if ($#seq > 0);

  undef @seq;
}

close IF;
