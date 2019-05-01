#

import sys
id = sys.argv[1]

def rename(id):
    names = creat_dict()
    if id in names.keys():
        new_name = names[id]
    else:
        new_name = id

    html = "05-html/" + id + ".html"
    new_html = open("13-html_new/" + new_name + ".html","w+")
    html_copy = open(html, "r+")
    html_lines = html_copy.readlines()
    for line in html_lines:
        splits = line.split()
        for split in range(0, len(splits)):
            if ".genes.txt" in splits[split]:
                sub = splits[split].split(".")
                sub[0] = 'href=\"' + new_name
                splits[split] = ".".join(sub)
                line = " ".join(splits)
        new_html.write(line)

    genes = "05-html/" + id + ".genes.txt"
    new_genes = open("13-html_new/" + new_name + ".genes.txt","w+")
    genes_copy = open(genes, "r+")
    genes_lines = genes_copy.readlines()
    for line in genes_lines:
        new_genes.write(line)

def creat_dict():
    names = {}
    f = open("metadata.txt", "r")
    lines = f.readlines()
    for ind in range(1, len(lines)):
        split = lines[ind].split()
        seg = split[0][11:]
        data = split[4]
        split2 = data.split('/')
        for item in split2:
            if "_" in item:
                names[seg] = item
    return names

if __name__== "__main__":
    rename(id)
