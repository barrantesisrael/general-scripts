#!/bin/sh
# mergtotalexprs.sh -- merges total counts from all XPRS files inside the current directory
# usage: mergtotalexprs.sh
# 2015-05-26 isradelacon@gmail.com

# TOTAL counts from XPRS files
for file in *.xprs; do cat $file | cut -f2,5 > $file.short; done

# transcript lengths
ls -1 *.xprs | head -n1 | xargs cut -f2,3 > trlen.tmp

# create merger Rscript
ls -1 *.xprs.short | sed -e 's/.xprs.short//;' | perl -lne '$orname = $_; $phrase = "D$orname <- read.csv(\"$orname.xprs.short\", header=TRUE, sep=\"\\t\")"; print $phrase;' >> mergescript.R
perl -e 'print "mergexprs <- function(x, y){\ndf <- merge(x, y, by= \"target_id\", all=TRUE)\nreturn(df)\n}\n";' >> mergescript.R
ls *.xprs.short | sed -e 's/.xprs.short//g;' | perl -lne 'print "D$_";' | tr '\n' ',' | sed -e 's/,/, /g;' | perl -lne 'chop $_; chop $_; print "alldata <- Reduce(mergexprs, list($_))\n";' >> mergescript.R
perl -e 'print "DLEN <- read.csv(\"trlen.tmp\", header=TRUE, sep=\"\\t\")\n";' >> mergescript.R
perl -e 'print "alldata <- merge(DLEN, alldata, by=\"target_id\", all=TRUE)\n";' >> mergescript.R
ls *.xprs.short | sed -e 's/.xprs.short//g;' | perl -lne 'print "\"D$_\"";'| tr '\n' ',' | sed -e 's/,/, /g;' | perl -lne 'chop $_; chop $_; print "colnames(alldata) <- c(\"target_id\", \"length\", $_)\n";' >> mergescript.R
perl -e 'print "write.table (alldata, file=\"alltotalxprs.tsv\", row.names=FALSE, col.names=TRUE, quote=FALSE, sep=\"\\t\")\n";' >> mergescript.R

# run merger Rscript
nohup sh -c 'Rscript mergescript.R' > mergescript-R-$(date '+%Y-%m-%d-%T').txt

# erase temp files
rm mergescript.R *.short trlen.tmp

