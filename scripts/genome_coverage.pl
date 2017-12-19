#!/usr/bin/perl -w

# MANUAL FOR genome_coverage.pl

=pod

=head1 NAME

genome_coverage.pl -- calculate what fraction of a genome is covered from a recruitment

=head1 SYNOPSIS

 genome_coverage.pl --genome=/Path/to/flu_refs.fasta --bam=/Path/to/sorted.bam
                     [--help] [--manual]

=head1 DESCRIPTION

 Calculate what fraction of a genome is covered from a recruitment. Must be a
 sorted BAM file.
 
=head1 OPTIONS

=over 3

=item B<-g, --genome>=FILENAME

Input file of reference genome(s) in FASTA format. (Required) 

=item B<-b, --bam>=FILENAME

Input file in sorted BAM format. (Required) 

=item B<-h, --help>

Displays the usage message.  (Optional) 

=item B<-m, --manual>

Displays full manual.  (Optional) 

=back

=head1 DEPENDENCIES

Requires the following Perl libraries.



=head1 AUTHOR

Written by Daniel Nasko, 
Center for Bioinformatics and Computational Biology, University of Maryland.

=head1 REPORTING BUGS

Report bugs to dnasko@umiacs.umd.edu

=head1 COPYRIGHT

Copyright 2017 Daniel Nasko.  
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.  
This is free software: you are free to change and redistribute it.  
There is NO WARRANTY, to the extent permitted by law.  

=cut


use strict;
use Getopt::Long;
use File::Basename;
use Pod::Usage;

#ARGUMENTS WITH NO DEFAULT
my($genome,$bam,$help,$manual);

GetOptions (	
				"g|genome=s"	=>	\$genome,
                                "b|bam=s"       =>      \$bam,
				"h|help"	=>	\$help,
				"m|manual"	=>	\$manual);

# VALIDATE ARGS
pod2usage(-verbose => 2)  if ($manual);
pod2usage( {-exitval => 0, -verbose => 2, -output => \*STDERR} )  if ($help);
pod2usage( -msg  => "\n\n ERROR!  Required argument --genome not found.\n\n", -exitval => 2, -verbose => 1)  if (! $genome );
pod2usage( -msg  => "\n\n ERROR!  Required argument --bam not found.\n\n", -exitval => 2, -verbose => 1)  if (! $bam );

my $genome_size = 0;
my $aligned_bases = 0;

open(IN,"<$genome") || die "\n Cannot open the file: $genome\n";
while(<IN>) {
    chomp;
    unless ($_ =~ m/^>/) {
	$genome_size += length($_);
    }
}
close(IN);

open(my $cmd, '-|', 'samtools', 'depth', $bam) or die $!;
while (my $line = <$cmd>) {
    chomp($line);
    $aligned_bases++;
}
close $cmd;

my $fraction = $aligned_bases / $genome_size;
print $fraction . "\n";

exit 0;
