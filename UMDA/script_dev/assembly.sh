#!/bin/bash
set -e

WORKING=$1
SAMPLE=$2
REFERENCE="references/flu_ref"
SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Create the working directories
directories=(03-bowtie2)
for i in "${directories[@]}"; do
    mkdir $i
    mkdir -p $WORKING/$i/$SAMPLE
done

## Step 03: Recruit reads to a Flu reference
bowtie2 -x ${REFERENCE} \
    -1 $WORKING/02-flash/$SAMPLE/out.notCombined_1.fastq \
    -2 $WORKING/02-flash/$SAMPLE/out.notCombined_2.fastq \
    -S $WORKING/$SAMPLE/out.sam
