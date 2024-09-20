CXX = CC
CFLAG = -cuda -O2

mpi_gpu	:mpi_gpu_tasks.cpp
	$(CXX) -o mpi_gpu $(CFLAG) $<

clean:
	rm -rf mpi_gpu
