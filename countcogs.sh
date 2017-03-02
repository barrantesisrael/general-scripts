#!/bin/bash
# countcogs.sh -- counts COG assignments on annotations (merged table from annotate6.sh)
# USAGE countcogs.sh annotation.merged.tsv
# requires "countcogs.pl" script on $PATH
# 2015-10-08 isradelacon@gmail.com

# generate input for counting script
cut -f7 $1 | xargs -I % grep % ~/data/cognames2003-2014.tab | cut -f2 | fold -s1 > tempfile
# count categories
countcogs.pl tempfile
# erase temporary
rm -rf tempfile

