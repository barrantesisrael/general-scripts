#!/bin/bash
# Converts a GenBank file to GFF format using the togows API
# USAGE gbk2gff.sh inputfile
# source http://togows.org/help/
# 2016-10-05 isradelacon@gmail.com
inputfile=$1
wget --quiet http://togows.org/convert/genbank.gff --post-file=$inputfile
mv genbank.gff $inputfile.gff
