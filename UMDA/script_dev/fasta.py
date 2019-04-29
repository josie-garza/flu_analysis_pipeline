# two args: sample id, summary info
# each sample has variance, reference, and coverage
# first go through coverage and see what needs to be placed in the fasta
# originally just use reference for placing, but n where no coverage
# next go through vcf and place the variants!

# check indexing!!

counts = {'NC_007373': 2341, 'NC_007372': 2341, 'NC_007371': 2233,
    'NC_007366': 1762, 'NC_007369': 1566, 'NC_007368': 1467, 'NC_007367': 1027, 'NC_007370': 890}

import sys
id = sys.argv[1]

def coverage(id):
    # return the reference dictionary without the variance
    file = "10-coverage/" + id + ".coverage"
    f = open(file, "r")
    lines = f.readlines()
    segments = {}
    for line in lines:
        split = line.split()
        if split[0] in segments.keys():
            segments[split[0]].append((split[1], split[3]))
        else:
            segments[split[0]] = []
            segments[split[0]].append((split[1], split[3]))

    ref = create_ref(id)
    for segment in ref.keys():
        check = segment + ".1"
        if check not in segments.keys():
            num = len(ref[segment][1])
            new_seg = ''
            for i in range(0, num):
                new_seg += 'N'
            ref[segment][1] = new_seg

    for segment in segments.keys():
        ref_seg = ref[segment[0:9]][1]
        new_seg = ''
        for i in range(0, len(ref_seg)):
            new_seg += 'N'

        ref_list = list(ref_seg)
        new_list = list(new_seg)

        for pair in segments[segment]:
            if int(pair[1]) > 1:
                new_list[int(pair[0])-1] = ref_list[int(pair[0])-1]

        string = ''.join(new_list)
        ref[segment[0:9]][1] = string
    if not check_counts(ref):
        return ref
    else:
        return {}

def check_counts(ref):
    remove = False
    for segment in ref.keys():
        count = 0
        for char in ref[segment][1]:
            if char=='N':
                count+=1
        if count > counts[segment]*0.5:
            remove = True
    print (remove)
    return remove

def create_ref(id):
    ref = {}
    f = open("references/fluA_ny_h3n2.fna", "r")
    f1 = f.read()
    segments = f1.split(">")
    for i in range(0, len(segments)):
        info = segments[i].split()
        length = len(info)
        if length > 0:
            for j in range(11, length):
                info[10] += info[j]
            chromosome = info[0][0:9]
            info[0] += (" sample " + str(id) + " segment " + str(i) + ", ")
            intro = ">" + info[0]
            ref[chromosome] = [intro, info[10]]
    return (ref)

def summarize(file):
    summary = {}
    f = open(file, "r")
    f1 = f.readlines()
    for line in f1:
        if line[0:2] == "NC":
            info = line.split()
            chromosome = info[0]
            if chromosome in summary:
                summary[chromosome].append((info[1], info[3]))
            else:
                summary[chromosome] = []
                summary[chromosome].append((info[1], info[3]))
    return (summary)

def fasta(id):
    ref = coverage(id)
    print (id)
    if ref == {}:
        print ("removing...")
        return
    vcf = "04-vcf/" + id + ".vcf"
    summary = summarize(vcf)
    name = id + ".fasta"
    fasta = open(name,"w+")

    for segment in ref.keys():
        if segment in summary.keys():
            sequence = list(ref[segment][1])
            for update in summary[segment]:
                index = int(update[0])
                sequence[index] = update[1]
            string = ''.join(sequence)
            fasta.write(ref[segment][0])
            fasta.write("\n")
            fasta.write(string)
            fasta.write("\n")
        else:
            fasta.write(ref[segment][0])
            fasta.write("\n")
            fasta.write(ref[segment][1])
            fasta.write("\n")

if __name__== "__main__":
    fasta(id)
