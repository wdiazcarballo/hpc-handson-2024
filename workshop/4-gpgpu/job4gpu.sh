#!/bin/bash

#PBS -l select=1:mpiprocs=4:ngpus=4
#PBS -l place=scatter
#PBS -l walltime=4:00:00
#PBS -o log/
#PBS -j oe
#PBS -P <projectId>
#PBS -q normal
#PBS -N gpux4

cd $PBS_O_WORKDIR || exit $? 
[ -d log ] || mkdir log  
module swap PrgEnv-cray PrgEnv-nvhpc
module rm cray-libsci
echo $CUDA_VISIBLE_DEVICES
# make
mpirun --label -np 4 ./mpi_gpu

