# naked-singularity

A repository of definition files for building [Singularity](https://sylabs.io/guides/latest/user-guide) 
containers around the software applications, frameworks, and libraries 
you need to run on high-performance computing systems.

## Install Singularity

Install Singularity on your Linux desktop, laptop, or virtual machine. 

```bash
sudo ./naked-singularity.sh install
```

## Build a Singularity container from a definition file

Build a Singularity container from one of the definition files available 
in this repository.

```bash
sudo singularity build ubuntu-18.04.sif definition-files/ubuntu/Singularity.ubuntu-18.04
```

## Download an existing Singularity container

A number of Singularity containers built from definition files in this 
repository are now registered and distributed via the [GitHub Container Registry (GHCR)](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry). 

```bash
singularity pull oras://ghcr.io/mkandes/naked-singularity:ubuntu-20.04
```

You can find a complete list of the Singularity containers available on
the GHCR [here](https://github.com/users/mkandes/packages/container/naked-singularity/versions). 
Each tag listed in this GitHub package corresponds to an individual 
Singularity container built from its matching naked-singularity 
(Singularity.tag) definition file. Note, however, since these containers 
are still built manually and then pushed manually to the GHCR, you 
should not assume a container available from the GHCR was built using 
the latest version of its definition file available in the 
naked-singularity repository. 

## Additional Information

[Singularity Hub was archived](https://vsoch.github.io/2021/singularity-hub-archive). 
Some naked-singularity definition files that you find in this repository 
may still depend on bootstrapping from containers that were built and 
hosted on Singularity Hub prior to it being archived. These definition 
files should continue to be able to pull in these container dependencies 
from the Singularity Hub Archive and build successfully. However, it is
unknown how long the Singularity Hub Archive will be available to 
support these legacy naked-singularity definition files. 

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

2.9.5

## Last Updated

Wednesday, June 29th, 2022
