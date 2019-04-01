#!/bin/bash
set -e

REFERENCE="references/flu_ref"

## Create the working directories
directories=(03-bowtie2)
for i in "${directories[@]}"; do
    mkdir $i
done

samples=(00001)
## Step 03: Recruit reads to a Flu reference
for j in "${samples[@]}"; do
    bowtie2 -x ${REFERENCE} \
    --quiet\
    -1  00-reads/UMDA_$j.1.fastq\
    -2  00-reads/UMDA_$j.2.fastq\
    -S 03-bowtie2/$j.sam\
    --no-unal
    samtools view -Sb 03-bowtie2/$j.sam > 03-bowtie2/$j.bam
    samtools sort 03-bowtie2/$j.bam -o 03-bowtie2/$j_sorted.bam
    samtools index 03-bowtie2/$j_sorted.bam
done
