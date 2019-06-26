#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH -t 00:05:00
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-user=yournetid @princeton.edu

module load anaconda3
module load cudatoolkit/10.0
module load cudnn/cuda-10.0/7.5.0

conda activate mnist

Rscript mnist_classify.R
