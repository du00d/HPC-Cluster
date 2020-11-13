# HPC-Cluster

Scripts for deploying HPC cluster on the cloud
Tested with Azure Cyclecloud with SLURM

The script includes installation for HPL, HPCG benchmark (with cuda 11.0) and CESM (Community Earth System Model)
Installation for GROMACS was tuned manually so I did not include it in the script.
MPI can be enabled with module load mpi/\<mpi flavor\>

We also included the HPL benchmark result of our small cluster - 65 TFLOPS