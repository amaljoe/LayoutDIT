#!/bin/bash
#SBATCH --job-name=dgx-job
#SBATCH --partition=dgx
#SBATCH --qos=dgx
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --time=14:00:00

# Print node info
hostname
nvidia-smi


source ./scripts/setup_dgx.sh
./runners/gemma/gemma-uni-rr.sh
./runners/gemma/gemma-moo.sh