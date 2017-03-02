#!/usr/bin/perl
# refseq2go.pl -- obtains gene ontologies associated to a RefSeq id
# USAGE: refseq2go.pl infile|refseqid
# modified from http://davetang.org/wiki/tiki-index.php?page=refseq2go.pl
# 2015-05-21 isradelacon@gmail.com

# Prior to running the script, you need to download these two files:
# ftp://ftp.ncbi.nih.gov/gene/DATA/gene2refseq.gz(external link)
# ftp://ftp.ncbi.nih.gov/gene/DATA/gene2go.gz(external link)
# The script takes single RefSeq IDs or a file containing only RefSeq IDs (with no 
# version information i.e. NM_123456.3 take away the .3) and outputs the GO terms 
# associated with that RefSeq if any.

use strict;
use warnings;

my $usage = "Usage $0 <infile|refseq>\n";
my $in= shift or die $usage;

my %list = ();
if (-f $in){
   open(IN,'<',$in) || die "Could not open $in: $!\n";
   while(<IN>){
      chomp;
      $list{$_} = '1';
   }
   close(IN);
} else {
   $list{$in} = '1';
}

#Format: tax_id GeneID status RNA_nucleotide_accession.version RNA_nucleotide_gi protein_accession.version protein_gi genomic_nucleotide_accession.version genomic_nucleotide_gi start_position_on_the_genomic_accession end_position_on_the_genomic_accession orientation assembly (tab is used as a separator, pound sign - start of a comment)
#9       1246500 PROVISIONAL     -       -       NP_047184.1     10954455        NC_001911.1     10954454        348     1190    -       -

my %gene2refseq = ();
# next original line
# my $gene2refseq = 'gene2refseq';
# next modified line 2015-05-21
my $gene2refseq = '/home/barrantes/data/gene2refseq';

open(IN,'<',$gene2refseq) || die "Could not open $gene2refseq: $!\n";
while(<IN>){
   chomp;
   next if (/^#/);
   my ($tax_id,$gene_id,$status,$rna_nucl_acc,$rna_nucl_gi,$prot_acc,$prot_gi,$gen_nuc_acc,$gen_nuc_gi,$start,$end,$strand,$assembly) = split(/\t/);
   next unless $tax_id == '9606';
   $rna_nucl_acc =~ s/\.\d+$//;
   next unless exists $list{$rna_nucl_acc};
   if (exists $gene2refseq{$rna_nucl_acc}){
      if ($gene2refseq{$gene_id} ne $rna_nucl_acc){
         warn("RefSeq $rna_nucl_acc has conflicting gene id $gene_id\n");
      } else {
         next;
      }
   } else {
      $gene2refseq{$gene_id} = $rna_nucl_acc;
   }
   #print "$rna_nucl_acc,$gene_id\n";
}
close(IN);

# next original line
# my $gene2go = 'gene2go';
# next modified line 2015-05-21
my $gene2go = '/home/barrantes/data/gene2go';

open(IN,'<',$gene2go) || die "Could not open $gene2go: $!\n";
while(<IN>){
   chomp;
   #Format: tax_id GeneID GO_ID Evidence Qualifier GO_term PubMed Category (tab is used as a separator, pound sign - start of a comment)
   #3702    814629  GO:0003676      IEA     -       nucleic acid binding    -       Function
   next if (/^#/);
   my ($tax_id,$gene_id,$go_id,$evidence,$qualifier,$go_term,$pubmed,$category) = split(/\t/);
   next unless $tax_id == '9606';
   next unless exists $gene2refseq{$gene_id};
   print join ("\t",$gene2refseq{$gene_id},$tax_id,$gene_id,$go_id,$evidence,$qualifier,$go_term,$pubmed,$category),"\n";
}
close(IN);

exit(0);
