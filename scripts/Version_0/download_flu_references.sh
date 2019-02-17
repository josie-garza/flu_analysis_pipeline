#!/bin/sh
set -e

DATE_STAMP=$(date +"%Y-%m-%d")
mkdir -p "flu_refs_${DATE_STAMP}"
cd "flu_refs_${DATE_STAMP}"
echo; echo -n " Downloading flu references on: "; date; echo

## All flu genes
wget "ftp://ftp.ncbi.nih.gov/genomes/INFLUENZA//influenza.faa.gz"
wget "ftp://ftp.ncbi.nih.gov/genomes/INFLUENZA//influenza.fna.gz"
gunzip influenza.faa.gz
gunzip influenza.fna.gz

## fluA reference genome
wget "ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/865/085/GCF_000865085.1_ViralMultiSegProj15622/GCF_000865085.1_ViralMultiSegProj15622_genomic.fna.gz"
gunzip GCF_000865085.1_ViralMultiSegProj15622_genomic.fna.gz
mv GCF_000865085.1_ViralMultiSegProj15622_genomic.fna fluA_ny_h3n2.fna

## Pull out just fluA genes
../parse_fluA.pl influenza.fna > fluA.fna

## Cluster fluA @ 97%
cd-hit -i fluA.fna -o fluA.97 -c 0.97 -M 0 -T 0 -d 1000000

cd ../
echo " Done..."; echo
exit 0;
