# naked-singularity

A repository of definition files for building 
[Singularity](https://sylabs.io/guides/latest/user-guide) containers
around the software applications, frameworks, and libraries you need to
run on high-performance computing systems.

## Install Singularity

Install Singularity on your Linux desktop, laptop, or virtual machine. 

```bash
./naked-singularity.sh install
```

## Build a Singularity container from a definition file

Build an Ubuntu Singularity container from one of the definition files
available in this repository.

```bash
sudo singularity build ubuntu.sif definition-files/ubuntu/Singularity.ubuntu-18.04
```

## Download an existing Singularity container

A number of pre-built containers from this repository are also now 
hosted at Singularity Hub.

```bash
singularity pull shub://mkandes/naked-singularity:ubuntu-18.04
```

## Status

A work in progress. But an important note on the immediate future ...
   
The future availablity of Singularity Hub is currently unknown and
may be slated for retirement as early as April 2021. If and when
Singularity Hub is retired, the current set of naked-sinularity 
definition files will be affected due to the recent move in the past
year to using a layered dependency chain of multiple containers built
and hosted on Singularity Hub. Alternative container build and hosting
options are currently under consideration. This upcoming change will 
likely affect how a given container's dependency chain is rebuilt and 
supported long-term.

## Contribute

If you would like to contribute one of your own Singularity container
definition files for a specific application OR request a modification to
an existing container definition, then please submit a pull request.

## Author

Marty Kandes, Ph.D.  
Computational & Data Science Research Specialist  
High-Performance Computing User Services Group  
San Diego Supercomputer Center  
University of California, San Diego  

## Version

1.2.4

## Last Updated

Tuesday, January 12th, 2021
