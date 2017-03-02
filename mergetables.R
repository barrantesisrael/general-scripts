#!/usr/bin/env Rscript
# mergetables.R -- merges two tables by a given column name
# USAGE mergetables.R infile1 infile2 colname outfile
# 2016-01-20 isradelacon@gmail.com

args <-commandArgs(TRUE)

if (length(args) != 4) {
  	stop("USAGE: mergetables.R infile1 infile2 colname outfile", call.=FALSE)
} else {
	# open input file(s)
	table1 <- read.csv(args[1], header=TRUE, sep="\t")
	table2 <- read.csv(args[2], header=TRUE, sep="\t")
	# merge tables
	de1 <- merge(table1, table2, by=args[3], all=TRUE)
	# save merged into output file
	write.table(de1, file=args[4], row.names=FALSE, col.names=TRUE, quote=FALSE, sep="\t")
}

