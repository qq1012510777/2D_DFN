function f = Plot_one_particle_movement(JXY, JM, Pressure, Dom, location_)
    %[X, Y] = meshgrid(Dom.x_min:(Dom.x_max - Dom.x_min) / 100:Dom.x_max, ...
    %    Dom.y_min:(Dom.y_max - Dom.y_min) / 100:Dom.y_max);
    %
    %Ptr = griddata(JXY(:, 1), JXY(:, 2), full(Pressure), X, Y, 'linear');
    %
    %hold on
    %contourf(X, Y, Ptr); view(2); colorbar; hold on
    %
    Domain_coordinates = [Dom.x_min, Dom.y_min; ...
                    Dom.x_min, Dom.y_max; ...
                        Dom.x_max, Dom.y_max; ...
                        Dom.x_max, Dom.y_min ...
                    ];
    plot([Domain_coordinates(:, 1); Domain_coordinates(1, 1)], [Domain_coordinates(:, 2); Domain_coordinates(1, 2)], 'r-', 'linewidth', 3);
    hold on;

    for i = 1:size(JM, 1)
        x = [JXY(JM(i, 1), 1), JXY(JM(i, 2), 1)];
        y = [JXY(JM(i, 1), 2), JXY(JM(i, 2), 2)];
        z = [0 0];
        col = [Pressure(JM(i, 1)), Pressure(JM(i, 2))];
        surface([x; x], [y; y], [z; z], [col; col], ...
            'facecol', 'no', ...
            'edgecol', 'interp', ...
            'linew', 1); hold on;
    end
    colorbar; hold on
    ph = scatter(location_(1, 1), location_(1, 2), 'k', 'o', 'filled'); 
    pause(0.05)

    for i = 2:size(location_, 1)
        ph.XData = location_(i, 1);         %change x coordinate of the point
        ph.YData = location_(i, 2);         %change y coordinate of the point
        drawnow
        pause(0.05)  %control speed, if desired
    end
    f = 0;
end
