#!/usr/bin/perl -w
use strict;

my $infile = $ARGV[0];
my %Headers;

open(IN,"<$infile") || die "\n Cannot open the file: $infile\n";
while(<IN>) {
    chomp;
    unless ($_ =~ m/^@/) {
	my @a = split(/\t/, $_);
	my $id = $a[0];
	my $seq = $a[9];
	my $cigar = $a[5];
	$Headers{$id}++;
	# print ">" . $id . "_" . $Headers{$id} . "\n" . $seq . "\n";
	if ($cigar =~ m/(\d+M)/) {
	    my $match = $1;
	    $match =~ s/M//g;
	    my $aln_seq = substr $seq, 0, $match;
	    print ">" . $id . "_" . $Headers{$id} . "\n" . $aln_seq . "\n";
	}
	else { die "\n Error this alignment contains no match in the CIGAR: $_\n"; }
    }
}
close(IN);

exit 0;
