# Lysozyme-in-Water - MD-Simulation

Repository contains the resource for running the MD Simulation of Lysozyme in water using a single bash script. The workflow invloves the setting up the system (protein) in the box, neutralization with the ions, energy minimization, nvt equilibration, npt equilibration and production run using the GROMACS-2024 patched with PLUMED-2.11.0-dev (GPU Version)

1aki.pdb - Intial structure of the systme (https://www.rcsb.org/structure/1aki)
topol.top - Topology file of the 1AKI struture 
ions.mdp,em.mdp,nvt.mdp,npt.mdp,md.mdp - All the parameter files for the md simulation. (all the paramter files are taken from - http://www.mdtutorials.com/gmx/lysozyme/)
run_gromacs.sh - bash script to automate the entire MD Simulation. 

The script was tested in the (GROMACS-2024.3 patched with PLUMED-2.11.0_dev \ 2024.3-plumed_2.11.0_dev) with 2 threads in one GPU.
