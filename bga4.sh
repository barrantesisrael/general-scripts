#!/usr/bin/env bash
# bga4.sh -- bacterial genome assembly, annotation and QC
# USAGE bga4.sh $forwardfastq $reversefastq $outprefix
# 2015-11-17 version 4.027 isradelacon@gmail.com
#

# exit on error
set -e

# check for all parameters
if [ $# -lt 3 ]; then
  echo "Usage: $0 forwardfastq reversefastq outputprefix"
  exit 1
fi

# variables
echo "START $(date)"
forward=$1
reverse=$2
outprefix=$3

# temporary dir where all intermediate FASTQs will be deposited
mkdir $outprefix.fastqs

# adapter removal, forward and reverse
echo "adapter removal, forward and reverse START $(date)"
# update 2015-10-29 using /home/barrantes/data/contaminant_list.fa
# version 1.003 used /home/barrantes/data/illumina_adapters.fa
scythe --quiet -a /home/barrantes/data/contaminant_list.fa -o $outprefix.fastqs/trimfwd1.fastq $forward 
scythe --quiet -a /home/barrantes/data/contaminant_list.fa -o $outprefix.fastqs/trimrev1.fastq $reverse 
echo

# phiX filtering
echo "phiX filtering START $(date)"
# filterPhagePE.sh $outprefix.fastqs/trimfwd1 $outprefix.fastqs/trimrev1
# requires bowtie2 and bowtie2 formatted PhiX
# source https://github.com/MadsAlbertsen/16S-analysis/blob/master/data.generation/16S.V13.workflow_v2.0.sh
bowtie2 -x /home/barrantes/data/phagex/phix -1 $outprefix.fastqs/trimfwd1.fastq -2 $outprefix.fastqs/trimrev1.fastq -S phixpos.sam --un-conc nophix --al-conc phixpos -p 40
rm -rf phixpos.*
mv nophix.1 $outprefix.fastqs/trimfwd1.nophix.fastq
mv nophix.2 $outprefix.fastqs/trimrev1.nophix.fastq
echo

# quality filtering
echo "quality filtering START $(date)"
sickle pe --qual-type sanger -f $outprefix.fastqs/trimfwd1.nophix.fastq -r $outprefix.fastqs/trimrev1.nophix.fastq -o $outprefix.fastqs/trimfwd2.fastq -p $outprefix.fastqs/trimrev2.fastq -s $outprefix.fastqs/single.fastq
echo

# QC of filtered fastqs --outputs in $outprefix.fastqc
echo "QC of filtered fastqs START $(date)"
fastqc --quiet --noextract --contaminants /home/barrantes/data/contaminant_list.txt $forward
fastqc --quiet --noextract --contaminants /home/barrantes/data/contaminant_list.txt $reverse
for file in trimfwd1 trimrev1 trimfwd1.nophix trimrev1.nophix trimfwd2 trimrev2 single ; do 
 fastqc --quiet --noextract --contaminants /home/barrantes/data/contaminant_list.txt $outprefix.fastqs/$file.fastq; 
done
mkdir $outprefix.fastqc
mv *_fastqc.zip $outprefix.fastqc
mv $outprefix.fastqs/*_fastqc.zip $outprefix.fastqc
echo

# FASTQ, reads, bases, unique reads, most abundant unique, most abundant unique count
echo "FASTQ stats START $(date)"
for file in $forward $reverse; do
  echo $file; \
  reads $file | xargs printf "%'.f\n"; \
  fastqbases $file | sed 's/total bases //g;'; \
  fastqstats.sh $file | tr " " \\t | cut -f3-5; \
done | paste - - - - >> $outprefix.fastqstats.tsv;

for file in $outprefix.fastqs/*.fastq; do
  echo $file; \
  reads $file | xargs printf "%'.f\n"; \
  fastqbases $file | sed 's/total bases //g;'; \
  fastqstats.sh $file | tr " " \\t | cut -f3-5; \
done | paste - - - - >> $outprefix.fastqstats.tsv;
echo

# assembly --outputs in $outprefix.spades
echo "spades assembly START $(date)"
time spades.py -1 $outprefix.fastqs/trimfwd2.fastq -2 $outprefix.fastqs/trimrev2.fastq -s $outprefix.fastqs/single.fastq -o $outprefix.spades
echo

# gene identification --outputs in $outprefix.prokka
echo "prokka annotation START $(date)"
ln -s $outprefix.spades/scaffolds.fasta $outprefix.scaffolds.fna
ln -s $outprefix.spades/contigs.fasta $outprefix.contigs.fna
time prokka --quiet --compliant --cpus 16 --force --outdir $outprefix.prokka $outprefix.scaffolds.fna
echo

# add also circleator plot
# e.g. circleator --data=infile.gbk --config=infile.conf --pad=500 > infile.svg


