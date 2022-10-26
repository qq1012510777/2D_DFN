function [f1 f2] = WhereParticlesGoNext(ParticleID_moves, Adja_list_GPU, LowPressureEnd_GPU, pressure_GPU, conductivity_, ...
    JXY_GPU, JM_GPU)
    % f1 = next element id
    % f2 = next element node id
    PressureOfPresentNode_GPU = pressure_GPU(LowPressureEnd_GPU(ParticleID_moves, 1), 1);
    
%     if(isempty(ParticleID_moves)==0)
%         asd = LowPressureEnd_GPU(ParticleID_moves, 1);
%         scatter(JXY_GPU(asd, 1), JXY_GPU(asd, 2), 'o', 'cyan', 'filled'); 
%         hold on
%     end
    
    f2 = LowPressureEnd_GPU(ParticleID_moves, 1);
    
    LocalAdj_list_GPU = Adja_list_GPU(LowPressureEnd_GPU(ParticleID_moves, 1), :);
    
    maxmumAdjNum = max(LocalAdj_list_GPU(:, 1));
    
    Local_Velocity_GPU = ones(size(LocalAdj_list_GPU, 1), maxmumAdjNum) .* -1;
    
    for i = 1:maxmumAdjNum
        
        as = find(isnan(LocalAdj_list_GPU(:, i + 1)) ~= 1);
                
        Local_Velocity_GPU(as, i) = conductivity_ .* (PressureOfPresentNode_GPU(as, 1) - pressure_GPU(LocalAdj_list_GPU(as, i + 1), 1)) ...
            ./ [vecnorm([JXY_GPU(LowPressureEnd_GPU(ParticleID_moves(as, 1), 1), :) - JXY_GPU(LocalAdj_list_GPU(as, i + 1), :)]')]';
        Local_Velocity_GPU(as, i) = Local_Velocity_GPU(as, i) ./ ((conductivity_ * 12.0)^(1.0/3.0));
    end
    
    af = find(Local_Velocity_GPU(:, 1) == -1);
    
    if(isempty(af) == 0)
        error('One node at least connects to one another node')
    end
    
    af = find(Local_Velocity_GPU(:, :) < 0);
    
    Local_Velocity_GPU(af) = 0;
    
    TotalFlux = gpuArray(sum(Local_Velocity_GPU, 2));
    
    % Local_Velocity_GPU(af) = NaN;
    
    for i = 1:maxmumAdjNum
        if i == 1
            Local_Velocity_GPU(:, i) = Local_Velocity_GPU(:, i) ./ TotalFlux;
        else
            Local_Velocity_GPU(:, i) = Local_Velocity_GPU(:, i) ./ TotalFlux + Local_Velocity_GPU(:, i - 1); 
        end
    end
    
    rand__ = gpuArray(rand(size(Local_Velocity_GPU, 1), 1));
    
    NextNode_GPU = gpuArray(zeros(size(Local_Velocity_GPU, 1), 1));
        
    cond = bsxfun(@gt, Local_Velocity_GPU, rand__);
    [ok, idx] = max(cond, [], 2);
    cs = ok .* Local_Velocity_GPU((1:numel(idx))'+numel(idx)*(idx-1));
    if(sum(ismember(0, cs)) > 1)
        error('Cannot find which element to go next 2')
    end
    NextNode_GPU = LocalAdj_list_GPU([1:1:size(LocalAdj_list_GPU, 1)]' + idx .* size(LocalAdj_list_GPU, 1));
       
    [a, idx1] = ismember([LowPressureEnd_GPU(ParticleID_moves, 1), NextNode_GPU], JM_GPU, 'rows');
    [b, idx2] = ismember([NextNode_GPU, LowPressureEnd_GPU(ParticleID_moves, 1)], JM_GPU, 'rows');
    
    element_nexnode = [idx1 + idx2];
    
    f1 = element_nexnode; % next element
end