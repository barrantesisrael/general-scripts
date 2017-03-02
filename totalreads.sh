#!/usr/bin/env bash
# totalreads.sh
# calculates the total number of reads of a FASTQ file
# 2015-04-28 isradelacon@gmail.com
wc -l $1 | cut -d' ' -f1 | awk '{reads = $1/4} END {print reads}' | xargs printf "%'d\n"

