load([currentPath, '/mesh_2D.mat']);

conductivity = (1.0e-3)^3.0/12.0;

figure(6); % subplot(1, 3, 1);
title('DFN mesh'); xlabel('x(m)'); ylabel('y(m)'); hold on
Show_DFN_mesh(JXY_2D, JM_2D, 0, Dom);

[pressure top_ele bot_ele] = Solve_DFN_flow(JXY_2D, JM_2D, Dom, conductivity, 100, 20);

figure(7); % subplot(1, 3, 2);
title('DFN pressure field'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_pressure_field(JXY_2D, JM_2D, pressure, Dom);

[inlet, outlet] = Inlet_Outlet_flux(pressure, top_ele, bot_ele, JM_2D, JXY_2D, conductivity)

figure(8); % subplot(1, 3, 3);
title('DFN flux field'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_flux_vec(pressure, JM_2D, JXY_2D, conductivity, Dom);
