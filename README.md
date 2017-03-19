# genoPlotR_wrapper
Wrapper for the genoPlotR R package. This is a wrapper that makes the use of genoPlotR easier, I have not created genoPlotR! 

GenoPlotR makes a gene synteny plot, but pre-processing of data is necessary. This wrapper makes phylogeny, genbank files and blast comparisons that is needed for the genoPLotR package.

Dependencies are mafft, raxmlHPC, python, biopython, prokka, blastn and the R pacakges genoPlotR, ape and ade4.

The input is a multifasta file. 
 ```recomb_genoplotR_wrapper.sh multifasta```

The output is a pdf file with the gene synteny plot

output example:

![alt tag](https://github.com/ThomasArn/genoPlotR_wrapper/blob/master/plots/Recombination_comparison.jpg)
