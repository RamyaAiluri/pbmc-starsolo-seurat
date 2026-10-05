library(Seurat)
library(ggplot2)

pbmc <- readRDS("results/seurat/pbmc_clustered.rds")

# Save the PCA elbow plot with a white background
pca.plot <- ElbowPlot(pbmc, ndims = 30) + theme_classic()

ggsave(
  "results/seurat/pca_elbow_white.png",
  plot = pca.plot,
  width = 6,
  height = 4,
  dpi = 300,
  bg = "white"
)

# Find genes enriched in each cluster
markers <- FindAllMarkers(
  pbmc,
  assay = "RNA",
  only.pos = TRUE,
  test.use = "wilcox",
  min.pct = 0.25,
  logfc.threshold = 0.25
)

write.csv(
  markers,
  "results/seurat/all_cluster_markers.csv",
  row.names = FALSE
)

# Select up to 10 significant markers per cluster
significant <- markers[markers$p_val_adj < 0.05, ]

top10 <- do.call(
  rbind,
  lapply(split(significant, significant$cluster), function(x) {
    x <- x[order(x$avg_log2FC, decreasing = TRUE), ]
    head(x, 10)
  })
)

write.csv(
  top10,
  "results/seurat/top10_cluster_markers.csv",
  row.names = FALSE
)

# Plot common PBMC markers to support annotation
genes <- c(
  "CD3D", "CD3E", "IL7R", "CCR7",
  "CD8A", "NKG7", "GNLY",
  "MS4A1", "CD79A",
  "LYZ", "S100A8", "S100A9", "FCGR3A",
  "FCER1A", "CD1C",
  "PPBP", "PF4"
)

genes <- genes[genes %in% rownames(pbmc)]

marker.plot <- DotPlot(pbmc, features = genes) +
  RotatedAxis()

ggsave(
  "results/seurat/pbmc_marker_dotplot.png",
  plot = marker.plot,
  width = 12,
  height = 5,
  dpi = 300,
  bg = "white"
)

# Summarize QC measurements by cluster
qc <- pbmc[[]]

cluster.qc <- aggregate(
  qc[, c("nFeature_RNA", "nCount_RNA", "percent.mt")],
  by = list(cluster = qc$seurat_clusters),
  FUN = median
)

write.csv(
  cluster.qc,
  "results/seurat/cluster_qc_medians.csv",
  row.names = FALSE
)
