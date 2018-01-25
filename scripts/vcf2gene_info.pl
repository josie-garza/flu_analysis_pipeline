#!/usr/bin/perl -w
use strict;

my $gene_lookup = $ARGV[0];
my $infile = $ARGV[1];
my $header_flag = 1;

my %GeneLookup;
my @GeneOrder;
my %Sizes;
my %Results;

open(IN,"<$gene_lookup") || die "\n Cannot open the file: $gene_lookup\n";
while(<IN>) {
    chomp;
    unless ($_ =~ m/^#/) {
	my @a = split(/\t/, $_);
	push(@GeneOrder, $a[0]);
	if (exists $GeneLookup{$a[1]}{'1'}) {
	    for (my $i=$a[3]; $i<= $a[4]; $i++) {
		$GeneLookup{$a[1]}{$i} = $GeneLookup{$a[1]}{$i} . "," . $a[0];
		$Sizes{$a[0]}++;
	    }
	}
	else {
	    for (my $i=1; $i<= $a[2]; $i++) {
		$GeneLookup{$a[1]}{$i} = "non-coding";
		$Sizes{'non-coding'}++;
	    }
	    for (my $i=$a[3]; $i<= $a[4]; $i++) {
		$GeneLookup{$a[1]}{$i} = $a[0];
		$Sizes{'non-coding'}--;
		$Sizes{$a[0]}++;
	    }
	}
    }
}
close(IN);
push(@GeneOrder, "non-coding");

open(IN,"<$infile") || die "\n Cannot open the file: $infile\n";
while(<IN>) {
    chomp;
    if ($_ =~ m/^#CHROM/) {
	$header_flag = 0; ## This is the last line of the header information
	print $_ . "\n";
    }
    elsif ($header_flag == 0) {
	my @a = split(/\t/, $_);
	$a[2] = $GeneLookup{$a[0]}{$a[1]};
	print join("\t", @a) . "\n";
    }
}
close(IN);

exit 0;
