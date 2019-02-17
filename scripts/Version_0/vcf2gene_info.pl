#!/usr/bin/perl -w
use strict;

## Input files
my $gene_lookup = $ARGV[0]; ## in the ../data folder
my $infile = $ARGV[1];      ## VCF output form lofreq

## Global variables
my $header_flag = 1; ## flag to let us know when the header part of VCF is done
my %GeneLookup;      ## 2-dimensional dictionary, holds the contents of the gene_table file

## Open the gene_table file
open(IN,"<$gene_lookup") || die "\n Cannot open the file: $gene_lookup\n";
while(<IN>) {
    chomp;
    unless ($_ =~ m/^#/) {
	my @a = split(/\t/, $_);
	if (exists $GeneLookup{$a[1]}{'1'}) { ## if we've seen this gene before
	    for (my $i=$a[3]; $i<= $a[4]; $i++) {
		$GeneLookup{$a[1]}{$i} = $GeneLookup{$a[1]}{$i} . "," . $a[0]; ## append the other gene that is also located at this spot
	    }
	}
	else { ## if we've not seen this gene yet
	    for (my $i=1; $i<= $a[2]; $i++) { ## we're initializing the 2D dictionary and setting all positions to "non-coding"
		$GeneLookup{$a[1]}{$i} = "non-coding";
	    }
	    for (my $i=$a[3]; $i<= $a[4]; $i++) { ## Next, we're writing over the "non-coding" bases with the gene name for its coordinates
		$GeneLookup{$a[1]}{$i} = $a[0];
	    }
	}
    }
}
close(IN);

## Open the VCF file
open(IN,"<$infile") || die "\n Cannot open the file: $infile\n";
while(<IN>) {
    chomp;
    if ($_ =~ m/^#CHROM/) {
	$header_flag = 0; ## This is the last line of the header information
	print $_ . "\n"; ## print the line to the screen
    }
    elsif ($header_flag == 0) {
	my @a = split(/\t/, $_); ## split the line on tabs and read it into an array
	$a[2] = $GeneLookup{$a[0]}{$a[1]}; ## replace the 3rd element in the array with the name of the gene for that segment at that base
	print join("\t", @a) . "\n"; ## print out the array, separating each element by a tab
    }
}
close(IN);

exit 0;
