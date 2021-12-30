#!/bin/bash
cd Gmsh_script
cd bin
rm -rf main
cd ..
cd build 
rm -rf CMakeCache.txt  CMakeFiles  cmake_install.cmake  Makefile
cd ../..
rm -rf Lines.mat mesh_2D.mat