#!/bin/bash
#SBATCH --job-name=pbmc_markers
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=logs/pbmc_markers_%j.out
#SBATCH --error=logs/pbmc_markers_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

export OMP_NUM_THREADS=2
export OPENBLAS_NUM_THREADS=2

./envs/seurat/bin/Rscript scripts/04_markers.R
