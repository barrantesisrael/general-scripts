#!/usr/bin/env Rscript
# doDE.R -- differential expression with NOISeq and edgeR (no replicates)
# based on https://raw.githubusercontent.com/tfkhang/rnaseq/master/DEA/DEA.R
# ref Khang and Lau (2015) PeerJ, 3, e1360
# USAGE: doDE.R infile
# where "infile" is a 3-column table containing gene names and read counts (see below)
# output(s): "infile.edger.tsv" and "infile.noiseq.tsv"
# 2016-01-25 isradelacon@gmail.com

library(DESeq, quietly = TRUE)
library(NOISeq, quietly = TRUE)
library(edgeR, quietly = TRUE)

# value recommended on the edgeR manual:
# "0.1 for data on genetically identical model organisms"
# also from the Khang and Lau (2015) paper:
# "To handle analysis of unreplicated experiments in edgeR, we set the biological
# coefficient of variation (BCV) parameter as [...] 0.1 for the Bottomly data set, 
# following recommendations in Chen et al. (2015)."
bcv <- 0.1

# input table
args <-commandArgs(TRUE)

# exit if wrong input arguments
if (length(args) != 1) {
        stop("USAGE: doDE.R infile", call.=FALSE)
} else {

# input file format: tab- separated, headers present, e.g.
#
#                  target_id control treatment
# 1 transcript_00001        12344         8202
# 2 transcript_00002         1199         1484
# 3 transcript_00003         7159         3123
# 4 transcript_00004          678          696
# 5 transcript_00005         3898         4172
# 6 transcript_00006         1634         1042

readcounts <- read.csv(args[1], header=TRUE, sep="\t", stringsAsFactors = FALSE)
row.names(readcounts) <- readcounts[,1]
readcounts[,1] <- NULL
sampleset <- readcounts[,1:2]
setconditions <- c("control", "treatment")

# perform normalization by DESeq
cds <- newCountDataSet(sampleset,setconditions)
cds <- estimateSizeFactors(cds)

# omit genes which have no expression (value=0) across all the samples
cds@featureData@data <- cds@featureData@data[names(which(rowSums(counts(cds,normalized=TRUE))!=0)),]
counts(cds) <- counts(cds)[rownames(cds@featureData@data),]

# identify DE genes with NOISeq
noiseq.out <- noiseq(readData(counts(cds,normalized=TRUE),as.data.frame(conditions(cds))),norm="n",replicates="no",factor="conditions(cds)")
# using q=0.9 also from the Khang and Lau (2015) paper:
# "For NOISeq, we used the recommended criteria for calling DEG as described in
# the NOISeq documentation—q = 0.9 for unreplicated experiments, and q = 0.95 for
# experiments with biological replicates."
noiseq.deg <- rownames(degenes(noiseq.out,q=0.9))

# identify DE genes with edgeR
edger.out <- topTags(exactTest(DGEList(counts=counts(cds,normalized=TRUE),group=conditions(cds)),dispersion=bcv^2),n=Inf,adjust.method="none")
edger.deg <- rownames(edger.out$table)[-log10(edger.out$table$PValue)>=2/abs(edger.out$table$logFC)]

# output lists of DE genes
write.table(noiseq.deg, file=paste(args[1], ".noiseq.list", sep=""), row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")
write.table(edger.deg, file=paste(args[1], ".edger.list", sep=""), row.names=FALSE, col.names=FALSE, quote=FALSE, sep="\t")

}

