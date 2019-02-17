#!/bin/bash
set -e

WORKING=$1
SAMPLE=$2
THREADS=$3
REFERENCE="$WORKING/references/H3N2_NYC_2004"
REFFASTA="fluA_h3n2_nyc_2004"
SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Create the working directories
directories=( 03-bowtie2 04-lofreq 05-assembly 06-variants )
for i in "${directories[@]}"; do
    mkdir -p $WORKING/$i
    if [ -d $WORKING/$i/$SAMPLE ]; then
	rm -rf $WORKING/$i/$SAMPLE
    fi
    mkdir -p $WORKING/$i/$SAMPLE
done

## Step 03: Recruit reads to a Flu reference
bowtie2 -x ${REFERENCE} \
    -1 $WORKING/02-flash/$SAMPLE/out.notCombined_1.fastq \
    -2 $WORKING/02-flash/$SAMPLE/out.notCombined_2.fastq \
    -U $WORKING/02-flash/$SAMPLE/out.extendedFrags.fastq \
    --threads $THREADS 2> $WORKING/03-bowtie2/$SAMPLE/bowtie2.log | samtools view -Sb -F 4 - | samtools sort -o $WORKING/03-bowtie2/$SAMPLE/out_sorted.bam

## Step 04: Run LoFreq
cd $WORKING/04-lofreq/$SAMPLE
ln -s ../../references/$REFFASTA ./
ln -s ../../references/$REFFASTA.fai ./
ln -s ../../03-bowtie2/$SAMPLE/out_sorted.bam ./
samtools index out_sorted.bam

lofreq call-parallel --pp-threads $THREADS \
    -f fluA_h3n2_nyc_2004 \
    -o ./out.vcf \
    out_sorted.bam > lofreq.log 2>&1

## Step 05: Create a consensus from the VCF file
$SCRIPTS/lofreq_2_consensus.pl $REFFASTA out.vcf > ../../05-assembly/$SAMPLE/$SAMPLE.fasta

## Step 06: Detects variants within this sample
cd ../../06-variants/$SAMPLE
ln -s ../../05-assembly/$SAMPLE/$SAMPLE.fasta ./
bowtie2-build $SAMPLE.fasta $SAMPLE > bowtie2-build.log 2>&1

bowtie2 -x ${SAMPLE} \
    -1 ../../02-flash/$SAMPLE/out.notCombined_1.fastq \
    -2 ../../02-flash/$SAMPLE/out.notCombined_2.fastq \
    -U ../../02-flash/$SAMPLE/out.extendedFrags.fastq \
    --threads $THREADS 2> ./bowtie2.log | samtools view -Sb -F 4 - | samtools sort -o ./out_sorted.bam

## Step 06B: Run LoFreq again
samtools faidx ${SAMPLE}.fasta
samtools index out_sorted.bam

lofreq call-parallel --pp-threads $THREADS \
    -f $SAMPLE.fasta \
    -o ./out.vcf \
    out_sorted.bam > lofreq.log 2>&1
