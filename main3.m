close all

filename = "ParticleTrackingData_";
filename = filename + datestr(clock);
filename = regexprep(filename, ' ', '_');
filename = [currentPath, '/data/', char(filename)];
mkdir(filename)

NumParticles = 1000;
ParticlesArray = zeros(NumParticles, 5);

[node_s, ele_s, num_particles_, ParticlesArray] = Inject_particles(Dom, JXY_2D, JM_2D, NumParticles, conductivity, pressure, ...
"flux_weighted");
NumParticles = sum(num_particles_);
ParticlesArray(:, 1) = [1:1:NumParticles]';
ParticlesArray(:, 5) = zeros(NumParticles, 1);

Adja_list = Adjacent_list(JM_2D, 6, size(JXY_2D, 1));

time_step = 10;
delta_t_o = 1e6;

Adja_list_GPU = gpuArray(Adja_list);
JM_GPU = gpuArray(JM_2D);
JXY_GPU = gpuArray(JXY_2D);
pressure_GPU = gpuArray(pressure);

figure(9); % subplot(1, 3, 2);
title('PT'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_pressure_field(JXY_2D, JM_2D, pressure, Dom); hold on
s1 = scatter(ParticlesArray(:, 3), ParticlesArray(:, 4), 'o', 'k', 'filled');
save([filename, '/ParticlePositionTimeStep_', num2str(0, '%010d'), '.mat'], 'ParticlesArray')

pbaspect([1 1 1]);
disp('press ENTER to continue ......')
pause
% particle tracking
for i = 1:time_step
    ko = find(ParticlesArray(:, 5) == 1);
    ParticlesArray(ko, :) = [];

    ParticlesArray_GPU = gpuArray(ParticlesArray);

    ParticleID_moves = [1:size(ParticlesArray_GPU, 1)];

    [ParticlesArray_GPU, trajectory_length_GPU, LowPressureEnd_GPU, Dis_pre_Position_endNode_GPU, ...
            flux_rate_GPU] = ...
        MoveOneStep_GPU(ParticleID_moves, ParticlesArray_GPU, JXY_GPU, JM_GPU, pressure_GPU, conductivity, ...
        delta_t_o .* gpuArray(ones(size(ParticlesArray, 1), 1)));

    [Bool_ParticleEncounteringNode_GPU, RemainningLength_GPU] = IfParticleArrivedNodes(ParticleID_moves, ParticlesArray_GPU, ...
        trajectory_length_GPU, Dis_pre_Position_endNode_GPU, JXY_GPU);

    ParticleID_moves = find(Bool_ParticleEncounteringNode_GPU ~= 0);

    Bool_ArrivedParticle_GPU = IfParticlesArrivedTargetPlane(ParticleID_moves, LowPressureEnd_GPU, JXY_GPU, ...
        Dom.y_min);

    ArrivedParticleID = find(Bool_ArrivedParticle_GPU == 1);

    ParticlesArray_GPU(ArrivedParticleID, 5) = 1;
    ParticlesArray_GPU(ArrivedParticleID, [3, 4]) = JXY_GPU(LowPressureEnd_GPU(ArrivedParticleID), :);

    [bool_a, idx_b] = ismember(ArrivedParticleID, ParticleID_moves);
    ParticleID_moves(idx_b) = [];

    % now address where particles go next
    delta_t = gpuArray(zeros(size(ParticlesArray_GPU, 1), 1) + delta_t_o);
    delta_t(ParticleID_moves, 1) = delta_t(ParticleID_moves, 1) - Dis_pre_Position_endNode_GPU(ParticleID_moves, 1) ./ flux_rate_GPU(ParticleID_moves, 1);
    AK = 1;

    if (isempty(ParticleID_moves) == 1)
        AK = 0;
    end

    while AK == 1

        [nextelement nextelement_nodeID] = WhereParticlesGoNext(ParticleID_moves, Adja_list_GPU, LowPressureEnd_GPU, pressure_GPU, conductivity, ...
            JXY_GPU, JM_GPU);
        ParticlesArray_GPU(ParticleID_moves, [3, 4]) = JXY_GPU(nextelement_nodeID, :);
        ParticlesArray_GPU(ParticleID_moves, 2) = nextelement;

        [ParticlesArray_GPU, trajectory_length_GPU, LowPressureEnd_GPU, Dis_pre_Position_endNode_GPU, ...
                flux_rate_GPU] = ...
            MoveOneStep_GPU(ParticleID_moves, ParticlesArray_GPU, JXY_GPU, JM_GPU, pressure_GPU, conductivity, ...
            delta_t);

        [Bool_ParticleEncounteringNode_GPU, RemainningLength_GPU] = IfParticleArrivedNodes(ParticleID_moves, ParticlesArray_GPU, ...
            trajectory_length_GPU, Dis_pre_Position_endNode_GPU, JXY_GPU);

        ParticleID_moves = find(Bool_ParticleEncounteringNode_GPU ~= 0);

        if (isempty(ParticleID_moves) == 1)
            AK = 0;
            continue
        end

        Bool_ArrivedParticle_GPU = IfParticlesArrivedTargetPlane(ParticleID_moves, LowPressureEnd_GPU, JXY_GPU, ...
            Dom.y_min);

        ArrivedParticleID = find(Bool_ArrivedParticle_GPU == 1);

        ParticlesArray_GPU(ArrivedParticleID, 5) = 1;
        ParticlesArray_GPU(ArrivedParticleID, [3, 4]) = JXY_GPU(LowPressureEnd_GPU(ArrivedParticleID), :);

        [bool_a, idx_b] = ismember(ArrivedParticleID, ParticleID_moves);
        ParticleID_moves(idx_b) = [];

        if (isempty(ParticleID_moves) == 1)
            AK = 0;
            continue
        end

        delta_t(ParticleID_moves, 1) = delta_t(ParticleID_moves, 1) - Dis_pre_Position_endNode_GPU(ParticleID_moves, 1) ./ flux_rate_GPU(ParticleID_moves, 1);
    end

    clear trajectory_length_GPU  LowPressureEnd_GPU  Dis_pre_Position_endNode_GPU  flux_rate_GPU
    clear Bool_ParticleEncounteringNode_GPU RemainningLength_GPU Bool_ArrivedParticle_GPU ArrivedParticleID
    clear nextelement nextelement_nodeID
    ParticlesArray = gather(ParticlesArray_GPU);
    clear ParticlesArray_GPU ParticleID_moves
    delete(s1)

    save([filename, '/ParticlePositionTimeStep_', num2str(i, '%010d'), '.mat'], 'ParticlesArray')

    figure(9)
    title(['PT, time step = ', num2str(i)]); hold on
    s1 = scatter(ParticlesArray(:, 3), ParticlesArray(:, 4), 'o', 'k', 'filled'); hold on
    pause(0.2)
end
