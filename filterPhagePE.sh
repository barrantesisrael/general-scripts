#!/bin/bash
# filterPhagePE.sh -- filters out the Illumina phage phiX sequences from paired end FASTQs
# USAGE filterPhagePE.sh reads1prefix reads2prefix
# 2015-10-29 isradelacon@gmail.com

# variables -- input FASTQs
fwd=$1
rev=$2
echo "filtering start $(date)"

# requires bowtie2 and bowtie2 formatted PhiX
# e.g. $ time nohup sh -c 'bowtie2-build phix.fasta phix' > bowtie2build-phix-$(date '+%Y-%m-%d-%T').txt &
# source https://github.com/MadsAlbertsen/16S-analysis/blob/master/data.generation/16S.V13.workflow_v2.0.sh
# omit 'reorder' because we will not use the SAM output
bowtie2 --version | head -n 1
bowtie2 -x /home/barrantes/data/phagex/phix -1 $fwd.scythe.fastq -2 $rev.scythe.fastq -S phixpos.sam --un-conc nophix --al-conc phixpos -p 40
rm -rf phixpos.*
mv nophix.1 $fwd.nophix.fastq
mv nophix.2 $rev.nophix.fastq

### following lines are from the older version
# mapping and output unmapped
# echo "filtering start $(date)"
# STAR --runThreadN 24 --outReadsUnmapped Fastx --alignEndsType EndToEnd --alignIntronMax 1 --alignIntronMin 2 --scoreDelOpen -10000 --scoreInsOpen -10000 --outFilterMultimapNmax 100 --outFilterMismatchNoverLmax 0.1 --genomeDir /home/barrantes/data/phagex/GenomeDir/ --outFileNamePrefix $_.nophix --readFilesIn $fwd $rev
# renaming output files and erasing temporary
# rename 's/.nophixUnmapped.out.mate1/.nophix.fastq/' *.mate1
# tar czf map-$(date '+%Y-%m-%d').tar.gz *.tab *.out --remove-files
# rm -rf *.sam
echo "filtering complete $(date)"

