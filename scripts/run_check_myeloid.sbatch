#!/bin/bash
#SBATCH --job-name=check_myeloid
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=16G
#SBATCH --time=01:00:00
#SBATCH --output=logs/check_myeloid_%j.out
#SBATCH --error=logs/check_myeloid_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

export OMP_NUM_THREADS=2
export OPENBLAS_NUM_THREADS=2

./envs/seurat/bin/Rscript scripts/08_check_myeloid.R
