#!/bin/bash
# summaries of all Log.final.out files (outputs from the STAR aligner) in the current directory
# usage: dosummarySTAR.sh outputfilename
# 2015-07-09 isradelacon@gmail.com

# assigns outfile
outfile=$1
# processes files
for file in *Log.final.out; do echo -en "$file\t" | sed 's/Log.final.out//;'; cat $file | perl -lne '
if (/Number of input reads/) {s/.*\t//; $outputStr = $_;} 
elsif (/Uniquely mapped reads number/) {s/.*\t//; $outputStr = $outputStr."\t". $_;} 
elsif (/Uniquely mapped reads %/) {s/.*\t//; $outputStr = $outputStr."\t". $_;} 
elsif (/Number of reads mapped to multiple loci/) {s/.*\t//; $outputStr = $outputStr."\t". $_;} 
elsif (/% of reads mapped to multiple loci/) {s/.*\t//; $outputStr = $outputStr."\t". $_;} 
elsif (/% of reads unmapped: too many mismatches/) {s/.*\t//; $outputStr = $outputStr."\t". $_;} 
elsif (/% of reads unmapped: too short/) {s/.*\t//; $outputStr = $outputStr."\t". $_;} 
elsif (/% of reads unmapped: other/) {s/.*\t//; $outputStr = $outputStr."\t". $_; print $outputStr; $outputStr = "";} 
else {next;}'; done > $outfile
# adds header
sed -i '1iFASTQ\tinput\tUNM\tPUNM\tMM\tPMM\tUMM\tUTS\tUO' $outfile
# --done
