#!/bin/bash
# getSAindex.sh -- calculates the 'genomeSAindexNbases' parameter for generating a genome in STAR
# i.e. calculates an optimal STAR SAindex
# "genomeSAindexNbases 14 is the default setting, you should change this parameter according to the genome size. min(14, log2(GenomeLength)/2 - 1)"
# source https://www.biostars.org/p/107268/
# 2015-08-31 isradelacon@gmail.com
file=$1

for genome in ${file} 
do echo -en "File: $genome\t"
grep -v ">" $genome | wc -m | \
perl -lne 'use List::Util qw(min max); 
	my @starGenomeSAindexes = (14); 
	my $inputGenomeSize = $_;
	$customGenomeSAindex = ( log($inputGenomeSize)/log(2) )/2 - 1; 
	push @starGenomeSAindexes, $customGenomeSAindex; 
	my $rounded = sprintf ("%.0f", min @starGenomeSAindexes);
	print "Size (bp): ".$inputGenomeSize."\tSA index: ".$rounded;'; \
done

