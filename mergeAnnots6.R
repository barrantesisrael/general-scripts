#! /usr/bin/env Rscript
# mergeAnnots6.R -- merges outputs from blast2go, blast (uniprot + cogs) and interproscan (pfam)
# version 6, works with annotate6.sh
# usage mergeAnnots6.R prefix
# 2014-03-11 isradelacon@gmail.com

nameprefix <-commandArgs(TRUE)

go1 <- read.csv(paste(nameprefix[1],".go.tsv", sep=""), header=TRUE, sep="\t")
uniprot1 <- read.csv(paste(nameprefix[1],".uniprot.tsv", sep=""), header=TRUE, sep="\t")
# refseq1 <- read.csv(paste(nameprefix[1],".refseq.tsv", sep=""), header=TRUE, sep="\t")
pfam1 <- read.csv(paste(nameprefix[1],".pfam.tsv", sep=""), header=TRUE, sep="\t")
cogs1 <- read.csv(paste(nameprefix[1],".cog.tsv", sep=""), header=TRUE, sep="\t")

de1 <- merge(go1, uniprot1, by="geneid", all=TRUE)
# de2 <- merge(de1, refseq1, by="geneid", all=TRUE)
de3 <- merge(de1, pfam1, by="geneid", all=TRUE)
de4 <- merge(de3, cogs1, by="geneid", all=TRUE)

outfile <- paste(nameprefix[1],".merged.tsv", sep="")
write.table(de4, file=outfile, row.names=FALSE, col.names=TRUE, quote=FALSE, sep="\t")

