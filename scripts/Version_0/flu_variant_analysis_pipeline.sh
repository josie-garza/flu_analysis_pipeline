#!/bin/bash
set -e

## Inputs
SAMPLE=$1
WORKING=$2
THREADS=$3

## Globals
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BOWTIE_INDEX="$DIR/../data/NYC_2004_H3N2"
FLU_GENOME="$DIR/../data/nyc_h3n2_genome.fasta"

## Create some working directories
mkdir -p $WORKING/01-bowtie2
mkdir -p $WORKING/02-lofreq

## Step 01: Bowtie2 against NYC 2004 H3N2 Flu reference
bowtie2 --very-sensitive-local \
    --threads $THREADS \
    -x $BOWTIE_INDEX \
    -1 $WORKING/00-reads/$SAMPLE.notCombined_1.fastq.gz \
    -2 $WORKING/00-reads/$SAMPLE.notCombined_2.fastq.gz \
    -U $WORKING/00-reads/$SAMPLE.extendedFrags.fastq.gz 2> 01-bowtie2/${SAMPLE}_bowtie2.log | samtools view -Sb -F 4 - | samtools sort -o 01-bowtie2/$SAMPLE.bam -;

## Step 02: Index the BAM file
cd 01-bowtie2;
samtools index $SAMPLE.bam $SAMPLE.bam.bai;
cd ../

## Step 03: Run lofreq
lofreq call-parallel \
    --pp-threads $THREADS \
    -f $FLU_GENOME \
    -o 02-lofreq/$SAMPLE.vcf \
    01-bowtie2/$SAMPLE.bam

exit 0;

