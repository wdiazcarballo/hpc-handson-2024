#!/bin/bash
#SBATCH -p normal                # Partition (queue) name
#SBATCH -N 1                     # Number of nodes
#SBATCH --ntasks=64              # Total number of tasks (MPI processes)
#SBATCH --cpus-per-task=1        # Number of OpenMP threads per MPI process
#SBATCH -t 00:10:00              # Job runtime limit
#SBATCH -J mpi_job               # Job name
#SBATCH -A cb900901              # Project account

# Load necessary modules
module purge
module load cray-mpich

# Print the hostname of the node
echo "Print Hostname"
hostname

# Show loaded modules
echo -e "\n\nWhich modules are loaded in this job:"
module list 2>&1

# Navigate to the directory where the job was submitted
cd ${SLURM_SUBMIT_DIR}
echo -e "My work folder is $PWD\n\n"

# Print some job information
echo "The job $SLURM_JOB_NAME is running on $SLURM_JOB_NODELIST."

# Show the version of the C compiler
cc --version

# Run the MPI program
srun ./mpihello
