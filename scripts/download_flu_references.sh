#!/bin/sh
set -e

DATE_STAMP=$(date +"%Y-%m-%d")
mkdir -p "flu_refs_${DATE_STAMP}"
cd "flu_refs_${DATE_STAMP}"
echo; echo -n " Downloading flu references on: "; date; echo

wget "ftp://ftp.ncbi.nih.gov/genomes/INFLUENZA//influenza.faa.gz"
wget "ftp://ftp.ncbi.nih.gov/genomes/INFLUENZA//influenza.fna.gz"

gunzip influenza.faa.gz
gunzip influenza.fna.gz

cd ../
echo " Done..."; echo
exit 0;
