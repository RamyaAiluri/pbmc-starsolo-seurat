library(Seurat)
library(ggplot2)

pbmc <- readRDS("results/seurat/pbmc_singlets_clustered.rds")

# Find positive markers for the updated clusters
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
  "results/seurat/singlet_all_cluster_markers.csv",
  row.names = FALSE
)

# Save up to 10 significant markers per cluster
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
  "results/seurat/singlet_top10_cluster_markers.csv",
  row.names = FALSE
)

# Include markers to investigate B cells and dendritic cells
genes <- c(
  "CD3D", "CD3E", "IL7R", "CCR7", "CD8A",
  "NKG7", "GNLY",
  "MS4A1", "CD79A", "TCL1A", "IGHD",
  "JCHAIN", "MZB1",
  "LYZ", "S100A8", "S100A9", "FCGR3A",
  "FCER1A", "CD1C", "CLEC10A",
  "PPBP", "PF4"
)

genes <- genes[genes %in% rownames(pbmc)]

marker.plot <- DotPlot(pbmc, features = genes) +
  RotatedAxis()

ggsave(
  "results/seurat/singlet_marker_dotplot.png",
  plot = marker.plot,
  width = 14,
  height = 5,
  dpi = 300,
  bg = "white"
)

qc <- pbmc[[]]

cluster.qc <- aggregate(
  qc[, c("nFeature_RNA", "nCount_RNA", "percent.mt")],
  by = list(cluster = qc$seurat_clusters),
  FUN = median
)

write.csv(
  cluster.qc,
  "results/seurat/singlet_cluster_qc_medians.csv",
  row.names = FALSE
)
