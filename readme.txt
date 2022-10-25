First, run main1.m, 
then, bash Run_gmsh.h,
next run main2.m, 
finally run main3.m.

After the generation of fractures, the mesh is done by Gmsh C++ API.

This is just a toy script!

Some creations of objects are inefficient, e.g. fractures, because matlab language is not good at for-loop.

Actually, they should be created in form of matrix or vector or array.

But I am too lazy to change it.

Fortunately, the most time-consuming part, i.e. particle tracking, is implemented on GPU, which is based on matrices and arrays.

Author: Tingchang Yin
Email: yintingchang@foxmail.com