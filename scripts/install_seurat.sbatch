#!/bin/bash
#SBATCH --job-name=install_seurat
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/install_seurat_%j.out
#SBATCH --error=logs/install_seurat_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

# Install R, Seurat, and plotting packages
conda create -p ./envs/seurat \
    -c conda-forge -c bioconda \
    --strict-channel-priority \
    r-base=4.4 \
    r-seurat=5 \
    r-ggplot2 \
    r-patchwork \
    -y

# Check the installed versions
./envs/seurat/bin/Rscript -e \
    'library(Seurat); print(packageVersion("Seurat")); sessionInfo()'
