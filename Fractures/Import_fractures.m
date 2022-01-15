function f = Import_fractures(S)
    Frac(1) = struct('tag', 0, ...
        'orientation_normal', [0, 1], ...
        'orientation_degree', 90.0 * pi / 180.0, ...
        'length', 5, ...
        'position_x', 0.5, ...
        'position_y', 0.5, ...
        'conductivity', 1, ...
        'ends_x', [0, 0], ...
        'ends_y', [1, 1], ...
        'truncated_ends_x', [0, 0], ...
        'truncated_ends_y', [1, 1], ...
        'special_comments', 'None', ...
        'if_connect_to_bounds', [0, 0, 0, 0] ... % left, top, right, bottom
    );
    Num_Fracs = S.Num_fracs;

    for i = 1:1:Num_Fracs
        % the tag
        Frac(i).tag = i;

        eval(['Frac(i).ends_x(1, 1) = S.Frac_', num2str(i), '_x(1);']);
        eval(['Frac(i).ends_y(1, 1) = S.Frac_', num2str(i), '_z(1);']);
        eval(['Frac(i).ends_x(1, 2) = S.Frac_', num2str(i), '_x(2);']);
        eval(['Frac(i).ends_y(1, 2) = S.Frac_', num2str(i), '_z(2);']);

        F1 = [Frac(i).ends_x(1, 1), Frac(i).ends_y(1, 1)];
        F2 = [Frac(i).ends_x(1, 2), Frac(i).ends_y(1, 2)];
        % length
        Frac(i).length = norm(F1 - F2);

        % conductivity is constant
        Frac(i).conductivity = 1;

        % special comments if necessary
        Frac(i).special_comments = 'something';

        mj = F2 - F1;
        normal_x = -mj(2);
        normal_y = mj(1);

        if (normal_y < 0)
            normal_y = -normal_y;
            normal_x = -normal_x;
        end

        normal_x = normal_x / norm([normal_x, normal_y]);
        normal_y = normal_y / norm([normal_x, normal_y]);

        Frac(i).orientation_normal = [normal_x, normal_y];
        Frac(i).orientation_degree = atan2(normal_y, normal_x) * 180.0 / pi;

        TR = (F1 + F2) .* 0.5;
        Frac(i).position_x = TR(1);
        Frac(i).position_y = TR(2);

        Frac(i).if_connect_to_bounds = [0, 0, 0, 0];
    end

    f = Frac;
end
