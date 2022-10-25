function f = Plot_DFN_clusters(Domain_coordinates, Cluster, Frac, string_i)
    plot([Domain_coordinates(:, 1); Domain_coordinates(1, 1)], [Domain_coordinates(:, 2); Domain_coordinates(1, 2)], 'r-', 'linewidth', 3);
    hold on;

    [k1, l1] = size(Cluster);

    Frac_coordinates = [];
    NUM_fracs = size(Frac, 2);

    for i = 1:1:NUM_fracs
        if (string_i == "truncated")
            Frac_coordinates(i, 1) = Frac(i).truncated_ends_x(1);
            % Frac_coordinates(i, 2) = Frac(i).position_x;
            Frac_coordinates(i, 3) = Frac(i).truncated_ends_x(2);

            Frac_coordinates(i, 4) = Frac(i).truncated_ends_y(1);
            % Frac_coordinates(i, 5) = Frac(i).position_y;
            Frac_coordinates(i, 6) = Frac(i).truncated_ends_y(2);
        else
            Frac_coordinates(i, 1) = Frac(i).ends_x(1);
            Frac_coordinates(i, 2) = Frac(i).position_x;
            Frac_coordinates(i, 3) = Frac(i).ends_x(2);

            Frac_coordinates(i, 4) = Frac(i).ends_y(1);
            Frac_coordinates(i, 5) = Frac(i).position_y;
            Frac_coordinates(i, 6) = Frac(i).ends_y(2);
        end
    end

    for i = 1:1:l1
        [o1, p1] = size(Cluster(i).cluster);

        color_ = [rand rand rand];

        if (p1 ~= 0)

            for j = 1:1:o1
                Frac_ID = Cluster(i).cluster(j);
                if (string_i == "truncated")
                    line(Frac_coordinates(Frac_ID, [1, 3]), Frac_coordinates(Frac_ID, [4, 6]), 'linestyle', '-', 'color', color_, 'linewidth', 2);                
                else
                    line(Frac_coordinates(Frac_ID, 1:3), Frac_coordinates(Frac_ID, 4:6), 'linestyle', '-', 'color', color_, 'linewidth', 2);
                end
                hold on;
            end

        end

    end

    f = 0;
end
