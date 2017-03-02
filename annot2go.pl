#!/usr/bin/perl
# annot2go -- converts blast2go annot file into a single line version
# modified from http://seqanswers.com/forums/showthread.php?t=20195
# usage annot2go.pl annotfile > outfile
# 2014-08-29 isradelacon@gmail.com

while (<>) {
$counter++;
chomp;
# original without $desc
($name,$go,$desc)=split/\t/,$_;
if ($name eq $name0) {
# original "\t$go"
print ", $go";
}else{
# original added blank first line
if ($counter > 1){print "\n$name\t$desc\t$go";}
else {print "$name\t$desc\t$go"}
}
$name0=$name;
}
print "\n";
