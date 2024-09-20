#!/bin/bash 
# Exercise 1 submission script - submit.sh 
# Below, is the queue 
#PBS -q normal 
#PBS -j oe 
#PBS -l select=1:ncpus=1:mem=1G 
#PBS -l walltime=00:10:00 
#PBS -P <projectId>
#PBS -N linear_program 

# Commands start here 
cd ${PBS_O_WORKDIR} 
module load tensorflow/2.8.1-py3
python linear.py 
