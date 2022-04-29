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

# purge existing modules
ml purge
# load modules
ml gcc/10.2.0
ml anaconda
conda activate isce2

# select files in correct places for ion corr
# add the correct upper and lower bounds for your dataset
s1_select_ion.py -dir ./slc -sn 65.505836/67.561638 -nr 10

#then run the stack senintel to make the run files 
# no need to have an orbits directory as it will download automatically
# need to have slc/ dem/ aux_dir/
stackSentinel.py -s slc/ -d dem/glo_30.dem.wgs84 -a aux_dir/ -o orbits/ -b '65.505836 67.561638 -55.494823 -49.108829' -c 4 -p hv --param_ion ./ion_param.txt --num_connections_ion 3

# move to runfiles directory
cd run_files/

### JH ADD AND HAS TESTED ON SUMMIT AND SEEMS TO WORK WELL ###
### adds echo commands to start an end of each run file to make it easier to see where we get to if fail / timeout 
ls run* > run_list
# add text to start of file so you know the section.
for f in $(cat run_list) ; do sed -i "1s/^/echo '${f} START'\n/" ${f}; done
# then add the ending text to end of script.
for i in $(cat run_list) ; do echo "echo '${i} END'" >> ${i} ; done 

# now submit sbatch runs for each run file, but make sure it holds the first one until the next

# be sure to put wait flags in the sbatch header and parallel things
# create an example batch file with and without parallization
sbatch run_01.sh 
sbatch run_02.sh
sbatch run_03.sh
sbatch run_04.sh
sbatch run_05.sh
sbatch run_06.sh
sbatch run_07.sh
sbatch run_08.sh
sbatch run_09.sh
sbatch run_10.sh
sbatch run_11.sh
sbatch run_13.sh
sbatch run_14.sh
sbatch run_15.sh
sbatch run_16.sh
sbatch run_17.sh
sbatch run_18.sh
sbatch run_19.sh
sbatch run_20.sh
sbatch run_21.sh
sbatch run_22.sh
sbatch run_23.sh
sbatch run_24.sh




