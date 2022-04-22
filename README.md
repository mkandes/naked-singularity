# naked-singularity

A repository of definition files for building 
[Singularity](https://sylabs.io/guides/latest/user-guide) containers
around the software applications, frameworks, and libraries you need to
run on high-performance computing systems.

## Install Singularity

Install Singularity on your Linux desktop, laptop, or virtual machine. 

```bash
sudo ./naked-singularity.sh install
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

IMPORTANT: [Singularity Hub has been archived](https://vsoch.github.io/2021/singularity-hub-archive). 
For the time being, naked-singularity definition files that rely on 
containers that were built and hosted on Singularity Hub prior to it 
being archived will continue to pull in these container dependencies and
build properly. Note, however, new pre-built containers of the latest 
naked-singularity definition files are currently being updated to be 
hosted via the [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry).


## Status

A work in progress.
   
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

2.2.9

## Last Updated

Friday, April 22nd, 2022
