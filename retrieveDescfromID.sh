#!/bin/bash
# retrieveDescfromID.sh
# usage retrieveDescfromID.sh <accession>
# 2014-06-03 isradelacon@gmail.com

# use with 'export value' when extracting just one record
# export value=$1
# use for loop when running multiple records e.g. sed and xargs

for value in "$@"
do echo -ne $value; curl -s "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?id=$value&db=nuccore&retmode=xml" | grep "definition" | sed -e "s/GBSeq_definition>//g; s/<//g; s/\///g";
done
