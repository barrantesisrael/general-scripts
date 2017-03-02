#!/bin/bash
# annotate6.sh 
# usage annotate5.sh prefix
# where prefix is a protein fasta file with the '.faa' extension
#
# WARNING erase non sequence symbols, e.g. asterisks from the protein sequence before running this wrapper
# 2015-03-11 isradelacon@gmail.com

fastaprefix=$1
databasedir=/home/barrantes/data

# uniprot search
# -outfmt 5 = XML Blast output
echo uniprot
time blastp -query $fastaprefix.faa -db $databasedir/uniprot_sprot.fasta -evalue 1e-6 -max_target_seqs 10 -outfmt 5 -out $fastaprefix.uniprot.blastp.1e6.max10 -num_threads 32
# using 1E2 as indicated on CDD README (accessed 2015-02-19)
# ftp://ftp.ncbi.nih.gov/pub/mmdb/cdd/README
# -outfmt 6 = tabular
echo cogs
time rpsblast -query $fastaprefix.faa -db $databasedir/cogs/Cog -seg no -comp_based_stats 1 -evalue 0.01 -max_target_seqs 1 -outfmt 6 -out $fastaprefix.cog.rpsblast.1e2.max1 -num_threads 32
# interproscan
echo iprscan
time interproscan.sh --disable-precalc -appl PfamA --input $fastaprefix.faa --output-file-base $fastaprefix --formats xml,tsv --iprlookup --goterms --pathways
echo post_iprscan1
interproscan.sh -mode convert -f raw -i $fastaprefix.xml -b $fastaprefix
echo post_iprscan2
export IPRSCAN_HOME=/home/barrantes/installer/iprtemp/iprscan
echo ipr raw to xml 
# conversion needed because blast2go pipeline works only with old interproscan XML format
$IPRSCAN_HOME/bin/converter.pl -format xml -input $fastaprefix.raw -output $fastaprefix.iprscan.xml
echo post_iprscan3
gzip $fastaprefix.iprscan.xml
mkdir iprtemp
zcat $fastaprefix.iprscan.xml.gz | perl -lne '
    /<protein id="(.+?)"/ and open XML, ">iprtemp/$1.xml" and print XML "<EBIInterProScanResults><interpro_matches>";
    print XML;
    /<\/protein/ and print XML "</interpro_matches></EBIInterProScanResults>"'
echo blast2go
time doblast2go.sh $fastaprefix.uniprot.blastp.1e6.max10 $fastaprefix iprtemp
rm -rf iprtemp
# plotting inputs
echo "goslim input"
cat $fastaprefix.annot | cut -f1,2 > $fastaprefix.annot.gosliminput
echo "goslim output"
perl /home/barrantes/bin/goslimviewer.pl -i $fastaprefix.annot.gosliminput -s generic  -o $fastaprefix.annot.goslimoutput
echo "WEGO input"
annot2wego.pl $fastaprefix.annot > $fastaprefix.wegoinput
rm -rf iprtemp

# echo "annotation complete"
# call merger to complete

echo conversions
# blast outputs to simpler tsv
blastxml_to_top_descr.py -t 1 -o uniprot.tmp $fastaprefix.uniprot.blastp.1e6.max10
cat uniprot.tmp | grep -v "#" | sed -e 's/|/\t/g;' | cut -f1,5,6 > $fastaprefix.uniprot.tsv
# cat $fastaprefix.refseq.blastp.1e5.max1 | cut -f1,2 | sed -e 's/gi.*ref|//; s/|.*//;' > $fastaprefix.refseq.tsv
cat $fastaprefix.cog.rpsblast.1e2.max1 | cut -f1,2 | sed -e 's/gnl|CDD|//' | \
perl -F'\t' -lane 'my $cmdoutput = qx (grep \"$F[1]\" ~/data/cogs/cdd.versions);
chomp $cmdoutput; 
print "$F[0]\t$cmdoutput";' | tr -s " " | tr " " \\t | cut -f1,2,3 | sort -u > $fastaprefix.cog.tsv

# iprscan tsv to pfam tsv
cat $fastaprefix.tsv | cut -f1,5 > $fastaprefix.pfam.tmp
pfamM2S.pl $fastaprefix.pfam.tmp > $fastaprefix.pfam.tsv

# convert annot multi to single line per accession
annot2go.pl $fastaprefix.annot > $fastaprefix.go.tsv

# add headers for R
echo headers
sed -i '1igeneid\tannotdesc\tgo' $fastaprefix.go.tsv
# sed -i '1igeneid\trefseqid' $fastaprefix.refseq.tsv
sed -i '1igeneid\tuniprotid\tuniprotdesc' $fastaprefix.uniprot.tsv
sed -i '1igeneid\tpfam' $fastaprefix.pfam.tsv
sed -i '1igeneid\tcogacc\tcogdesc' $fastaprefix.cog.tsv

# merge annotations
echo merging annotations
mergeAnnots6.R $fastaprefix

# compress and clean temporary files
echo backups and cleaning up
tar czf $fastaprefix-annotate6sh.tar.gz *.tsv *.max1 *.max10 $fastaprefix.annot $fastaprefix.dat $fastaprefix.raw $fastaprefix.xml $fastaprefix.wegoinput $fastaprefix.annot.gosliminput $fastaprefix.annot.goslimoutput
rm *.tmp
cp $fastaprefix.merged.tsv $fastaprefix.merged.tmp
rm *.tsv *.max1 *.max10 $fastaprefix.annot $fastaprefix.dat $fastaprefix.raw $fastaprefix.xml 
# rm $fastaprefix.wegoinput $fastaprefix.annot.gosliminput
mv $fastaprefix.merged.tmp $fastaprefix.merged.tsv

echo "annotation and merger complete"

