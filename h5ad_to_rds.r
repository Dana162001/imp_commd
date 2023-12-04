options(repos = c(CRAN = "https://cran.rstudio.com/"))


#install.packages("remotes")
#remotes::install_github("PMBio/MuDataSeurat")

library("Seurat")
library('MuDataSeurat')


h5ad <- ReadH5AD("/work/rwth1209/dana_projects/R/scDesign3/our_data_MERFISH/MERFISH_kidney_object.h5ad")


# step 1: Slim down a Seurat object. So you get raw counts, lognorm counts
# seu = DietSeurat(
#   h5ad,
#   counts = TRUE, # so, raw counts save to adata.layers['counts']
#   data = TRUE, # so, log1p counts save to adata.X when scale.data = False, else adata.layers['data']
#   scale.data = FALSE, # if only scaled highly variable gene, the export to h5ad would fail. set to false
#   features = rownames(h5ad), # export all genes, not just top highly variable genes
#   assays = "RNA",
#   dimreducs = c("pca","umap"),
#   #graphs = c("RNA_nn", "RNA_snn"), # to RNA_nn -> distances, RNA_snn -> connectivities
#   misc = TRUE
# )

saveRDS(h5ad, "/work/rwth1209/dana_projects/R/scDesign3/our_data_MERFISH/MERFISH_kidney_object.rds") 