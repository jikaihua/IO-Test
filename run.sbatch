#!/bin/bash

# Use command "sbatch run.sbatch" to submit job
# This is an example for submitting sbatch job to discovery cluster
# Please refer to "http://nuweb12.neu.edu/rc/?page_id=18#gpujobs" for more details

#SBATCH --job-name=IO_Test
#SBATCH --output=output.txt
#SBATCH --error=output.err
#SBATCH -N 1                       # number of node (1 GPU per node in Discovery).
#SBATCH -n 48                      # number of MPI process
#SBATCH --exclusive
#SBATCH --partition karma_gpu      
work=/home/ji.ka/test/thermalDrift/New_Par/Multi         # Please change the directory 
cd $work


nvcc IO_Test.cu

./a.out >> output.txt
