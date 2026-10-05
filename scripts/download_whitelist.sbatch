#!/bin/bash
#SBATCH --job-name=barcode_download
#SBATCH --partition=large
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2G
#SBATCH --time=00:30:00
#SBATCH --output=logs/barcode_download_%j.out
#SBATCH --error=logs/barcode_download_%j.err

set -e

cd "$SLURM_SUBMIT_DIR"

# Download the barcode whitelist for 10x v3
wget -c \
    https://raw.githubusercontent.com/Lab-of-Adaptive-Immunity/cr_whitelists/main/3M-february-2018.txt.gz \
    -P reference

# Unpack the whitelist
gunzip -c reference/3M-february-2018.txt.gz \
    > reference/3M-february-2018.txt

wc -l reference/3M-february-2018.txt
