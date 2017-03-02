#!/usr/bin/env Rscript
# rpkm.R -- calculates the Log2 RPKM from read counts
# USAGE: rpkm.R countsfile
#
# inputfile format: transcript_id, transcript_length, condition1counts, condition2counts, …, conditionNcounts
# inputfile must contain a header
# outputfile: countsfile.log2rpkm.tsv
# requires: edgeR (bioconductor)
#
# 2015-05-27 isradelacon@gmail.com

library(edgeR, quietly=TRUE)

args <- commandArgs(TRUE)
fname <- args[1]
readcounts <- read.csv(fname, header=TRUE, sep="\t")

readcounts.counts <- readcounts[,c(3:ncol(readcounts))]
rownames(readcounts.counts) <- readcounts[,c(1)]

# From the edgeR rpkm() documentation:
# "If log-values are computed, then a small count, given by prior.count but scaled to be 
# proportional to the library size, is added to x to avoid taking the log of zero"
readcounts.rpkm <- rpkm(readcounts.counts, readcounts[,c(2)], log=TRUE, prior.count=0.25)

readcounts.rpkm <- cbind(transcript_id = rownames(readcounts.rpkm), readcounts.rpkm)
rownames(readcounts.rpkm) <- NULL

outfile <- paste(fname,".log2rpkm.tsv", sep="")
write.table(readcounts.rpkm, file=outfile, row.names=FALSE, col.names=TRUE, quote=FALSE, sep="\t")

sessionInfo()
