#!/bin/bash
# retrieveReffromGbk.sh
# usage retrieveReffromGbk.sh <accession>
# 2015-05-05 isradelacon@gmail.com

# use with 'export value' when extracting just one record
export value=$1
echo -ne "$value\t" 
wget --quiet --output-document=$value.tmp "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?id=$value&db=nuccore&rettype=gb&retmode=xml"
cat $value.tmp | perl -lne 'if (/GBAuthor/) {$gbauthor++; if ($gbauthor eq 1) {s/^.*<GBAuthor>//; s/<\/GBAuthor>.*//; $firstauthor = $_}}
elsif (/GBReference_title/) {$gbtitle++; if ($gbtitle eq 1) {s/^.*<GBReference_title>//; s/<\/GBReference_title>.*//; $articletitle = $_}}
elsif (/GBReference_journal/) {$gbjournal++; if ($gbjournal eq 1) {s/^.*<GBReference_journal>//; s/<\/GBReference_journal>.*//; $journalname = $_; print "$firstauthor\t$articletitle\t$journalname";}}'
rm $value.tmp

