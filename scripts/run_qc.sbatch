#!/bin/bash
#SBATCH --job-name=pbmc_qc
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=logs/pbmc_qc_%j.out
#SBATCH --error=logs/pbmc_qc_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

./envs/seurat/bin/Rscript scripts/01_qc.R
