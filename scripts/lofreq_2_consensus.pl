#!/usr/bin/perl -w
use strict;

my $fasta = $ARGV[0];
my $vcf = $ARGV[1];

my %Fasta;
my @Order;

my $h;
my $seq;
my $lc = 0;

open(IN,"<$fasta") || die "\n Cannot open the file: $fasta\n";
while(<IN>) {
    chomp;
    if ($_ =~ m/^>/) {
	if ($lc > 0) {
	    $Fasta{$h} = $seq;
	    $seq = "";
	}
	my $header = $_;
	$header =~ s/^>//;
	$h = $header;
	$h =~ s/ .*//;
	push(@Order, $h);
    }
    else {
	$seq = $seq . $_;
    }
    $lc++;
}
close(IN);
$Fasta{$h} = $seq;

open(IN,"<$vcf") || die "\n Cannot open the file: $vcf\n";
while(<IN>) {
    chomp;
    unless ($_ =~ m/^#/) {
	my @a = split(/\t/, $_);
	my $af = parse_af($a[-1]);
	if ($af > 0.5) {
	    my $pos = $a[1];
	    my $ref = $a[3];
	    my $alt = $a[4];
	    if (exists $Fasta{$a[0]}) {
		my @b = split(//, $Fasta{$a[0]});
		$b[$pos-1] = $alt;
		$Fasta{$a[0]} = join("", @b);
	    }
	    else { die "\n Cannot find this header: $a[0]\n"; }
	}
    }
}
close(IN);

for (my $i=0; $i<scalar(@Order); $i++) {
    my $seq = $i + 1;
    print ">Segment_" . $seq . "\n" . $Fasta{$Order[$i]} . "\n";
}

exit 0;

sub parse_af
{
    my $s = $_[0];
    $s =~ s/.*AF=//;
    $s =~ s/;.*//;
    return $s;
}
