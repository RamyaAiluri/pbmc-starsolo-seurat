library(Seurat)
library(ggplot2)

set.seed(123)

pbmc <- readRDS("results/seurat/pbmc_clustered.rds")

predictions <- read.csv(
  "results/seurat/doublet_predictions.csv"
)

# Match predictions to cell barcodes
cell.order <- match(colnames(pbmc), predictions$barcode)
stopifnot(!anyNA(cell.order))

pbmc$doublet_class <- predictions$doublet_class[cell.order]
pbmc$doublet_score <- predictions$doublet_score[cell.order]

# Keep original clusters for comparison
pbmc$original_cluster <- as.character(Idents(pbmc))

doublet.plot <- DimPlot(
  pbmc,
  group.by = "doublet_class"
)

ggsave(
  "results/seurat/umap_doublet_predictions.png",
  plot = doublet.plot,
  width = 7,
  height = 5,
  dpi = 300,
  bg = "white"
)

# Keep predicted singlets
pbmc <- subset(pbmc, subset = doublet_class == "singlet")

# Repeat normalization, PCA, and clustering
pbmc <- NormalizeData(pbmc)
pbmc <- FindVariableFeatures(pbmc, nfeatures = 2000)
pbmc <- ScaleData(pbmc, features = VariableFeatures(pbmc))

pbmc <- RunPCA(
  pbmc,
  features = VariableFeatures(pbmc),
  npcs = 30,
  seed.use = 123
)

pbmc <- FindNeighbors(pbmc, dims = 1:20)

pbmc <- FindClusters(
  pbmc,
  resolution = 0.4,
  random.seed = 123
)

pbmc <- RunUMAP(
  pbmc,
  dims = 1:20,
  seed.use = 123
)

# Save the updated UMAP
umap.plot <- DimPlot(pbmc, label = TRUE)

ggsave(
  "results/seurat/umap_singlet_clusters.png",
  plot = umap.plot,
  width = 7,
  height = 5,
  dpi = 300,
  bg = "white"
)

# Print cell counts and cluster correspondence
print(paste("Retained singlets:", ncol(pbmc)))
print(table(Idents(pbmc)))
print(table(pbmc$original_cluster, Idents(pbmc)))

# Save the object and metadata
saveRDS(
  pbmc,
  "results/seurat/pbmc_singlets_clustered.rds"
)

write.csv(
  pbmc[[]],
  "results/seurat/singlet_metadata.csv"
)
