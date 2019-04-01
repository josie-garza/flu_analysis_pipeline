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
for j in "${directories[@]}"; do
    echo $j
done
