#!/usr/bin/perl
# makeReadmeMd.pl -- Generates a README Markdown template for the current dir 
# USAGE makeReadmeMd.pl
# 2016-02-16 isradelacon@gmail.com

use Cwd;
use POSIX qw(strftime);

# source http://www.perlhowto.com/get_the_current_working_directory
# use Cwd; print cwd();
my $pwd = cwd();

# save current dir list
my $dirlist = qx (ls -1);
@lines = split /\n/, $dirlist;

# source http://www.tutorialspoint.com/perl/perl_date_time.htm
# use POSIX qw(strftime);
# or for GMT formatted appropriately for your locale:
# $datestring = strftime "%a %b %e %H:%M:%S %Y", gmtime;
# printf("date and time - $datestring\n"); 
# date and time - Sat Feb 16 14:10:23 2013
$datestring = strftime "%a %b %e %H:%M:%S %Y", gmtime;

# printing markdown content
print "## Directory $pwd  \n\n";
print "### $datestring <isradelacon\@gmail.com>  \n\n";
print "### Content  \n\n";
print; print "<insert description here>  \n\n";
print; print "### Files  \n\n";
print "name | type | size | MD5 | description  \n";
# print; print "Name | Description  \n";
print "-------------|----------|----------|----------|----------  \n";
# foreach (@lines) {
#        print "`".$_."`|\n";}
system ("getallmd5.sh");
print "  \n";
print; print "### Commands  \n\n";
print "```  \n\n";
print "```  \n\n";
print;

