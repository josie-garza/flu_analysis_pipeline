#!/usr/bin/python                                                                                

import sys

geneTable = open(sys.argv[1], 'r')
fileIn = open(sys.argv[2], 'r')

geneSizes = {}
numVar = {}
n = 0
seg = ''

for line in geneTable:
    if line.rstrip()[0]!='#':
        l = []
        l = line.rstrip().split('\t')
        for i in [2,3,4]:
            l[i]=int(l[i])
        geneSizes[l[0]]=(l[4]-l[3])+1
        if seg == '' or seg != l[1]:
            seg = l[1]
            n+=l[2]-geneSizes[l[0]]
geneSizes['non-coding']=n

geneTable.close()

for item in geneSizes:
    numVar[item]=0
for line in fileIn:
    if line.rstrip()[0]!='#':
        a=[]
        a=line.rstrip().split('\t')
        a=a[2].split(',')
        for i in range(len(a)):
           numVar[a[i]]+=1

fileIn.close()

t = []
for item in numVar:
    t.append(item)

print '\t'. join(t)

for i in range(len(t)):
    t[i]=float(numVar[t[i]])/geneSizes[t[i]]

print '\t'.join(str(x) for x in t)

print geneSizes
print numVar
