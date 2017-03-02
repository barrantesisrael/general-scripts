#!/usr/bin/perl
# gotermM2S.pl -- converts blast2go annot file into a single line version
# modified from annot2go.pl
# usage: gotermM2S.pl GOtermsMulti.tsv > GOtermsSingle.tsv
# 2015-04-15 isradelacon@gmail.com

# example of how to generate input
# $ tail -n+2 Sho03102015.merged.tsv | cut -f1,3 | grep -v "NA" | perl -F'\t' -lane '@goids = split /\, /, $F[1]; 
# foreach (@goids){$cmd = "grep \"$_\" GO.terms_alt_ids.short \| cut \-f2"; my $value = qx($cmd); chomp $value; print $F[0]."\t".$_."\t".$value}' | cut -f1,3 > g1

while (<>) {
$counter++;
chomp;
# original without $desc
($name,$goterm)=split/\t/,$_;
if ($name eq $name0) {
# original "\t$goterm"
print "; $goterm";
}else{
# original added blank first line
if ($counter > 1){print "\n$name\t$goterm";}
else {print "$name\t$goterm"}
}
$name0=$name;
}
print "\n";


