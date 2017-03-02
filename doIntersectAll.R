#!/usr/bin/env Rscript
# doIntersectAll.R -- intersections between multiple files from a pattern
# USAGE: doIntersectAll.R inputpattern outputfile
# 2016-01-26 isradelacon@gmail.com

args <-commandArgs(TRUE)

# load all files belonging to a pattern
temp = list.files(pattern=args[1])
for (i in 1:length(temp)) assign(temp[i], scan(temp[i], what="", sep="\n"))
# get intersection of all files
outfile <- Reduce(intersect, mget(temp))

# save output
write(outfile, args[2])
