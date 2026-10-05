library(Seurat)
library(ggplot2)
library(patchwork)

dir.create("results/seurat", recursive = TRUE, showWarnings = FALSE)

# Load cells called by STARsolo
counts <- ReadMtx(
  mtx = "results/starsolo/Solo.out/Gene/filtered/matrix.mtx",
  cells = "results/starsolo/Solo.out/Gene/filtered/barcodes.tsv",
  features = "results/starsolo/Solo.out/Gene/filtered/features.tsv",
  feature.column = 2
)

pbmc <- CreateSeuratObject(
  counts = counts,
  project = "PBMC1k",
  min.cells = 0,
  min.features = 0
)

# Calculate the percentage of mitochondrial counts
mito.genes <- grep("^MT-", rownames(pbmc), value = TRUE)
stopifnot(length(mito.genes) > 0)

pbmc[["percent.mt"]] <- PercentageFeatureSet(
  pbmc,
  features = mito.genes
)

# Save QC measurements for every cell
write.csv(
  pbmc[[]],
  "results/seurat/qc_metadata.csv"
)

# Plot genes, UMIs, and mitochondrial percentage
qc.plot <- VlnPlot(
  pbmc,
  features = c("nFeature_RNA", "nCount_RNA", "percent.mt"),
  pt.size = 0,
  ncol = 3,
  layer = "counts"
)

ggsave(
  "results/seurat/qc_violin.png",
  plot = qc.plot,
  width = 12,
  height = 4,
  dpi = 300
)

# Inspect relationships between QC measurements
plot1 <- FeatureScatter(
  pbmc,
  feature1 = "nCount_RNA",
  feature2 = "nFeature_RNA"
)

plot2 <- FeatureScatter(
  pbmc,
  feature1 = "nCount_RNA",
  feature2 = "percent.mt"
)

ggsave(
  "results/seurat/qc_scatter.png",
  plot = plot1 + plot2,
  width = 10,
  height = 4,
  dpi = 300
)

# Print distributions to help choose filtering thresholds
qc.summary <- sapply(
  pbmc[[]][, c("nFeature_RNA", "nCount_RNA", "percent.mt")],
  quantile,
  probs = c(0, 0.01, 0.05, 0.5, 0.95, 0.99, 1)
)

print(paste("Cells loaded:", ncol(pbmc)))
print(qc.summary)

write.csv(qc.summary, "results/seurat/qc_summary.csv")
saveRDS(pbmc, "results/seurat/pbmc_before_qc.rds")

capture.output(
  sessionInfo(),
  file = "results/seurat/sessionInfo_qc.txt"
)
