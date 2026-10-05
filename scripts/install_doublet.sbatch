#!/bin/bash
#SBATCH --job-name=install_doublet
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/install_doublet_%j.out
#SBATCH --error=logs/install_doublet_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

# Keep doublet detection in a separate environment
conda create -p ./envs/doublet \
    -c conda-forge -c bioconda \
    --strict-channel-priority \
    r-base=4.4 \
    bioconductor-scdblfinder \
    -y

./envs/doublet/bin/Rscript -e \
    'library(scDblFinder); print(packageVersion("scDblFinder"))'
