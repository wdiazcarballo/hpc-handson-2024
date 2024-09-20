#!/bin/bash 
# Exercise 2 submission script - submit.sh 
# Below, is the queue 
#PBS -q normal
#PBS -j oe 
#PBS -l select=1:ngpus=1
#PBS -l walltime=00:10:00 
#PBS -P <projectId>
#PBS -N fashion_program 

# Commands start here 
module load tensorflow/2.8.1-py3-gpu
cd ${PBS_O_WORKDIR} 
python fashion.py 
