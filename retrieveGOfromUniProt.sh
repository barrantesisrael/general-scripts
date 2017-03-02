#!/bin/bash
# retrieveGOfromUniProt.sh
# usage retrieveGOfromUniProt.sh <accession>
# 2014-05-20 isradelacon@gmail.com
export value=$1
wget -q http://www.uniprot.org/uniprot/$value.txt
mv $value.txt $value.temp.txt
cat $value.temp.txt | grep "GO;" | perl -lne 'print $ENV{value}."\t".$_;'
rm $value.temp.txt
unset value
