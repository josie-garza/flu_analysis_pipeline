#!/bin/bash
set -e

## Inputs
READS_LEFT=$1
READS_RIGHT=$2
WORKING=$3
SAMPLE=$4
THREADS=$5

## Creating working directories
mkdir -p $WORKING/01-trimmomatic
mkdir -p $WORKING/02-flash
mkdir -p $WORKING/03-spades
mkdir -p $WORKING/04-bowtie2
mkdir -p $WORKING/01-trimmomatic/$SAMPLE
mkdir -p $WORKING/02-flash/$SAMPLE
mkdir -p $WORKING/03-spades/$SAMPLE
mkdir -p $WORKING/04-bowtie2/$SAMPLE

## Step 01: QC trimming with Trimmomatic
echo -n " Running trimmomatic ............... "
java -jar ~/bin/trimmomatic-0.36.jar PE -phred33 $READS_LEFT $READS_RIGHT \
    $WORKING/01-trimmomatic/$SAMPLE/output_forward_paired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_forward_unpaired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_paired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_unpaired.fq \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:4:30 MINLEN:60 \
    > $WORKING/01-trimmomatic/$SAMPLE/trim.log 2>&1
echo -n " Done "; date;

## Step 02: Run FLASh to merge paried read pairs
echo -n " Running FLASh  .................... "
flash -t ${THREADS} \
    --max-overlap 270 \
    --output-directory=$WORKING/02-flash/$SAMPLE \
    $WORKING/01-trimmomatic/$SAMPLE/output_forward_paired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_paired.fq \
    > $WORKING/02-flash/$SAMPLE/flash.log 2>&1

cat $WORKING/01-trimmomatic/$SAMPLE/output_forward_unpaired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_unpaired.fq \
    >> $WORKING/02-flash/$SAMPLE/out.extendedFrags.fastq
echo -n " Done "; date;

## Step 03: Run SPAdes and assemble our flu genome
echo -n " Running SPAdes .................... "
spades.py -o $WORKING/03-spades/$SAMPLE/ \
    --only-assembler \
    -t $THREADS \
    -1 $WORKING/02-flash/$SAMPLE/out.notCombined_1.fastq \
    -2 $WORKING/02-flash/$SAMPLE/out.notCombined_2.fastq \
    -s $WORKING/02-flash/$SAMPLE/out.extendedFrags.fastq \
    > $WORKING/02-flash/$SAMPLE/spades_run.log 2>&1
echo -n " Done "; date;


exit 0;
