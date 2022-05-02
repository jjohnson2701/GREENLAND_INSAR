#!/bin/bash

# Written by: jaha2600@colorado.edu
# Date: 20220421
# Purpose: This script submits a job on RMACC Summit. Can be used with other HPC systems if SBATCH/scheduling commands are changed.   
#SBATCH --account=      # Summit allocation
#SBATCH --partition=shas    # Summit partition
#SBATCH --qos=                # Summit qos
#SBATCH --time=24:00:00           # Max wall time
#SBATCH --nodes=1          # Number of Nodes
#SBATCH --ntasks=24          # Number of tasks per job

#SBATCH --job-name=sstack      # Job submission name
#SBATCH --mail-type=END            # Email user when job finishes
#SBATCH --mail-user=jaha2600@colorado.edu # Email address of user

ml purge
ml gcc/10.2.0
ml anaconda
ml gnu_parallel
conda activate isce2

# --delay .2 prevents overloading the controlling node
# -j is the number of tasks parallel runs so we set it to 24 (the number of steps we want to run)
# --joblog makes parallel create a log of tasks that it has already run
# --resume makes parallel use the joblog to resume from where it has left off
# the combination of --joblog and --resume allow jobs to be resubmitted if necessary and continue from where they left off

# submit each line in 
parallel --delay .2 -j $SLURM_NTASKS --joblog logs/runtask2.log --resume -a run_02_unpack_secondary_slc



# lifted from RMACC guide
#my_parallel="parallel --delay .2 -j $SLURM_NTASKS"
##my_srun="srun --export=all --exclusive -n1 --cpus-per-task=1 --cpu-bind=cores"
#$my_parallel "$my_srun ./run_02_......" ::: {1..20}