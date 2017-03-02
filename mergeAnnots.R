#! /usr/bin/env Rscript
# mergeAnnots2.R -- merges outputs from blast2go, blast (uniprot + refseq) and interproscan (pfam)
# version 2, fixes bug with multiline iprscan output
# usage mergeAnnots.R prefix
# 2014-08-29 isradelacon@gmail.com

nameprefix <-commandArgs(TRUE)

go1 <- read.csv(paste(nameprefix[1],".go.tsv", sep=""), header=TRUE, sep="\t")
uniprot1 <- read.csv(paste(nameprefix[1],".uniprot.tsv", sep=""), header=TRUE, sep="\t")
refseq1 <- read.csv(paste(nameprefix[1],".refseq.tsv", sep=""), header=TRUE, sep="\t")
pfam1 <- read.csv(paste(nameprefix[1],".pfam.tsv", sep=""), header=TRUE, sep="\t")

de1 <- merge(go1, uniprot1, by="geneid", all=TRUE)
de2 <- merge(de1, refseq1, by="geneid", all=TRUE)
de3 <- merge(de2, pfam1, by="geneid", all=TRUE)

outfile <- paste(nameprefix[1],".merged.tsv", sep="")
write.table(de3, file=outfile, row.names=FALSE, col.names=TRUE, quote=FALSE, sep="\t")

