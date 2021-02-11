#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use File::Slurp;

my $file = $ARGV[0];
my $filename = $file;

$filename =~ s/\..*//;

open FILE, $file;
while(my $line =<FILE>){
	chomp $line;
	next if $line =~ /OrganismIsUndefinedSpecies/;
	print "$filename\t$line\n";
}

