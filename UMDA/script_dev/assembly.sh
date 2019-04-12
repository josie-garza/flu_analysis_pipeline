#!/bin/bash
set -e

## built by bowtie2-build
REFERENCE="references/flu_ref"

## Create the directory for the sorted bam files
directories=(04-vcf)
for i in "${directories[@]}"; do
        # remove if it already exists
        if [ -d $i ]; then
                rm -rf $i
        fi
        mkdir $i
done

## create a list for the number of samples to run the assembly on
samples=()
for k in {1..237}; do  #237 is the number of samples
        c=$k
        while [ ${#c} -le 4 ]
        do
                c="0$c"
        done
        samples+=($c )
done

## created sorted bam files
# for j in "${samples[@]}"; do
#     # check to make sure the sample exists in the folder
#     if [ -f /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq ]; then
#             echo $j
#             bowtie2 -x ${REFERENCE} \
#             --quiet\
#             -1  /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq\
#             -2  /research/emit/emit/00-reads/split_reads/UMDA_$j.2.fastq\
#             -S 03-bowtie2/$j.sam\
#             --no-unal
#             # sam to bam
#             samtools view -Sb 03-bowtie2/$j.sam > 03-bowtie2/$j.bam
#             # sort the bam
#             samtools sort 03-bowtie2/$j.bam -o 03-bowtie2/$j.sorted.bam
#             # create the .bai file for IGV viewing
#             samtools index 03-bowtie2/$j.sorted.bam
#             # remove intermediate steps
#             rm 03-bowtie2/$j.sam
#             rm 03-bowtie2/$j.bam
#     fi
# done

# create a vcf for every sorted bam file
for j in "${samples[@]}"; do
    # check to make sure the sample exists in the folder
    if [ -f /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq ]; then
            echo $j
            lofreq call -f ${REFERENCE} -o 04-vcf/$j.vcf 03-bowtie2/$j.sorted.bam
    fi
done

# update the vcf
# run snp on the updated vcf
#
#
