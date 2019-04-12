#!/bin/bash
set -e

# Built by bowtie2-build
REFERENCE="references/fluA_ny_h3n2.fna"

# Create the directory for the sorted bam files
directories=(05-html 06-annotated_vcf)
for i in "${directories[@]}"; do
        # remove if it already exists
        if [ -d $i ]; then
                rm -rf $i
        fi
        mkdir $i
done

# Create a list for the number of samples to run the assembly on
samples=()
for k in {1..83}; do  #237 is the number of samples
        c=$k
        while [ ${#c} -le 4 ]
        do
                c="0$c"
        done
        samples+=($c )
done

# Created sorted bam files
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

# Create a vcf for every sorted bam file
# for j in "${samples[@]}"; do
#     # check to make sure the sample exists in the folder
#     if [ -f /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq ]; then
#             echo $j
#             lofreq call -f ${REFERENCE} -o 04-vcf/$j.vcf 03-bowtie2/$j.sorted.bam
#     fi
# done

# Update the vcf
for j in "${samples[@]}"; do
    # check to make sure the sample exists in the folder
    if [ -f /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq ]; then
            echo $j
            INPUT_CHR_NAME=$(cat 04-vcf/$j.vcf | grep -v "^#" | cut -f 1 | uniq)
            echo $INPUT_CHR_NAME
            #IFS= read -ra ADDR <<< "$INPUT_CHR_NAME"
            read -a ADDR <<< "$INPUT_CHR_NAME"
            echo "first elem ${INPUT_CHR_NAME[0]}"
            echo "array $ADDR"
            for i in "${ADDR[@]}"; do
                    echo $i
                    b=${i:0:9}
                    echo $b
                    cat 04-vcf/$j.vcf | sed "s/^$i/$b/" > 04-vcf/$j.updated.vcf
            done
    fi
done

# Run snp on the updated vcf
for j in "${samples[@]}"; do
    # check to make sure the sample exists in the folder
    if [ -f /research/emit/emit/00-reads/split_reads/UMDA_$j.1.fastq ]; then
            echo $j
            java -Xmx4g -jar ~/snpEFf/snpEff.jar -v -stats 05-html/$j.html flu 04-vcf/$j.updated.vcf > 06-annotated_vcf/$j.ann.vcf
    fi
done
