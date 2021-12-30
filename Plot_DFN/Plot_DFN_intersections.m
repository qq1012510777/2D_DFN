function f = Plot_DFN_intersections(Domain_coordinates, Frac, Intersections_)
    hold on
    plot([Domain_coordinates(:, 1); Domain_coordinates(1, 1)], [Domain_coordinates(:, 2); Domain_coordinates(1, 2)], 'r-', 'linewidth', 3);
    hold on;

    Frac_coordinates = [];
    NUM_fracs = size(Frac, 2);

    for i = 1:1:NUM_fracs
        Frac_coordinates(i, 1) = Frac(i).ends_x(1);
        Frac_coordinates(i, 2) = Frac(i).position_x;
        Frac_coordinates(i, 3) = Frac(i).ends_x(2);

        Frac_coordinates(i, 4) = Frac(i).ends_y(1);
        Frac_coordinates(i, 5) = Frac(i).position_y;
        Frac_coordinates(i, 6) = Frac(i).ends_y(2);
    end

    for i = 1:1:NUM_fracs
        plot(Frac_coordinates(i, 1:3), Frac_coordinates(i, 4:6), 'b-', 'linewidth', 1, 'markersize', 2);
        hold on;
    end

    [m, n] = size(Intersections_);
    Intersection_points = [];

    for i = 1:1:n
        Intersection_points(i, :) = Intersections_(i).intersection;
    end

    scatter(Intersection_points(:, 1), Intersection_points(:, 2), '*');
    f = 0;
end
