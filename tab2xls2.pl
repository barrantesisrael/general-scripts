#!/usr/bin/perl -w
# tab2xls.pl -- converts a tab separated file into an Excel file
# Usage: tab2xls.pl tabfile.txt newfile.xls
# modified from https://raw.githubusercontent.com/jmcnamara/spreadsheet-writeexcel/master/examples/tab2xls.pl
# 2015-04-08 isradelacon@gmail.com

use strict;
use Spreadsheet::WriteExcel;


# Check for valid number of arguments
if (($#ARGV < 1) || ($#ARGV > 2)) {
    die("Usage: tab2xls tabfile.txt newfile.xls\n");
};


# Open the tab delimited file
open (TABFILE, $ARGV[0]) or die "$ARGV[0]: $!";


# Create a new Excel workbook
my $workbook  = Spreadsheet::WriteExcel->new($ARGV[1]);
# Modification: create a new Excel workbook with filename
my $worksheet = $workbook->add_worksheet($ARGV[0]);

# Row and column are zero indexed
my $row = 0;

while (<TABFILE>) {
    chomp;
    # Split on single tab
    my @Fld = split('\t', $_);

    my $col = 0;
    foreach my $token (@Fld) {
        $worksheet->write($row, $col, $token);
        $col++;
    }
    $row++;
}
