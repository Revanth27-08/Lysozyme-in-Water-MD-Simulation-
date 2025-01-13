# Lysozyme-in-Water - MD-Simulation

Repository contains the resource for running the MD Simulation of Lysozyme in water using a single bash script. The workflow invloves the setting up the system (protein) in the box, neutralization with the ions, energy minimization, nvt equilibration, npt equilibration and production run using the GROMACS-2024 patched with PLUMED-2.11.0-dev with 2 threads in one GPU.

- 1aki.pdb - Intial structure of the system (https://www.rcsb.org/structure/1aki)
- topol.top - Topology file of the 1AKI struture 
- ions.mdp,em.mdp,nvt.mdp,npt.mdp,md.mdp - All the parameter files for the md simulation. (all the parameter files are taken from - http://www.mdtutorials.com/gmx/lysozyme/)
- run_gromacs.sh - bash script to automate the entire MD Simulation. 

