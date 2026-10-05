#!/bin/bash
#SBATCH --job-name=pbmc_doublets
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=logs/pbmc_doublets_%j.out
#SBATCH --error=logs/pbmc_doublets_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

export OMP_NUM_THREADS=2
export OPENBLAS_NUM_THREADS=2

./envs/doublet/bin/Rscript scripts/05_doublets.R
