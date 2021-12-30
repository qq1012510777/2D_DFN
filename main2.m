load([currentPath, '/mesh_2D.mat']);

figure(6); title('DFN mesh'); xlabel('x(m)'); ylabel('y(m)'); hold on
Show_DFN_mesh(JXY_2D, JM_2D, 0);

pressure = Solve_DFN_flow(JXY_2D, JM_2D, Dom, 1, 40, 0);

figure(7); title('DFN pressure field'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_pressure_field(JXY_2D, pressure, Dom);