#!/usr/bin/perl
# countcogs.pl -- Counts COG general categories and subcategories 
# USAGE countcogs.pl inputfile
# 2015-04-16 isradelacon@gmail.com

# UPDATE 2016-02-15
# how to generate inputfile *correctly*
# $ tail -n+2 D2001.proteins.annots.tsv | cut -f7 | grep -v NA | xargs -I % grep % ~/data/cognames2003-2014.tab | cut -f2 | fold -s1 > inputfile
# "tail -n+2" omits the headers; "grep -v NA" omits those without COGs;
# "cut -f2" leaves only the COG category; "fold -s1" keeps only one character per line.

# incorrect (old) manner:
# $ cut -f7  Sho03102015.merged.tsv | xargs -I % grep % ~/data/cognames2003-2014.tab | cut -f2 | fold -s1 > t3

# counts in subcategories
while (<>) {
if (/J/) {$J++}
elsif (/A/) {$A++}
elsif (/K/) {$K++}
elsif (/L/) {$L++}
elsif (/B/) {$B++}
elsif (/D/) {$D++}
elsif (/Y/) {$Y++}
elsif (/V/) {$V++}
elsif (/T/) {$T++}
elsif (/M/) {$M++}
elsif (/N/) {$N++}
elsif (/Z/) {$Z++}
elsif (/W/) {$W++}
elsif (/U/) {$U++}
elsif (/O/) {$O++}
elsif (/X/) {$X++}
elsif (/C/) {$C++}
elsif (/G/) {$G++}
elsif (/E/) {$E++}
elsif (/F/) {$F++}
elsif (/H/) {$H++}
elsif (/I/) {$I++}
elsif (/P/) {$P++}
elsif (/Q/) {$Q++}
elsif (/R/) {$R++}
elsif (/S/) {$S++}
else {next;}
}

# counts in general categories
$inf = $J+$A+$K+$L+$B;
$cel = $D+$Y+$V+$T+$M+$N+$Z+$W+$U+$O+$X;
$met = $C+$G+$E+$F+$H+$I+$P+$Q;
$poo = $R + $S;

# COG categories source ftp://ftp.ncbi.nih.gov/pub/COG/COG/fun.txt
# COG subcategories update ftp://ftp.ncbi.nih.gov/pub/COG/COG2014/data/fun2003-2014.tab

# output to STOUT
print "INFORMATION STORAGE AND PROCESSING\t".$inf."\n".
"Translation, ribosomal structure and biogenesis\t".$J."\n".
"RNA processing and modification\t".$A."\n".
"Transcription\t".$K."\n".
"Replication, recombination and repair\t".$L."\n".
"Chromatin structure and dynamics\t".$B."\n".
"CELLULAR PROCESSES AND SIGNALING\t".$cel."\n".
"Cell cycle control, cell division, chromosome partitioning\t".$D."\n".
"Nuclear structure\t".$Y."\n".
"Defense mechanisms\t".$V."\n".
"Signal transduction mechanisms\t".$T."\n".
"Cell wall/membrane/envelope biogenesis\t".$M."\n".
"Cell motility\t".$N."\n".
"Cytoskeleton\t".$Z."\n".
"Extracellular structures\t".$W."\n".
"Intracellular trafficking, secretion, and vesicular transport\t".$U."\n".
"Posttranslational modification, protein turnover, chaperones\t".$O."\n".
"Mobilome: prophages, transposons\t".$X."\n".
"METABOLISM\t".$met."\n".
"Energy production and conversion\t".$C."\n".
"Carbohydrate transport and metabolism\t".$G."\n".
"Amino acid transport and metabolism\t".$E."\n".
"Nucleotide transport and metabolism\t".$F."\n".
"Coenzyme transport and metabolism\t".$H."\n".
"Lipid transport and metabolism\t".$I."\n".
"Inorganic ion transport and metabolism\t".$P."\n".
"Secondary metabolites biosynthesis, transport and catabolism\t".$Q."\n".
"POORLY CHARACTERIZED\t".$poo."\n".
"General function prediction only\t".$R."\n".
"Function unknown\t".$S."\n";


