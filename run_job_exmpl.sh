#!/usr/local_rwth/bin/zsh

#SBATCH --mem=200G  
#SBATCH --cpus-per-task=30
#SBATCH --time=05:00:00
#SBATCH --signal=2
#SBATCH --nodes=1
#SBATCH --export=ALL
#SBATCH --no-requeue
#SBATCH --partition=c23ms
#SBATCH --account=p0020567
#SBATCH --job-name=test
#SBATCH --output=logs/test-%j.out
#SBATCH --error=logs/test-%j.err
### begin of executable commands


export CONDA_ROOT=$HOME/miniconda3
. $CONDA_ROOT/etc/profile.d/conda.sh
export PATH="$CONDA_ROOT/bin:$PATH"

source activate .../conda_env
python path_to_the/script.py