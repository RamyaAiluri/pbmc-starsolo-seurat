library(Seurat)
library(ggplot2)

set.seed(123)

pbmc <- readRDS("results/seurat/pbmc_after_qc.rds")

# Normalize counts and select variable genes
pbmc <- NormalizeData(pbmc)

pbmc <- FindVariableFeatures(
  pbmc,
  selection.method = "vst",
  nfeatures = 2000
)

# Scale variable genes and run PCA
pbmc <- ScaleData(
  pbmc,
  features = VariableFeatures(pbmc)
)

pbmc <- RunPCA(
  pbmc,
  features = VariableFeatures(pbmc),
  npcs = 30,
  seed.use = 123
)

# Save a plot to inspect the useful number of PCs
pca.plot <- ElbowPlot(pbmc, ndims = 30)

ggsave(
  "results/seurat/pca_elbow.png",
  plot = pca.plot,
  width = 6,
  height = 4,
  dpi = 300
)

# Use 20 PCs as an initial choice
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

umap.plot <- DimPlot(
  pbmc,
  reduction = "umap",
  label = TRUE
)

ggsave(
  "results/seurat/umap_clusters.png",
  plot = umap.plot,
  width = 7,
  height = 5,
  dpi = 300
)

# Check whether QC measurements explain the clusters
qc.plot <- FeaturePlot(
  pbmc,
  features = c("nFeature_RNA", "nCount_RNA", "percent.mt"),
  ncol = 3
)

ggsave(
  "results/seurat/umap_qc.png",
  plot = qc.plot,
  width = 12,
  height = 4,
  dpi = 300
)

print(table(Idents(pbmc)))

write.csv(
  pbmc[[]],
  "results/seurat/cluster_metadata.csv"
)

saveRDS(pbmc, "results/seurat/pbmc_clustered.rds")

capture.output(
  sessionInfo(),
  file = "results/seurat/sessionInfo_cluster.txt"
)
