#!/bin/bash
set -e

PE1=$1
PE2=$2
WORKING=$3
SAMPLE=$4
THREADS=$5

## Create the working directories
mkdir -p $WORKING/01-trimmomatic
mkdir -p $WORKING/02-flash
mkdir -p $WORKING/01-trimmomatic/$SAMPLE
mkdir -p $WORKING/02-flash/$SAMPLE

## Step 01: QC trimming with Trimmomatic
## Trimmomatic version 0.36
## http://www.usadellab.org/cms/index.php?page=trimmomatic
## Trimming parameters: sliding window 4 bp with average quality >30 (1/1000).
## Throw away reads < 60 bp.
echo -n " Running trimmomatic ............... "
java -jar ~/bin/trimmomatic-0.36.jar PE -phred33 $PE1 $PE2 \
    $WORKING/01-trimmomatic/$SAMPLE/output_forward_paired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_forward_unpaired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_paired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_unpaired.fq \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:4:30 MINLEN:60 \
    > $WORKING/01-trimmomatic/$SAMPLE/trim.log 2>&1
echo -n " Done "; date;

## Step 02: Run FLASh to merge paried read pairs
## FLASh version 1.2.11
## Default parameters, except for --max-overlap 500 (because many reads overlapped too much).
echo -n " Running FLASh  .................... "
flash -t ${THREADS} \
    --max-overlap 500 \
    --output-directory=$WORKING/02-flash/$SAMPLE \
    $WORKING/01-trimmomatic/$SAMPLE/output_forward_paired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_paired.fq \
    > $WORKING/02-flash/$SAMPLE/flash.log 2>&1

cat $WORKING/01-trimmomatic/$SAMPLE/output_forward_unpaired.fq \
    $WORKING/01-trimmomatic/$SAMPLE/output_reverse_unpaired.fq \
    >> $WORKING/02-flash/$SAMPLE/out.extendedFrags.fastq
echo -n " Done "; date;
