#!/usr/bin/perl -w
use strict;

my $vcf = $ARGV[0];
my @Results;

open(IN,"<$vcf") || die "\n Cannot open the file: $vcf\n";
while(<IN>) {
    chomp;
    unless ($_ =~ m/^#/) {
	my @a = split(/\t/, $_);
	my $af = parse_af($a[-1]);
	push(@Results,$af);
    }
}
close(IN);

print join(",", @Results) . "\n";
print STDERR scalar(@Results) . "\n";


exit 0;

sub parse_af
{
    my $s = $_[0];
    $s =~ s/.*AF=//;
    $s =~ s/;.*//;
    return $s;
}
