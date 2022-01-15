load([currentPath, '/mesh_2D.mat']);

% figure(6); % subplot(1, 3, 1);
% title('DFN mesh'); xlabel('x(m)'); ylabel('y(m)'); hold on
% Show_DFN_mesh(JXY_2D, JM_2D, 0, Dom);

[pressure top_ele bot_ele] = Solve_DFN_flow(JXY_2D, JM_2D, Dom, 1, 500, 20);

% figure(7); % subplot(1, 3, 2);
% title('DFN pressure field'); xlabel('x(m)'); ylabel('y(m)'); hold on
% Plot_pressure_field(JXY_2D, JM_2D, pressure, Dom);

[inlet, outlet] = Inlet_Outlet_flux(pressure, top_ele, bot_ele, JM_2D, JXY_2D, 1)

% figure(8); % subplot(1, 3, 3);
% title('DFN flux field'); xlabel('x(m)'); ylabel('y(m)'); hold on
% Plot_flux_vec(pressure, JM_2D, JXY_2D, 1, Dom);

[node_s, ele_s, num_particles_] = Inject_particles(Dom, JXY_2D, JM_2D, 50, 'even');
target_ele = Identify_target_eles(JXY_2D, JM_2D, Dom);
Adja_mat = sparse(size(JXY_2D, 1), size(JXY_2D, 1));

for i = 1:size(JM_2D, 1)
    Adja_mat(JM_2D(i, 1), JM_2D(i, 2)) = i;
    Adja_mat(JM_2D(i, 2), JM_2D(i, 1)) = i;
end

time_step = 800;
delta_t = 0.0025;

location_particles(sum(num_particles_)) = struct("location", [0, 0]);

Num = 0;

for ik = 1:size(node_s, 1)
    %-----------------------------------
    for j = 1:num_particles_(ik)
        Num = Num + 1;

        x0 = node_s(ik, 1);
        y0 = node_s(ik, 2);
        ele0 = ele_s(ik);
        location_ = zeros(time_step, 2);

        If_target = 0;

        for i = 1:time_step
            % figure(8)
            % scatter(x0, y0, 'o', 'fill'); hold on;
            location_(i, :) = [x0, y0];

            if (If_target == 0)
                [x1, y1, ele1, If_target] = One_particle_moves(x0, y0, ele0, delta_t, ...
                    JXY_2D, JM_2D, Adja_mat, pressure, 1, target_ele);

                x0 = x1;
                y0 = y1;
                ele0 = ele1;
            end

            %             if (If_target == 1)
            %                 time_step = i;
            %                 break
            %             end

        end

        %         location_([time_step + 1:end], :) = [];
        %-----------------------------------
        location_particles(Num).location = location_;
    end

end

figure(9)
title('DFN particles movements'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_particles_movement(JXY_2D, JM_2D, pressure, Dom, location_particles, time_step);
