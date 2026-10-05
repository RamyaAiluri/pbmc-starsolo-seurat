library(Seurat)
library(ggplot2)

pbmc <- readRDS("results/seurat/pbmc_singlets_clustered.rds")

# Inspect the mixed myeloid cluster
myeloid <- subset(pbmc, idents = "4")

genes <- c(
  "FCGR3A", "CDKN1C", "LST1",
  "FCER1A", "CD1C", "CLEC10A"
)

genes <- genes[genes %in% rownames(myeloid)]

p <- FeaturePlot(
  myeloid,
  features = genes,
  reduction = "umap",
  ncol = 3,
  order = TRUE
)

ggsave(
  "results/seurat/cluster4_myeloid_markers.png",
  plot = p,
  width = 12,
  height = 8,
  dpi = 300,
  bg = "white"
)

# Export cell-level normalized expression for inspection
expression <- FetchData(
  myeloid,
  vars = genes,
  layer = "data"
)

write.csv(
  expression,
  "results/seurat/cluster4_marker_expression.csv"
)
