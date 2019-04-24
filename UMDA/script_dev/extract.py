
# {seg: [(position, ALT)...]}
import sys

file = sys.argv[1]

def main(file):
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
    print(summary)

if __name__== "__main__":
    main(file)
