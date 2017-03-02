#!/bin/bash
# retrieveKOfromUniProt.sh
# usage retrieveKOfromUniProt.sh <accession>
# 2014-08-28 isradelacon@gmail.com
export value=$1

# use the next line when not using a proxy
# wget -q http://www.uniprot.org/uniprot/$value.txt
# use the next line with local proxy info
wget -e use_proxy=yes -e http_proxy=http://rzproxy.helmholtz-hzi.de:3128 -q http://www.uniprot.org/uniprot/$value.txt

mv $value.txt $value.temp.txt
cat $value.temp.txt | grep "KO;" | perl -lne 's/^.*KO\; //g; print $ENV{value}."\t".$_;'
rm $value.temp.txt
unset value
