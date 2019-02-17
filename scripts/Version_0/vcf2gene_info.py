#!/usr/bin/python                                                                                                                                    
import sys

gene_table = open(sys.argv[1], "r")
file_vcf = open(sys.argv[2], "r")

header = True
geneLookup = {}

for line in gene_table:
    geneLine=[]
    if line.rstrip()[0]!="#":
        geneLine = line.rstrip().split('\t')
        for i in [2, 3, 4]:
            geneLine[i]=int(geneLine[i])
        if geneLine[1] in geneLookup:
            for i in range(geneLine[3], geneLine[4]+1):
                geneLookup[geneLine[1]][i]=geneLookup[geneLine[1]][i]+","+geneLine[0]

        else:
            geneLookup[geneLine[1]]={}
            for i in range(1, geneLine[2]+1):
                geneLookup[geneLine[1]][i]='non-coding'
            for i in range(geneLine[3], geneLine[4]+1):
                geneLookup[geneLine[1]][i]=geneLine[0]

gene_table.close()

for line in file_vcf:
    geneLine=[]
    geneLine = line.rstrip().split('\t')
    if geneLine[0]=='#CHROM':
        header = False
        print '\t'.join(geneLine)
    else:
        if header == False:
            geneLine[1]=int(geneLine[1])
            geneLine[2]=geneLookup[geneLine[0]][geneLine[1]]
            print '\t'.join([str(x) for x in geneLine])

file_vcf.close()
