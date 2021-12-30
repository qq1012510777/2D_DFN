function f = Plot_pressure_field(JXY, Pressure, Dom)
    [X, Y] = meshgrid(Dom.x_min:(Dom.x_max - Dom.x_min) / 100:Dom.x_max, ...
        Dom.y_min:(Dom.y_max - Dom.y_min) / 100:Dom.y_max);

    Ptr = griddata(JXY(:, 1), JXY(:, 2), full(Pressure), X, Y);

    hold on
    contourf(X, Y, Ptr); view(2); colorbar
end
