function f = IfParticlesArrivedTargetPlane(ParticleIDmoves, LowPressureEnd_GPU, JXY_GPU, ...
     Dom_y_min)
        
    % f = bool value vector, 1 = arrived
    Node_arrived_GPU = LowPressureEnd_GPU(ParticleIDmoves, :);
    
    a = find(abs(JXY_GPU(Node_arrived_GPU, 2) - Dom_y_min) < 1e-5);
    
    reachedTargetParticleID = ParticleIDmoves(a, :);
    
    f = gpuArray(zeros(size(LowPressureEnd_GPU, 1), 1));
    
    f(reachedTargetParticleID, :) = 1; 
end