#!/bin/bash
#SBATCH --job-name=pbmc_index
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --time=06:00:00
#SBATCH --output=logs/pbmc_index_%j.out
#SBATCH --error=logs/pbmc_index_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

# Unpack the annotation and keep the compressed original
gunzip -c reference/refdata-gex-GRCh38-2024-A/genes/genes.gtf.gz \
    > reference/refdata-gex-GRCh38-2024-A/genes/genes.gtf

mkdir -p reference/star_index

# Build the STAR genome index
./envs/star/bin/STAR \
    --runMode genomeGenerate \
    --runThreadN 24 \
    --genomeDir reference/star_index \
    --genomeFastaFiles reference/refdata-gex-GRCh38-2024-A/fasta/genome.fa \
    --sjdbGTFfile reference/refdata-gex-GRCh38-2024-A/genes/genes.gtf \
    --sjdbOverhang 90
