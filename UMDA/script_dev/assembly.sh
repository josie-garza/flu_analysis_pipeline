#!/bin/bash
set -e

REFERENCE="references/flu_ref"

## Create the working directories
directories=(03-bowtie2)
for i in "${directories[@]}"; do
        if [ -d $i ]; then
                rm -rf $i
        fi
        mkdir $i
done

samples=(00001 00002)
## Step 03: Recruit reads to a Flu reference
for j in "${samples[@]}"; do
    if [ -d /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq ]; then
            bowtie2 -x ${REFERENCE} \
            --quiet\
            -1  /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq\
            -2  /research/emit/emit/00-reads/split_reads/UMDA_$j.2.fastq\
            -S 03-bowtie2/$j.sam\
            --no-unal
            samtools view -Sb 03-bowtie2/$j.sam > 03-bowtie2/$j.bam
            samtools sort 03-bowtie2/$j.bam -o 03-bowtie2/$j.sorted.bam
            samtools index 03-bowtie2/$j.sorted.bam
            rm 03-bowtie2/$j.sam
            rm 03-bowtie2/$j.bam
    fi
done
