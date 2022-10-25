function [f1 f2] = IfParticleArrivedNodes(ParticleIDmoves,ParticlesArray_GPU, ...
    trajectory_length_GPU, Dis_Position_endNode_GPU, JXY_GPU)
    % f1 is bool value vector, 1 = encountering node
    % f2 = remainning length of trajectory
    
    ParticlesArray_GPU_moves = ParticlesArray_GPU(ParticleIDmoves, :);
        
    length_remanning_GPU = trajectory_length_GPU(ParticleIDmoves, :) - Dis_Position_endNode_GPU(ParticleIDmoves, :);
    
    a = find(length_remanning_GPU > 0);
    
    f1 = gpuArray(zeros(size(ParticlesArray_GPU, 1), 1));
    
    f1(ParticleIDmoves(a), 1) = 1;
    
    f2 = gpuArray(zeros(size(ParticlesArray_GPU, 1), 1));
    
    f2(ParticleIDmoves(a), 1) = length_remanning_GPU(a, 1);
end