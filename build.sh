#!/bin/bash

# load necessarily modules
module load libtool/2.4.7
module load binutils/2.40

export CC=cc
export CFLAGS='-O3 -g -Wall -Wextra -Werror -std=c99'
export LDFLAGS='-O3 -g -L/opt/cray/pe/lib64/cce -lu'
export CXX=CC
export CXXFLAGS='-O3 -g'
export LD_LIBRARY_PATH=/opt/cray/pe/lib64/cce/lib:$LD_LIBRARY_PATH

export PREFIX=/project/cb900901-cbtucs/app

./configure  --build=x86_64-suse-linux --host=x86_64-suse-linux \
  --prefix=${PREFIX}/extrae/4.2.1 \
  --with-mpi=/opt/cray/pe/mpich/8.1.27/ofi/crayclang/14.0 \
  --with-binary-type=64 \
  --with-xml-prefix=/lustrefs/disk/modules/easybuild/software/libxml2/2.11.4-cpeCray-23.03 \
  --enable-sampling \
  --enable-shared \
  --enable-openmp \
  --with-binutils=/lustrefs/disk/modules/easybuild/software/binutils/2.40 \
  --with-papi=/opt/cray/pe/papi/7.0.1.1 \
  --with-boost=/lustrefs/disk/modules/easybuild/software/Boost/1.82.0-cpeCray-23.03 \
  --without-unwind \
  --without-dyninst
