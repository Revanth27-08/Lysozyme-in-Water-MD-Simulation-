#!/bin/bash

source ~/source_gpu_gromacs.sh

#Intial setup for the gromacs simulation
#Download all the neccessary files (pdb,.mdp files in keep in the working directory)

#Forcefield generation for the protein
mkdir top
cd top
mv ../1aki_clean.pdb .
gmx_mpi pdb2gmx -f 1aki_clean.pdb -o protein.gro -water tip3p -ff charmm27

#Box generation for the protein
gmx_mpi editconf -f protein.gro -o boxed.gro -c -d 1.0 -bt cubic
cd ..

#Solvate the protein
mkdir solv
cd solv
gmx_mpi solvate -cp ../top/boxed.gro -cs spc216.gro -p ../top/topol.top -o solvated.gro
cd ..

#Neutral with the ion concentraion
mkdir ion
cd ion
mv ../ions.mdp .
touch ions.mdp
gmx_mpi grompp -f ions.mdp -c ../solv/solvated.gro -p ../top/topol.top -o ions.tpr
echo SOL | gmx_mpi genion -s ions.tpr -o ionized.gro -p ../top/topol.top -neutral -conc 0.1
cd ..

#Energy_minimization
mkdir min
cd min
mv ../em.mdp .
gmx_mpi grompp -f em.mdp -p ../top/topol.top -c ../ion/ionized.gro -o em.tpr
export OMP_NUMP_THREADS=2
mpiexec -n 1 gmx_mpi mdrun -v -s em.tpr -deffnm em 
cd ..

#NVT_equilibration(2ns equilibration run)
mkdir nvt
cd nvt
mv ../nvt.mdp .
gmx_mpi grompp -f nvt.mdp -c ../min/em.gro -p ../top/topol.top -r ../min/em.gro -o nvt.tpr 
export OMP_NUMP_THREADS=2
mpiexec -n 1 gmx_mpi mdrun -s nvt.tpr -deffnm nvt -nsteps 1000000 -pin on -pinoffset 8 -gpu_id 1
cd ..

#NPT_equlibration(2ns equilibration run)
mkdir npt
cd npt
mv ../npt.mdp .
gmx_mpi grompp -f npt.mdp -c ../nvt/nvt.gro -p ../top/topol.top -r ../nvt/nvt.gro -o npt.tpr 
export OMP_NUMP_THREADS=2
mpiexec -n 1 gmx_mpi mdrun -s npt.tpr -deffnm npt -nsteps 1000000 -pin on -pinoffset 8 -gpu_id 1
cd ..

#Production_run(2ns production run [vary the -nsteps according to the simulation time needed])
mkdir prod
cd prod
mv ../prod.mdp .
gmx_mpi grompp -f prod.mdp -c ../npt/npt.gro -r ../npt/npt.gro -o prod.tpr -p ../top/topol.top
export OMP_NUMP_THREADS=2
mpiexec -n 1 gmx_mpi mdrun -s prod.tpr -deffnm prod -nsteps 1000000 -pin on -pinoffset 8 -gpu_id 1
cd ..
