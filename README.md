# naked-singularity

A repository of definition for building 
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

The naked-singularity project is currently undergoing a major 
restructuring of the repository. Significant changes over the next few 
weeks should be expected.

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

1.2.3

## Last Updated

Thursday, December 31st, 2020
