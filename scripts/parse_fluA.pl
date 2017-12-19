#!/usr/bin/perl -w
use strict;

my $infile = $ARGV[0];
my $print_flag = 0;

open(IN,"<$infile") || die "\n Cannot open the file: $infile\n";
while(<IN>) {
    chomp;
    if ($_ =~ m/^>/) {
	$print_flag = 0;
	if ($_ =~ m/influenza A/i) {
	    print $_ . "\n";
	    $print_flag = 1;
	}
    }
    elsif ($print_flag == 1) {
	print $_ . "\n";
    }
}
close(IN);

exit 0;
