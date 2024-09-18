#!/bin/bash
#SBATCH --job-name=IterRef
#SBATCH --partition=fx700

export GCC_VER=gcc-10.3.0
export FX700_DIR=/cloud_opt/a64fx/non-support/hpc/fx700/${GCC_VER}
export LD_LIBRARY_PATH=${FX700_DIR}/lib:${FX700_DIR}/lib64:${LD_LIBRARY_PATH}

OMP_NUM_THREADS=48 numactl -C0-47 --interleave=0-3 ./test.exe 7000 8

echo 1core
OMP_NUM_THREADS=1  numactl -C0-47 --interleave=0-3 ./test.exe 7000 4
echo 2cores
OMP_NUM_THREADS=2  numactl -C0-47 --interleave=0-3 ./test.exe 7000 4
echo 4cores
OMP_NUM_THREADS=4  numactl -C0-47 --interleave=0-3 ./test.exe 7000 4
echo 12cores
OMP_NUM_THREADS=12 numactl -C0-47 --interleave=0-3 ./test.exe 7000 4
echo 24cores
OMP_NUM_THREADS=24 numactl -C0-47 --interleave=0-3 ./test.exe 7000 4
echo 36cores
OMP_NUM_THREADS=36 numactl -C0-47 --interleave=0-3 ./test.exe 7000 4
echo 48cores
OMP_NUM_THREADS=48 numactl -C0-47 --interleave=0-3 ./test.exe 7000 4

