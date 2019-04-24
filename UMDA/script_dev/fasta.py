# two args: sample id, summary info

import sys
id = sys.argv[1]

def create_ref(id):
    ref = {}
    f = open("fluA_ny_h3n2.fna", "r")
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

example = {'NC_007371': [('22', 'G'), ('99', 'A'), ('120', 'A'), ('144', 'C'), ('156', 'A'), ('177', 'T'), ('222', 'T'), ('324', 'A'), ('326', 'A'), ('333', 'A'), ('345', 'A'), ('363', 'G'), ('369', 'T'), ('396', 'A'), ('435', 'A'), ('465', 'C'), ('468', 'C'), ('489', 'A'), ('549', 'A'), ('579', 'A'), ('646', 'T'), ('660', 'T'), ('690', 'A'), ('790', 'A'), ('897', 'C'), ('915', 'T'), ('930', 'T'), ('1048', 'T'), ('1065', 'C'), ('1086', 'C'), ('1092', 'G'), ('1122', 'A'), ('1123', 'A'), ('1158', 'A'), ('1170', 'C'), ('1212', 'C'), ('1250', 'A'), ('1269', 'C'), ('1285', 'A'), ('1333', 'T'), ('1350', 'G'), ('1389', 'C'), ('1395', 'G'), ('1422', 'T'), ('1449', 'A'), ('1557', 'A'), ('1572', 'T'), ('1581', 'C'), ('1608', 'T'), ('1623', 'G'), ('1704', 'T'), ('1790', 'T'), ('1827', 'G'), ('1918', 'T'), ('1959', 'G'), ('2022', 'T'), ('2028', 'T'), ('2073', 'C'), ('2136', 'A')]}

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
            fasta.write(ref[segment][0] + string)
            fasta.write("\n")
        else:
            fasta.write(ref[segment][0] + ref[segment][1])
            fasta.write("\n")

if __name__== "__main__":
    fasta(id)
