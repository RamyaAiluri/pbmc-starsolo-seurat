#!/bin/bash
#SBATCH --job-name=download_pbmc
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=06:00:00
#SBATCH --output=logs/download_pbmc_%j.out
#SBATCH --error=logs/download_pbmc_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

# Download the raw FASTQ archive
wget -c \
    https://cf.10xgenomics.com/samples/cell-exp/3.0.0/pbmc_1k_v3/pbmc_1k_v3_fastqs.tar \
    -P data/raw

# Extract the FASTQ files
tar -xf data/raw/pbmc_1k_v3_fastqs.tar -C data/raw

# Download the human reference package
wget -c \
    https://cf.10xgenomics.com/supp/cell-exp/refdata-gex-GRCh38-2024-A.tar.gz \
    -P reference

# Extract the reference
tar -xzf reference/refdata-gex-GRCh38-2024-A.tar.gz -C reference

echo "Downloads and extraction finished"
