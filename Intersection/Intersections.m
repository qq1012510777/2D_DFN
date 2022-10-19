function f = Intersections(Frac, string_i)
    Intersections(1) = struct('frac1_tag', 0, ...
        'frac2_tag', 0, ...
        'intersection', [NaN, NaN]); % initialize a vector of structs to story the intersection point and the tags of the two fractures

    currentPath3 = fileparts(mfilename('fullpath'));
    addpath(genpath([currentPath3, '/Line_intersection']));

    NUM_Intersections = 0;
    A = []; B = []; C = []; D = [];
    Tag = [];
    % now, check the intersections
    NUM_fracs = size(Frac, 2);

    for i = 1:1:NUM_fracs - 1

        for j = i + 1:1:NUM_fracs

            if (string_i == "truncated")
                A = [A, [Frac(i).truncated_ends_x(1); Frac(i).truncated_ends_y(1)]];
                B = [B, [Frac(i).truncated_ends_x(2); Frac(i).truncated_ends_y(2)]];
                C = [C, [Frac(j).truncated_ends_x(1); Frac(j).truncated_ends_y(1)]];
                D = [D, [Frac(j).truncated_ends_x(2); Frac(j).truncated_ends_y(2)]];
            else
                A = [A, [Frac(i).ends_x(1); Frac(i).ends_y(1)]];
                B = [B, [Frac(i).ends_x(2); Frac(i).ends_y(2)]];
                C = [C, [Frac(j).ends_x(1); Frac(j).ends_y(1)]];
                D = [D, [Frac(j).ends_x(2); Frac(j).ends_y(2)]];
            end

            Tag = [Tag, [i; j]];
        end

    end

    [E, lambda, gamma, isConvex] = lineIntersection(A, B, C, D);

    for i = 1:size(isConvex, 2)

        if (isConvex(1, i) == 1)
            NUM_Intersections = NUM_Intersections + 1;

            Intersections(NUM_Intersections).frac1_tag = Tag(1, i);
            Intersections(NUM_Intersections).frac2_tag = Tag(2, i);
            Intersections(NUM_Intersections).intersection = E(:, i)';
        end

    end

    f = Intersections;
end
