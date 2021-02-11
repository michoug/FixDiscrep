#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use File::Slurp;

my $file = read_file("$ARGV[0]");

my $file_name = $ARGV[0];
$file_name =~ s/\..*//;

if($file !~ /Discrepancy Report Results/){
	print "Please use a discrepany report: $ARGV[0]!!\n";
	exit 0;
}

my @bulk = split "\n\n", $file;

if($bulk[1] !~ /SUSPECT/ && $bulk[1] !~ /FATAL/){
	print "$file_name\tAll is good with this file!!\n";
	exit 0;
}
else{
	#print $bulk[3]."\n";
	$bulk[3] =~ s/COUNT_NUCLEOTIDES.*?SOURCE_QUALS.*present\n//gs;
	$bulk[3] =~ s/FEATURE_LIST.*//gs;
	$bulk[3] =~ s/^/$file_name\t/g;
	$bulk[3] =~ s/\n$//g;
	$bulk[3] =~ s/\n/\n$file_name\t/g;
	print $bulk[3]."\n";
}


