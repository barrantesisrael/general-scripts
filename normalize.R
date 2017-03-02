#!/usr/bin/env Rscript
# normalize.R -- gets nonzero tables, as well as TPM and RPK calculations
# USAGE normalize.R counts.tsv start-counts-column outprefix
# where "start-counts-column" is the first column with mapped read counts 
# and the transcript length should be the preceding
# 2015-12-17 isradelacon@gmail.com
#
# data input
args<-commandArgs(TRUE)
# test if arguments correct
# if (length(args)==3) {
#  stop("USAGE: normalize.R counts.tsv start-counts-column outprefix", call.=FALSE)
#  q(save="no")
#}
countdata <- read.csv(args[1], header=TRUE, sep="\t")
startcol <- as.numeric(args[2])
outprefix <- args[3]
lengthcol <- startcol - 1 
# function def
countToTpm <- function(counts, effLen){
	rate <- log(counts) - log(effLen)
	denom <- log(sum(exp(rate)))
	exp(rate - denom + log(1e6))
}
# calculations
countdata.short <- countdata[,c(startcol:ncol(countdata))]
rownames(countdata.short) <-countdata[,c(1)]
df <- c()
dat_x <- countdata[,c(lengthcol)]
dat_y <- countdata.short
for(i in names(dat_y)){
	y <- dat_y[i]
	df <- cbind (df, as.matrix(countToTpm (y, dat_x) ))
	}
countdataTPM <- cbind ( countdata[,c(1:lengthcol)], df )
countdataRPK <- 1000 * ( dat_y / dat_x )
countdataRPK <- cbind ( countdata[,c(1:lengthcol)], countdataRPK )
countdata.nonzero <- countdata[!!rowSums(abs(countdata[-c(1:lengthcol)])),]
countdataTPM.nonzero <- countdataTPM[!!rowSums(abs(countdataTPM[-c(1:lengthcol)])),]
countdataRPK.nonzero <- countdataRPK[!!rowSums(abs(countdataRPK[-c(1:lengthcol)])),]
# saving outputs
write.table(countdata, file=paste(outprefix,"_counts.tsv",sep=""), row.names=F, col.names=T, quote=F, sep="\t")
write.table(countdataTPM, file=paste(outprefix,"_TPM.tsv",sep=""), row.names=F, col.names=T, quote=F, sep="\t")
write.table(countdataRPK, file=paste(outprefix,"_RPK.tsv",sep=""), row.names=F, col.names=T, quote=F, sep="\t")
write.table(countdata.nonzero, file=paste(outprefix,"_nonzero_counts.tsv",sep=""), row.names=F, col.names=T, quote=F, sep="\t")
write.table(countdataTPM.nonzero, file=paste(outprefix,"_nonzero_TPM.tsv",sep=""), row.names=F, col.names=T, quote=F, sep="\t")
write.table(countdataRPK.nonzero, file=paste(outprefix,"_nonzero_RPK.tsv",sep=""), row.names=F, col.names=T, quote=F, sep="\t")
# save.image("humanmappings-20151028-01.RData")
# savehistory("humanmappings-20151028-01.Rhistory")
#
