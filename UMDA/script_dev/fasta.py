# two args: sample id, summary info

import sys
id = sys.argv[1]

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
    vcf = "04-vcf/" + id + ".vcf"
    summary = summarize(vcf)
    name = id + ".fasta"
    fasta = open(name,"w+")
    ref = create_ref(id)

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
