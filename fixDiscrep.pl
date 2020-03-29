#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long 'HelpMessage';
use 5.010;
use File::Spec;
use Scalar::Util qw(looks_like_number);

my $input_folder = ".";
my $output_folder;
my $tbl2asnLocation = "tbl2asn";
my $asndiscLocation = "asndisc";


GetOptions(
    'in|i=s' => \$input_folder,
    'out|o=s' => \$output_folder,
	't=s' => \$tbl2asnLocation,
	'a=s' => \$asndiscLocation,
	'help|h'     =>   sub { HelpMessage(0) },
) or die "Usage: $0 -i INPUT_folder -o OUTPUT_folder\n" unless $input_folder and $output_folder;

HelpMessage(1) unless $output_folder;

=head1 NAME

license - get license texts at the command line!

=head1 USAGE       

        perl fixDiscrep.pl -i INPUT_folder -o OUTPUT_folder

  --in,-i		Input folder (Mandatory)
  --out,-o		Output folder (Mandatory)
  -t			Location of the tbl2asn program (Optional)
  -a			Location of the asndic folder (Optional)
  --help,-h		Print this help

=head1 VERSION

0.01

=cut
### Check the presence of the required softwares

# my $fp = find_exe("grep");
#say $tbl2asnLocation;
# my $tbl2asn = find_exe("tbl2asn") if $tbl2asnLocation == 0;
# my $asndisc = find_exe("asndisc") if $asndiscLocation == 0;
# say $fp;
# say $tbl2asn;
# say $asndisc;

say check_path($tbl2asnLocation);
say check_path($asndiscLocation);

my $temp = "Bin/asndoc";
say check_path($temp);

## Subroutines obtained from Prokka
sub find_exe {
  my($bin) = shift;
  for my $dir (File::Spec->path) {
    my $exe = File::Spec->catfile($dir, $bin);
    return $exe if -x $exe; 
  }
  return;
}


sub check_path{
  my ($loc) = shift;
  my $t = find_exe($loc);
  
  if(defined $t){
    return $t;
  }
  elsif($loc =~ /\//){
    if(-x $loc){
      return $loc;
    }
    else{
      return "Error, Cannot find $loc";
    }
  }
  else{
    return "Error, Cannot find $loc";
  }
}
