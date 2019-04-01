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

samples=(00001 00002 00003 00004)
## Step 03: Recruit reads to a Flu reference
for j in "${samples[@]}"; do
    echo $j
done
