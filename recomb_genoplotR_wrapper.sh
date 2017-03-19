#!/bin/bash
# Made by Thomas Arn Hansen

################ run mafft on contigs using --adjustdirection
mkdir -p mafft_genoplotr

sed -e 's/[\!\@\#\\$\%\^\&\*\(\)\|:;.,]/_/g' -e 's/-/_/g' -e 's/"_+"/_/g' $1 > mafft_genoplotr/input.fa
mafft --thread 18 --adjustdirection mafft_genoplotr/input.fa > mafft_genoplotr/mafft_output.fa
sed -i "s/_R_//g"  mafft_genoplotr/mafft_output.fa
cd mafft_genoplotr/
perl /data/data5/Projects/thomas/scripts/convert_fasta2phylip.pl mafft_output.fa

raxmlHPC-PTHREADS-AVX -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -T 18 -s mafft_output.fa.phylip -n recomb_mafft.raxml 

####################### split up multi fasta file #######################
mkdir -p PROKKA
python /data/data5/Projects/thomas/scripts/python_multiple_alignment_genopltR.py mafft_output.fa


########### Run prokka ######################
mkdir -p PROKKA/prokka_out
for f in `ls PROKKA/*fa`; do
  bsname=`basename $f .fa`
  nice -n 19 /data/data5/Projects/thomas/bin/prokka/prokka-1.11/bin/prokka --force --genus Staphylococcus --species "not applicable" -strain $bsname --outdir PROKKA/prokka_out/prokka_$bsname --prefix $bsname $f --locustag $bsname --addgenes
done 

########### Do blast combinations ######################
mkdir -p blast
ls PROKKA/*fa > FileOfFiles.txt

for i in `cat FileOfFiles.txt`; do
    for j in `cat FileOfFiles.txt`; do
       if [ $i != $j ]; then
         bsname_i=`basename $i .fa` 
         bsname_j=`basename $j .fa` 
         makeblastdb  -in $i -out $bsname_i -dbtype nucl > tmp
#         blastn -task blastn -db $bsname_i -query $j -outfmt 6 | grep -v '#' > blast/$bsname_j\_vs_$bsname_i\.txt
         blastn -db $bsname_i -query $j -outfmt 6 | grep -v '#' > blast/$bsname_j\_vs_$bsname_i\.txt
         rm $bsname_i.nhr $bsname_i.nsq $bsname_i.nin
       fi
  done
done 

Rscript /data/data5/Projects/thomas/scripts/Rscript_genoplotR_wrapper.R PROKKA/prokka_out/ RAxML_bipartitions.recomb_mafft.raxml 

cd ..
rm -r mafft_genoplotr/
