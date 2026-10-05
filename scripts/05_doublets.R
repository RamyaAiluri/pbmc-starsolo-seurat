library(Matrix)
library(SingleCellExperiment)
library(scDblFinder)
library(BiocParallel)

set.seed(123)

# Load the STARsolo counts and barcodes
counts <- readMM(
  "results/starsolo/Solo.out/Gene/filtered/matrix.mtx"
)

barcodes <- read.delim(
  "results/starsolo/Solo.out/Gene/filtered/barcodes.tsv",
  header = FALSE
)

colnames(counts) <- barcodes$V1

# Load metadata for the cells retained after QC
metadata <- read.csv(
  "results/seurat/cluster_metadata.csv",
  row.names = 1
)

# Keep the same cells in the same order
stopifnot(all(rownames(metadata) %in% colnames(counts)))
counts <- counts[, rownames(metadata)]

# Remove genes with no counts in these cells
counts <- counts[rowSums(counts) > 0, ]

sce <- SingleCellExperiment(
  assays = list(counts = counts)
)

# Treat both sequencing lanes as one cell capture
sce <- scDblFinder(
  sce,
  BPPARAM = SerialParam()
)

# Save predictions alongside the existing cluster labels
results <- data.frame(
  barcode = colnames(sce),
  cluster = metadata$seurat_clusters,
  doublet_score = sce$scDblFinder.score,
  doublet_class = sce$scDblFinder.class
)

write.csv(
  results,
  "results/seurat/doublet_predictions.csv",
  row.names = FALSE
)

print(table(results$doublet_class))
print(table(results$cluster, results$doublet_class))

capture.output(
  sessionInfo(),
  file = "results/seurat/sessionInfo_doublets.txt"
)
