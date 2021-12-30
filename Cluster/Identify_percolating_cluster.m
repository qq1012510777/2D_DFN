function f = Identify_percolating_cluster(Frac, Cluster)
    f = [];
    m = size(Cluster, 2);

    for i = 1:m
        TOP = 0;
        BOT = 0;

        for j = 1:size(Cluster(i).cluster, 1)
            FracID = Cluster(i).cluster(j);

            if (Frac(FracID).if_connect_to_bounds(2) == 1)
                TOP = 1;
            end

            if (Frac(FracID).if_connect_to_bounds(4) == 1)
                BOT = 1;
            end

            if (TOP == 1 && BOT == 1)
                f = [f, i];
                break;
            end

        end

    end

end
