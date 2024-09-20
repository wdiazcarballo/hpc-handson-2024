#!/bin/sh

#PBS -q normal
#PBS -l select=1:ngpus=1
#PBS -l walltime=1:00:00

### Specify project code
### e.g. 41000001 was the pilot project code
### Job will not submit unless this is changed
#PBS -P <ProjectId>


### Specify name for job
#PBS -N jupyter-test

### Standard output by default goes to file $PBS_JOBNAME.o$PBS_JOBID
### Standard error by default goes to file $PBS_JOBNAME.e$PBS_JOBID
### To merge standard output and error use the following
#PBS -j oe

### Start of commands to be run

# Change directory to where job was submitted
cd $PBS_O_WORKDIR || exit $?

# Docker image to use for container
#   To see available images run command: nscc-docker images
#   If image is not present, email help@nscc.sg to request pulling image into repository on 

# if choose use your env.
# module load miniconda3
# conda activate mytorch

module load singularity

# Change this number, port 8888 is default and may clash with other users
PORT=$(shuf -i8000-8999 -n1)

# Launch JupyterLab, listen on all interfaces on port $PORT
export TERM=ansi

# Choose the hostname of the login node
#loginnode=aspire2a.nus.edu.sg    # if in NUS
#loginnode=aspire2antu.nscc.sg    # if in NTU
#loginnode=aspire2a.a-star.edu.sg # if in A*STAR
loginnode=aspire2a.sutd.edu.sg   # if in SUTD


echo -e "\n"  >> stdout.$PBS_JOBID
echo -e "\n"  >> stdout.$PBS_JOBID
echo  " Paste ssh command in a terminal on local host (i.e., laptop)" >> stdout.$PBS_JOBID
echo  " ------------------------------------------------------------" >> stdout.$PBS_JOBID
echo -e " ssh -N -L $PORT:`hostname`:$PORT $USER@${loginnode}\n"    >> stdout.$PBS_JOBID
echo  " Open this address in a browser on local host; see token below">> stdout.$PBS_JOBID
echo  " ------------------------------------------------------------" >> stdout.$PBS_JOBID
echo -e " localhost:$PORT \n\n"                                       >> stdout.$PBS_JOBID



singularity  exec --nv -B /scratch,/app /app/apps/containers/pytorch/pytorch-nvidia-22.04-py3.sif jupyter-lab \
	--no-browser --ip=0.0.0.0 --port=$PORT \
        >> sshtunnel.$PBS_JOBID 2> jpylab.$PBS_JOBID 



### Notebook is now running on compute node
### However you cannot directly access port
### There are two methods that you can use
### 1. ssh port forwarding
### 2. reverse proxy (FRP, etc.)

### Using reverse proxies is a security risk, user is responsible for any data loss or unauthorized access.

### ssh port forwarding
### On local machine use ssh port forwarding to tunnel to node and port where job is running:
###   ssh -L$PORT:$HOST:$PORT login.asp2a.nscc.sg     ### e.g. ssh -L8888:x1000c0s1b0n1:8888 login.asp2a.nscc.sg
### On local machine go to http://localhost:$PORT and use token from found in file stderr.$PBS_JOBID
### Alternatively, pass a pre-determined token using --NotebookApp.token=... (visible to ps command on node)
