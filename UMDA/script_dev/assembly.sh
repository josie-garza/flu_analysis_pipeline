#!/bin/bash
set -e

WORKING=$1
SAMPLE=$2
REFERENCE="$WORKING/references/flu_ref"
SCRIPTS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

## Create the working directories
directories=( 03-bowtie2)
for i in "${directories[@]}"; do
    mkdir $i
done
