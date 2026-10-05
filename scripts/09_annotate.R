library(Seurat)
library(ggplot2)

pbmc <- readRDS("results/seurat/pbmc_singlets_clustered.rds")

# Working labels based on the reviewed marker results
labels <- c(
  "0" = "Classical monocytes",
  "1" = "Naive-like T cells",
  "2" = "IL7R+ helper-like T cells",
  "3" = "Naive-like B cells",
  "4" = "Myeloid cells (mixed)",
  "5" = "Class-switched B cells",
  "6" = "MAIT-like T cells",
  "7" = "Cytotoxic T cells",
  "8" = "NK cells",
  "9" = "Platelets"
)

clusters <- as.character(Idents(pbmc))
pbmc$cell_type <- unname(labels[clusters])

stopifnot(!anyNA(pbmc$cell_type))

# Save the annotated UMAP
p <- DimPlot(
  pbmc,
  group.by = "cell_type",
  label = TRUE,
  repel = TRUE,
  pt.size = 0.5
)

p <- p + labs(
  title = "PBMC 1k: marker-based cell annotations",
  x = "UMAP 1",
  y = "UMAP 2"
)

ggsave(
  "results/seurat/umap_annotated.png",
  plot = p,
  width = 11,
  height = 7,
  dpi = 300,
  bg = "white"
)

# Save cell counts and annotation evidence
cell.counts <- as.data.frame(table(pbmc$cell_type))
colnames(cell.counts) <- c("cell_type", "cells")

write.csv(
  cell.counts,
  "results/seurat/cell_type_counts.csv",
  row.names = FALSE
)

annotation <- data.frame(
  cluster = names(labels),
  cell_type = unname(labels),
  supporting_markers = c(
    "S100A8, S100A12, LYZ",
    "CCR7, LEF1, CD3D, CD3E",
    "IL7R, CD40LG, GATA3",
    "TCL1A, IGHD, MS4A1",
    "FCGR3A, CDKN1C; FCER1A, CD1C, CLEC10A",
    "IGHA1, IGHG1, TNFRSF13B, MS4A1",
    "SLC4A10, KLRB1, RORC",
    "CD3D, CD3E, CD8A, GZMH, GZMK",
    "GNLY, KLRF1, NKG7",
    "PPBP, PF4, GP1BB"
  )
)

write.csv(
  annotation,
  "results/seurat/annotation_evidence.csv",
  row.names = FALSE
)

write.csv(
  pbmc[[]],
  "results/seurat/final_cell_metadata.csv"
)

saveRDS(pbmc, "results/seurat/pbmc_annotated.rds")

capture.output(
  sessionInfo(),
  file = "results/seurat/sessionInfo_final.txt"
)

print(cell.counts)
