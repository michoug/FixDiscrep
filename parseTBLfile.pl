#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use File::Slurp;
use List::Util qw(first);

my ($tblFile_name, $contaminationFile_name) = @ARGV;

my $tblFile = read_file($tblFile_name);
my $contaFile = read_file($contaminationFile_name);
my %hash;

$contaFile =~ s/.*apparent source\n//gs;
$contaFile =~ s/\n+$//gs;

my @cont = split /\n/, $contaFile;

for my $element (@cont){
	chomp $element;
	my @temp = split /\t/, $element;
	$hash{$temp[0]} = $temp[2];
}

$tblFile =~ s/\..*//;

my @sequence = split ">", $tblFile;


for my $i (@sequence){
	next if $i !~ /Feature/;
	my $id = $i;
	$id =~ s/Feature (.*?)\n.+/$1/gs;
	my $id_toCheck = $id;
	$id_toCheck =~ s/gnl\|BCL\|//g;
	
	
	$i =~ s/^Feature/>Feature/;

	#my $found = grep(/^$id_toCheck$/, @toRemove);
	#next if $found == 0; # replace by print "$i\n";

	next if(!exists($hash{$id_toCheck}));

	my @temp = split /\.\./, $hash{$id_toCheck};
	if($hash{$id_toCheck} !~ /,/){
		my $maxCont = $temp[1];
		my $minCont = $temp[0];

		if($maxCont < $minCont){
			my $t = $maxCont;
			my $z = $minCont;
			$minCont = $t;
			$maxCont = $z;
		}

		$i =~ s/\n\t\t\t/\t+++/g;

		my @line = split /\n/,$i;
		for my $j (@line){
			my $max;
			my $min;
			my $newmin;
			my $newmax;
			my $reverse;

			if ($j =~ /^>/){
				next;
			}
			my @columns = split /\t/, $j;
			my $first = shift @columns;
			my $second = shift @columns;

			if($first > $second){
				$max = $first;
				$min = $second;
				$reverse = 'T';
			}
			else{
				$max = $second;
				$min = $first;
				$reverse = 'F';
			}
			
			next if ($maxCont > $min && $min > $minCont);
			next if ($maxCont > $max && $max > $minCont);

			if($maxCont > $min){
				$newmax = $max;
				$newmin = $min;
			}
			elsif($min > $maxCont){
				$newmax = $max - $maxCont + $minCont;
				$newmin = $min - $maxCont + $minCont;
			}

			if($reverse eq 'F'){
				print "$minCont\t$maxCont\t$min\t$newmin\t$max\t$newmax\t@columns\n";
			}
			elsif($reverse eq 'T'){
				print "$minCont\t$maxCont\t$max\t$newmax\t$min\t$newmin\t@columns\n";
			}
		}
	}
	else{

		my @abc = split /,/, $temp[1];
		my $minCont1 = $temp[0];
		my $maxCont2 = $temp[2];
		my $minCont2 = $abc[1];
		my $maxCont1 = $abc[0];

		$i =~ s/\n\t\t\t/\t+++/g;

		my @line = split /\n/,$i;
		for my $j (@line){
			my $max;
			my $min;
			my $tempmin;
			my $tempmax;
			my $newmin;
			my $newmax;
			my $reverse;

			if ($j =~ /^>/){
				next;
			}
			my @columns = split /\t/, $j;
			my $first = shift @columns;
			my $second = shift @columns;

			if($first > $second){
				$max = $first;
				$min = $second;
				$reverse = 'T';
			}
			else{
				$max = $second;
				$min = $first;
				$reverse = 'F';
			}

			next if ($maxCont1 > $min && $min > $minCont1);
			next if ($maxCont1 > $max && $max > $minCont1);
			next if ($maxCont2 > $min && $min > $minCont2);
			next if ($maxCont2 > $max && $max > $minCont2);

			if($maxCont1 > $min){
				$tempmax = $max;
				$tempmin = $min;
			}
			elsif($min > $maxCont1){
				$tempmax = $max - $maxCont1 + $minCont1;
				$tempmin = $min - $maxCont1 + $minCont1;
			}
			
			if($maxCont2 > $min){
				$newmax = $tempmax;
				$newmin = $tempmin;
			}

			elsif($min > $maxCont2){
				$newmax = $tempmax - $maxCont2 + $minCont2;
				$newmin = $tempmin - $maxCont2 + $minCont2;
			}


			if($reverse eq 'F'){
				print "$minCont1\_$maxCont1\t$minCont2\_$maxCont2\t$min\t$newmin\t$max\t$newmax\t@columns\n";
			}
			elsif($reverse eq 'T'){
				print "$minCont1\_$maxCont1\t$minCont2\_$maxCont2\t$max\t$newmax\t$min\t$newmin\t@columns\n";
			}

		}
	}


}
