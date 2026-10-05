library(Seurat)
library(ggplot2)

pbmc <- readRDS("results/seurat/pbmc_before_qc.rds")

# Count cells failing each initial threshold
print(paste("Cells before filtering:", ncol(pbmc)))
print(paste("Below 200 genes:", sum(pbmc$nFeature_RNA < 200)))
print(paste("Above 5000 genes:", sum(pbmc$nFeature_RNA > 5000)))
print(paste("Above 20% mitochondrial:", sum(pbmc$percent.mt > 20)))

# Apply initial QC thresholds
pbmc <- subset(
  pbmc,
  subset = nFeature_RNA >= 200 &
           nFeature_RNA <= 5000 &
           percent.mt <= 20
)

print(paste("Cells after filtering:", ncol(pbmc)))

qc.plot <- VlnPlot(
  pbmc,
  features = c("nFeature_RNA", "nCount_RNA", "percent.mt"),
  pt.size = 0,
  ncol = 3,
  layer = "counts"
)

ggsave(
  "results/seurat/qc_after_filtering.png",
  plot = qc.plot,
  width = 12,
  height = 4,
  dpi = 300
)

saveRDS(pbmc, "results/seurat/pbmc_after_qc.rds")
