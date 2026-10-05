#!/bin/bash
#SBATCH --job-name=install_star
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --output=logs/install_star_%j.out
#SBATCH --error=logs/install_star_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

# Install STAR in a separate environment
conda create -p ./envs/star \
    -c conda-forge -c bioconda \
    --strict-channel-priority \
    star=2.7.11b -y


./envs/star/bin/STAR --version
