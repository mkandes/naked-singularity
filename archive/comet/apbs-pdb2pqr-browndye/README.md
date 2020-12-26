# Singularity container for molecular electrostatic calculations using PDB2PQR/APBS and Brownian dynamics with BrownDye.

This singularity image contains a complete software environment for running [BrownDye (version 1 and 2)](http://browndye.ucsd.edu/) simulations. It also includes [PDB2PQR](http://www.poissonboltzmann.org/) and [APBS](http://www.poissonboltzmann.org/).

Please [register](http://eepurl.com/by4eQr) your use of APBS and PDB2PQR.

## Using the container

Pull the singularity image:
```
singularity pull shub://nbcrrolls/electrostatics-singularity
```

Start bash shell in the container:
```
singularity shell nbcrrolls-electrostatics-singularity-master-latest.simg
```

Now the container is running and we can start a BrownDye2 job (using the Thrombin example):

```
cp -ai $BD2_PATH/examples/thrombin .
cd thrombin
sed -i 's/-PE0//g' *
make all
```

And if you want to use BrownDye version 1:

```
export PATH=$BD1_PATH/bin:$PATH
cp -ai $BD1_PATH/thrombin-example .
cd thrombin-example
sed -i 's/-PE0//g' *
make all
bd_top input.xml
nam_simulation t-m-simulation.xml # this takes about 20min to run
cat results.xml
```
After we are finished we can quit the container:

    exit

You can also access individual applications from the electrostatics container.

To list available applications:

```
$ singularity apps nbcrrolls-electrostatics-singularity-master-latest.simg 
apbs
make_rxn_pairs
nam_simulation
pdb2pqr
pqr2xml
we_simulation
xyz_trajectory
```

To run, for example, apbs calculation:
```
singularity exec nbcrrolls-electrostatics-singularity-master-latest.simg apbs input.in
```

or

```
singularity run --app apbs nbcrrolls-electrostatics-singularity-master-latest.simg input.in
```


This Singularity image is hosted on Singularity Hub: [![https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg](https://www.singularity-hub.org/static/img/hosted-singularity--hub-%23e32929.svg)](https://singularity-hub.org/collections/2497)



###### This project is supported by [NBCR](http://nbcr.ucsd.edu).
