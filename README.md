# HPC-Cluster

Scripts for deploying HPC cluster on the cloud
Tested on Azure Cyclecloud with SLURM

The script includes installation for HPL, HPCG benchmark (with cuda 11.0) and CESM (Community Earth System Model)
It assumes you have a directory /data, (default on cyclecloud).

`cyclecloud import_cluster -f slurm_filer`
to import persistent drive template


Installation for GROMACS was tuned manually so I did not include it in the script.
MPI can be enabled with module load mpi/\<mpi flavor\>

We also included the HPL benchmark result of our small cluster - 64.9 TFLOPS

To test if MPI are set up correctly, here's a test program I wrote
https://github.com/du00d/parallel-cluster
