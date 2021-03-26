#!/usr/bin/env perl

use strict;
use warnings;
use 5.010;
use File::Slurp;
use List::Util qw(first);
use Bio::DB::Fasta;


my ($fsaFile_name, $contaminationFile_name) = @ARGV;

my $fsaFileOUT = $fsaFile_name;
$fsaFileOUT =~ s/\.fsa/_mod.fsa/;

my $db  = Bio::DB::Fasta->new($fsaFile_name);
my @ids = $db->get_all_primary_ids;
#my $seqout = Bio::SeqIO->new(-file => ">$fsaFileOUT", -format => "fasta");

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

open OUT, ">", $fsaFileOUT;

for my $j ( sort @ids){
	my $id = $j;
	$id =~ s/.*\|//;
	
	if(exists($hash{$id})){
		my @temp = split /\.\./, $hash{$id};
		my $length   = $db->length($j);
		my $newmin = 0;
		my $newmax = 0;
		# print $length."\n";
		if($hash{$id} !~ /,/){
			my $maxCont = $temp[1];
			my $minCont = $temp[0];

			if($maxCont < $minCont){
				my $t = $maxCont;
				my $z = $minCont;
				$minCont = $t;
				$maxCont = $z;
			}
			# print "$id\t$length\t$minCont\t$maxCont\n";
			if($minCont == 1){
				$maxCont += 1;
				# print "$id\t$maxCont\t$length\n";
				$newmin = $maxCont;
				$newmax = $length;
			}
			elsif($maxCont == $length){
				$minCont -= 1;
				# print "$id\t1\t$minCont\n";
				$newmin = 1;
				$newmax = $minCont;
			}
			else{
				if(($minCont - 1) > ($length - $maxCont)){
					#print "$id\tcloser to max\n";
					$minCont -= 1;
					my $diff = $length - $minCont;
					# print "$id\t1\t$minCont\n";
					$newmin = 1;
					$newmax = $minCont;
				}
				else{
					#print "$id\tcloser to min\n";
					$maxCont += 1;
					my $diff = $length - $maxCont;
					# print "$id\t$maxCont\t$length\n";
					$newmin = $maxCont;
					$newmax = $length;
				}
			}
		}
		else{
			my @abc = split /,/, $temp[1];
			my $minCont1 = $temp[0];
			my $maxCont2 = $temp[2];
			my $minCont2 = $abc[1];
			my $maxCont1 = $abc[0];

			# print "$id\t$minCont1\t$maxCont1\t$minCont2\t$maxCont2\n";
			$newmin = $maxCont1 + 1;
			$newmax = $minCont2 - 1;
		}
		# print "$j\t$newmin\t$newmax\n";
		my $seqstr   = $db->seq($j, $newmin => $newmax);
		my $desc = $db->header($j);
		print OUT ">$desc\n$seqstr\n";
	}
	else{
		my $seqstr   = $db->seq($j);
		my $desc = $db->header($j);
		print OUT ">$desc\n$seqstr\n";
	}

}

close OUT;