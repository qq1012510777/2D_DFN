First, compile Gmsh c++ api in directory './Gmsh_script' by using './Gmsh_script/compile_and_run.sh'

Then, just run main1.m main2.m main3.m main4.m
 
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------

After the generation of fractures, the mesh is done by Gmsh C++ API.

This is just a toy script!

Some creations of objects are inefficient, e.g. fractures, because matlab language is not good at for-loop.

Actually, they should be created vectorizedly.

Vectorized data makes MATLAB run simulation very fast (and probably comparable to c++ and cuda). 

But I am too lazy to change it.

Fortunately, the most time-consuming part, i.e. particle tracking, is implemented on GPU and based on vectorized data.

Author: Tingchang Yin
Email: yintingchang@foxmail.com