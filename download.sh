#!/usr/local_rwth/bin/zsh
#
#
# =============================================================================
# Job Script
# =============================================================================
#SBATCH --job-name=fastq_download
#SBATCH --output=logs/download-%j.out
#SBATCH --error=logs/download-%j.err
#SBATCH --time=24:00:00
#SBATCH --gres=gpu:1
#SBATCH --mem=150G
#SBATCH --partition=c23g
#SBATCH --cpus-per-task=30
#SBATCH --signal=2
#SBATCH --nodes=1
#SBATCH --export=ALL
#SBATCH --no-requeue
#SBATCH --account=p0020567



# Define the output directory
OUTPUT_DIR="/hpcwork/rwth1209/data/scRNA/Flex/FASTQS_and_BCL/240811_VE30_001000000000808720/FASTQ"

# Your wget command with the -P option to specify the output directory
wget -r --http-user=your_id --http-passwd='YOUR_PASS' --accept=gz -P "$OUTPUT_DIR" https://genomics.rwth-aachen.de/data/240808_Kuenstler_Costa_CompGenomics_scRNAseq/FASTQ/mkfastq/outs/fastq_path/HWTNFDMXY/

