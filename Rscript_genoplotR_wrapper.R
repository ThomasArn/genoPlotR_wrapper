library(genoPlotR)
library(ape)
library(ade4)

args <- commandArgs(trailingOnly = TRUE)

files = dir(args[1],recursive = T, pattern = ".gbk",full.names = T)
tree <- read.tree(args[2])

tree_barto <- newick2phylog(write.tree(tree,tree.names=T))
dna_segs <- list()
for (n in 1:length(files)) {
  dna_segs[n] <- list(read_dna_seg_from_genbank(files[n]))
  names(dna_segs)[n] <- gsub(".gbk","",basename(files[n])) 
}

names(dna_segs) <- gsub("_+","_",names(dna_segs))
dna_segs <- dna_segs[names(tree_barto$leaves)]

comp_list <- list()
for (f in 1:(length(dna_segs)-1)){
  comp_list[f] <- list(try(read_comparison_from_blast(paste("blast/",names(dna_segs[f]),"_vs_",names(dna_segs[(f+1)]),".txt",sep=""))))
}

pdf("../Gene_synteny_comparison.pdf")
plot_gene_map(dna_segs=dna_segs,
               dna_seg_labels = names(tree_barto$leaves),
               comparisons=comp_list,
               global_color_scheme = c("auto", "auto", "blue_red", 0.5),
               tree=tree_barto,
               main="Gene synteny comparison",
               gene_type="side_blocks",
               dna_seg_scale=TRUE, scale=FALSE)
 
dev.off()
quit()
