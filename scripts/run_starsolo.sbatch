#!/bin/bash
#SBATCH --job-name=pbmc_starsolo
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=64G
#SBATCH --time=06:00:00
#SBATCH --output=logs/pbmc_starsolo_%j.out
#SBATCH --error=logs/pbmc_starsolo_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

mkdir -p results/starsolo

# R2 contains the transcript sequence
# R1 contains the cell barcode and UMI
# Both lane lists must be in the same order

./envs/star/bin/STAR \
    --runThreadN 24 \
    --genomeDir reference/star_index \
    --readFilesIn \
    data/raw/pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L001_R2_001.fastq.gz,data/raw/pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L002_R2_001.fastq.gz \
    data/raw/pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L001_R1_001.fastq.gz,data/raw/pbmc_1k_v3_fastqs/pbmc_1k_v3_S1_L002_R1_001.fastq.gz \
    --readFilesCommand zcat \
    --soloType CB_UMI_Simple \
    --soloCBwhitelist reference/3M-february-2018.txt \
    --soloCBstart 1 \
    --soloCBlen 16 \
    --soloUMIstart 17 \
    --soloUMIlen 12 \
    --soloStrand Forward \
    --soloFeatures Gene \
    --soloCBmatchWLtype 1MM_multi_Nbase_pseudocounts \
    --soloUMIfiltering MultiGeneUMI_CR \
    --soloUMIdedup 1MM_CR \
    --soloCellFilter EmptyDrops_CR 1000 0.99 10 45000 90000 500 0.01 20000 0.01 10000 \
    --outSAMtype None \
    --outFileNamePrefix results/starsolo/
