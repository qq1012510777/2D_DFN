function f = Trim_fracs(Domain_coordinates, Frac, Bound, Dom)

    NUM_fracs = size(Frac, 2);
    Frac_ends = zeros(NUM_fracs, 4);
    currentPath3 = fileparts(mfilename('fullpath'));
    addpath(genpath([currentPath3, '/Line_intersection']));

    for i = 1:1:NUM_fracs
        Pnts = [];

        for j = 1:4 % left, top, right, bottom

            A = [Frac(i).ends_x(1); Frac(i).ends_y(1)];
            B = [Frac(i).ends_x(2); Frac(i).ends_y(2)];
            C = [Bound(j).ends_x(1); Bound(j).ends_y(1)];
            D = [Bound(j).ends_x(2); Bound(j).ends_y(2)];

            [E, lambda, gamma, isConvex] = lineIntersection(A, B, C, D);
            % story the intersection point
            if (isConvex(1, 1) == 1)
                Pnts = [Pnts; E'];
                Frac(i).if_connect_to_bounds(j) = 1;
            end
        end

        m = size(Pnts, 1);

        if (m == 1)
            % which one is inside the domain
            end1 = [Frac(i).ends_x(1), Frac(i).ends_y(1)];
            end2 = [Frac(i).ends_x(2), Frac(i).ends_y(2)];

            f1 = If_pnt_inside_rectangle(end1, Dom);
            f2 = If_pnt_inside_rectangle(end2, Dom);

            if (f1 == 1 && f2 ~= 1)
                Frac_ends(i, :) = [Frac(i).ends_x(1), Frac(i).ends_y(1), Pnts];
            elseif (f1 ~= 1 && f2 == 1)
                Frac_ends(i, :) = [Frac(i).ends_x(2), Frac(i).ends_y(2), Pnts];
            else
                error('This line should intersect the rectangle with only one intersection point!');
            end

            % which one is inside the domain
        elseif (m == 2)
            Frac_ends(i, :) = [Pnts(1, :), Pnts(2, :)];
        elseif (m == 0)
            % do nothing
            Frac_ends(i, :) = [Frac(i).ends_x(1), Frac(i).ends_y(1), Frac(i).ends_x(2), Frac(i).ends_y(2)];
        else
            error('A line segment cannot intersect a rectangle with more than two points!');
        end

    end

    for i = 1:NUM_fracs

        % end
        Frac(i).truncated_ends_x(1, 1) = Frac_ends(i, 1);
        Frac(i).truncated_ends_y(1, 1) = Frac_ends(i, 2);
        Frac(i).truncated_ends_x(1, 2) = Frac_ends(i, 3);
        Frac(i).truncated_ends_y(1, 2) = Frac_ends(i, 4);

    end

    f = Frac;
end
