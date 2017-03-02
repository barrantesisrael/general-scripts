#! /usr/bin/env Rscript
# fastaMeanLength.R -- Mean Length Of Fasta Sequences
#
# USAGE Rscript fastaMeanLength.R path/to/fasta/file
# requires library(seqinr)
# 2015-03-20 isradelacon@gmail.com
# modified from: https://www.biostars.org/p/1758/#1773
library(seqinr, quietly = TRUE)
fasta <- read.fasta(commandArgs(trailingOnly = T))
mean(sapply(fasta, length))

