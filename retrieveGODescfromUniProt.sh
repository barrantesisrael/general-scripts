#!/bin/bash
# retrieveGODescfromUniProt.sh
# usage retrieveGODescfromUniProt.sh <accession>
# 2014-11-25 isradelacon@gmail.com

export value=$1
wget -q http://www.uniprot.org/uniprot/$value.txt
mv $value.txt $value.temp.txt
cat $value.temp.txt | perl -lne 'if (/DE   RecName: /) {
                $_ =~ s/DE   RecName: //;
                $_ =~ s/Full=//;
                $_ =~ s/;//;
                $desc = $_;}
elsif (/GO;/) {
		$_ =~ s/DR   GO;//; 
		$_ =~ s/; /\t/;
                print $ENV{value}."\t".$desc."\t".$_;}'
rm $value.temp.txt
unset value

