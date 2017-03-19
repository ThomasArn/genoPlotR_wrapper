from Bio import AlignIO
import sys
import re

alignment = AlignIO.read(open(sys.argv[1]) , "fasta")
#print("Alignment length %i" % alignment.get_alignment_length())
for record in alignment :
#     print(record.id)
    f = open(str("".join(("PROKKA/",record.id,".fa"))), 'w')
    seq = re.sub('-', '', str(record.seq))
    f.write(">" + record.id + "\n" + str(seq) + "\n")
    f.close()

