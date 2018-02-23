#!/usr/bin/perl -w
use strict;

my ($seqs,$bases,$quals) = (0,0,0);

foreach my $infile(@ARGV) {
    my $line=0;
    open(IN,"<$infile") || die "\n Cannot open the file: $infile\n";
    while(<IN>) {
	chomp;
	if ($line == 3) { ## If on quality line
	    $seqs++;
	    $bases += length($_);
	    $quals += count_quality($_);
	    $line = -1;
	}
	$line++;
    }
    close(IN);
}

my $quality = $quals / $bases;
my $avgsize = $bases / $seqs;
$bases = $bases / 1000000000;
print join("\t", $bases, $quality, $avgsize) . "\n";

exit 0;

sub count_quality
{
    my $s = $_[0];
    my @a = split(//, $s);
    my $total = 0;
    foreach my $i (@a) {
	my $qv = ord($i) - 33;
	$total += probability($qv);
    }
    return $total;
}

sub probability
{
    my $s = $_[0];
    my $p = 1 - ( 1 / (10 ** ($s/10)));
    return $p;
}
