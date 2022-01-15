function f = Plot_flux_vec(pressure, JM, JXY, conductivity, Dom)

    pos = [];
    vector_flux = [];

    for i = 1:size(JM, 1)
        node1 = JM(i, 1);
        node2 = JM(i, 2);

        h1 = max(pressure(node1), pressure(node2));
        h2 = min(pressure(node1), pressure(node2));

        center = (JXY(node1, :) + JXY(node2, :)) .* 0.5;

        vec = [];

        flux = conductivity * (h1 - h2) / norm(JXY(node1, :) - JXY(node2, :));

        h_t1 = pressure(node1);

        if (h_t1 ~= h1)
            vec = (JXY(node1, :) - JXY(node2, :)) / norm((JXY(node1, :) - JXY(node2, :)));
        else
            vec = (JXY(node2, :) - JXY(node1, :)) / norm((JXY(node1, :) - JXY(node2, :)));
        end

        pos = [pos; center];

        vector_flux = [vector_flux; vec .* flux];

        x = [JXY(JM(i, 1), 1), JXY(JM(i, 2), 1)];
        y = [JXY(JM(i, 1), 2), JXY(JM(i, 2), 2)];
        z = [0 0];
        col = [flux, flux];
        surface([x; x], [y; y], [z; z], [col; col], ...
            'facecol', 'no', ...
            'edgecol', 'flat', ...
            'linew', 5); hold on;
    end

    colorbar

    hold on
    quiver(pos(:, 1), pos(:, 2), vector_flux(:, 1), vector_flux(:, 2), 3, 'color', 'k'); hold on
    f = 0;

    Domain_coordinates = [Dom.x_min, Dom.y_min; ...
                        Dom.x_min, Dom.y_max; ...
                        Dom.x_max, Dom.y_max; ...
                        Dom.x_max, Dom.y_min ...
                    ];
    plot([Domain_coordinates(:, 1); Domain_coordinates(1, 1)], [Domain_coordinates(:, 2); Domain_coordinates(1, 2)], 'r-', 'linewidth', 3);
    hold on;
end
