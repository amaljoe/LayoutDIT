#!/bin/bash
#SBATCH --job-name=l40-job
#SBATCH --partition=l40
#SBATCH --qos=l40
#SBATCH --nodes=1
#SBATCH --gres=gpu:4
#SBATCH --time=04:00:00

# Print node info
hostname
nvidia-smi

# eval "$(ssh-agent -s)" && ssh-add /home/compiling-ganesh/24m0797/.ssh/id_ed25519

nohup /usr/sbin/sshd -f ~/.ssh/sshd_config_user > ~/.ssh/sshd.log 2>&1 &
echo "✅ sshd started in background on port 4422"

cd workspace/online-data-mixing-for-finetuning/
source scripts/setup_dgx.sh 
jupyter lab