#!/usr/bin/perl -w

# MANUAL FOR extract_flu_genes.pl

=pod

=head1 NAME

extract_flu_genes.pl -- Extract a flu gene from a set of flu references

=head1 SYNOPSIS

 extract_flu_genes.pl --fasta=/Path/to/flu_refs.fasta --gene=hemagglutinin --out=/Path/to/genes.fasta
                     [--help] [--manual]

=head1 DESCRIPTION

 Exrtract one of the 12 flu genes from a FASTA contianing flu genes. You can download
 a bunch of flu reference genes using the download script in this repository.

 Genes available for extraction:
 > polymerase_pb2
 > polymerase_pb1
 > hemagglutinin
 > neuraminidase
 
=head1 OPTIONS

=over 3

=item B<-f, --fasta>=FILENAME

Input file of flu references in FASTA format. (Required) 

=item B<-g, --gene>=NAME

Flu gene to extract. Must be one of the ones available for extraction. (Required)

=item B<-o, --out>=FILENAME

Output file in FASTA format. (Required) 

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
my($fasta,$gene,$outfile,$help,$manual);

GetOptions (	
				"f|fasta=s"	=>	\$fasta,
                                "g|gene=s"      =>      \$gene,
				"o|out=s"	=>	\$outfile,
				"h|help"	=>	\$help,
				"m|manual"	=>	\$manual);

# VALIDATE ARGS
pod2usage(-verbose => 2)  if ($manual);
pod2usage( {-exitval => 0, -verbose => 2, -output => \*STDERR} )  if ($help);
pod2usage( -msg  => "\n\n ERROR!  Required argument --fasta not found.\n\n", -exitval => 2, -verbose => 1)  if (! $fasta );
pod2usage( -msg  => "\n\n ERROR!  Required argument --gene not found.\n\n", -exitval => 2, -verbose => 1)  if (! $gene );
pod2usage( -msg  => "\n\n ERROR!  Required argument -outfile not found.\n\n", -exitval => 2, -verbose => 1)  if (! $outfile);

## Globals
my %Gene = (
    'hemagglutinin' => 1740,
    'neuraminidase' => 1450
    );
my $print_flag=0;
my $seq = "";

unless (exists $Gene{$gene}) {  die "\n Error: The --gene you select needs to be one of the genes available, not: $gene\n"; }

if ($fasta =~ m/\.gz$/) { ## if a gzip compressed fasta
    open(IN,"gunzip -c $fasta |") || die "\n\n Cannot open the input file: $fasta\n\n";
}
else { ## If not gzip comgressed
    open(IN,"<$fasta") || die "\n\n Cannot open the input file: $fasta\n\n";
}
open(OUT,">$outfile") || die "\n Cannot write to $outfile\n";
while(<IN>) {
    chomp;
    if ($_ =~ m/^>/) {
	$print_flag = 0;
	if ($_ =~ m/Influenza A/i) {
	    if ($_ =~ m/$gene/) {
		print OUT $_ . "\n";
		$print_flag = 1;
	    }
	} 
    }
    elsif ($print_flag == 1) {
	print OUT $_ . "\n";
    }
}
close(IN);
close(OUT);

exit 0;
