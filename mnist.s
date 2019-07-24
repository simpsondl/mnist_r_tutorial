#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --mem-per-cpu=4G
#SBATCH --gres=gpu:1
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-user=YourNetID@princeton.edu

module purge
module load anaconda3
module load cudatoolkit/10.0
module load cudnn/cuda-10.0/7.5.0

conda activate mnist

Rscript mnist_classify.R
