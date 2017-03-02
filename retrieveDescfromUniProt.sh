# retrieveDescfromUniProt.sh
# usage retrieveGOfromUniProt.sh <accession>
# 2014-11-25 isradelacon@gmail.com
export value=$1
wget -q http://www.uniprot.org/uniprot/$value.txt
mv $value.txt $value.temp.txt
cat $value.temp.txt | grep "DE   RecName: " | sed 's/DE   RecName: //; s/Full=//;' | perl -lne 'print $ENV{value}."\t".$_;'
rm $value.temp.txt
unset value

