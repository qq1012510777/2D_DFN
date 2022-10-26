function [f1 f2 f3 f4 f5] = MoveOneStep_GPU(ParticleIDmoves, ParticlesArray_GPU, JXY_GPU, JM_GPU, pressure_GPU, conductivity, delta_t_w)
    % f1 = updated ParticlesArray_GPU
    % f2 = trajectory lenth GPU
    % f3 = nodes of low pressure of the current element
    % f5 = velocities of current element
    
    ParticlesArray_GPU_moves = ParticlesArray_GPU(ParticleIDmoves, :);
    delta_t = delta_t_w(ParticleIDmoves, 1);
    
    node1_GPU = JM_GPU(ParticlesArray_GPU_moves(:, 2), 1);
    node2_GPU = JM_GPU(ParticlesArray_GPU_moves(:, 2), 2);
    
    sign_GPU = pressure_GPU(node2_GPU, 1) - pressure_GPU(node1_GPU, 1);
    sign_GPU = sign_GPU ./ abs(sign_GPU);
    
    endnodeEle_GPU = sign_GPU; % end nodes (with lower pressure) of elements 
    as = find(endnodeEle_GPU == 1);
    bs = find(endnodeEle_GPU == -1);
    endnodeEle_GPU(as) = node1_GPU(as);
    endnodeEle_GPU(bs) = node2_GPU(bs);

    directial_vec_GPU = JXY_GPU(node1_GPU, :) - JXY_GPU(node2_GPU, :);
    directial_vec_GPU = directial_vec_GPU ./ [vecnorm(directial_vec_GPU')]';
    directial_vec_GPU = sign_GPU .* directial_vec_GPU;

    length_GPU = [vecnorm([JXY_GPU(node2_GPU, :) - JXY_GPU(node1_GPU, :)]')]';
    veclocity_GPU = abs(conductivity .* (pressure_GPU(node2_GPU, 1) - pressure_GPU(node1_GPU, 1)) ...
        ./ length_GPU);
    veclocity_GPU = veclocity_GPU ./ ((conductivity * 12) ^ (1.0/3.0));
    d_x_GPU = veclocity_GPU .* delta_t;
    
    Dis_pre_Position_endNode_GPU = ...
        [vecnorm([ParticlesArray_GPU_moves(:, [3, 4]) - JXY_GPU(endnodeEle_GPU, :)]')]';
    
    ParticlesArray_GPU_moves(:, [3, 4]) = ParticlesArray_GPU_moves(:, [3, 4]) + ...
       directial_vec_GPU .* d_x_GPU; 
   
    f1 = ParticlesArray_GPU;
    f1(ParticleIDmoves, :) = ParticlesArray_GPU_moves;
    
    f2 = gpuArray(zeros(size(ParticlesArray_GPU, 1), 1));
    f2(ParticleIDmoves, 1) = d_x_GPU;
    
    f3 = gpuArray(zeros(size(ParticlesArray_GPU, 1), 1));
    f3(ParticleIDmoves, 1) = endnodeEle_GPU;
    
    f4 = gpuArray(zeros(size(ParticlesArray_GPU, 1), 1));
    f4(ParticleIDmoves, 1) = Dis_pre_Position_endNode_GPU;
        
    f5 = gpuArray(zeros(size(ParticlesArray_GPU, 1), 1));
    f5(ParticleIDmoves, 1) = veclocity_GPU;
end