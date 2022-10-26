clc;
close all;
clear all;

currentPath = fileparts(mfilename('fullpath'));
% get the current path of the .m file

addpath(genpath([currentPath, '/Quaternion']));
addpath(genpath([currentPath, '/Intersection']));
addpath(genpath([currentPath, '/Cluster']));
addpath(genpath([currentPath, '/Domain']));
addpath(genpath([currentPath, '/Fractures']));
addpath(genpath([currentPath, '/Plot_DFN']));
addpath(genpath([currentPath, '/Geometry']));
addpath(genpath([currentPath, '/Mesh']));
addpath(genpath([currentPath, '/Solve']));
addpath(genpath([currentPath, '/Particle_Tracking']));

load([currentPath, '/main1_data.mat']);
load([currentPath, '/mesh_2D.mat']);

conductivity = (1.0e-3)^3.0/12.0;

figure(6); % subplot(1, 3, 1);
pbaspect([1 1 1]);
title('DFN mesh'); xlabel('x(m)'); ylabel('y(m)'); hold on
Show_DFN_mesh(JXY_2D, JM_2D, 0, Dom);

[pressure top_ele bot_ele] = Solve_DFN_flow(JXY_2D, JM_2D, Dom, conductivity, 100, 20);

figure(7); % subplot(1, 3, 2);
pbaspect([1 1 1]);
title('DFN pressure field'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_pressure_field(JXY_2D, JM_2D, pressure, Dom);

[inlet, outlet] = Inlet_Outlet_flux(pressure, top_ele, bot_ele, JM_2D, JXY_2D, conductivity)

figure(8); % subplot(1, 3, 3);
pbaspect([1 1 1]);
title('DFN flux field'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_flux_vec(pressure, JM_2D, JXY_2D, conductivity, Dom);
xlim([-0.5 * domain_size, 0.5 * domain_size])
ylim([-0.5 * domain_size, 0.5 * domain_size])
