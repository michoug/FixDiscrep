#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use File::Slurp;

while(my $line =<>){
	next if $line =~ /Falling back on built-in data for popular organisms./;
	next if $line =~ /Recognized annotation format: five-column feature table/;
	next if $line =~ /\/bin\/sh/;
	print "$line\n";
}
