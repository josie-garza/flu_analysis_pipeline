#!/usr/bin/perl -w
use strict;

foreach my $infile (@ARGV) {
    open(IN,"<$infile") || die "\n Cannot open the file: $infile\n";
    while(<IN>) {
	chomp;
	
    }
    close(IN);
}

exit 0;
