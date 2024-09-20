#!/bin/bash 
# Below, is the queue 
#PBS -q ai
#PBS -j oe 
# Number of cores 
#PBS -l select=1:ngpus=1
#PBS -l walltime=00:25:00 
#PBS -P <projectId>
#PBS -N convolution_program 

# Start of commands
cd $PBS_O_WORKDIR
module load singularity/3.10.0
image="/app/apps/containers/tensorflow/tensorflow-nvidia-22.04-tf2-py3.sif" 

singularity run --nv -B /scratch,/app,/data $image python convolution.py

