function [f Domain_coordinates Bound] = Domain(size_)
    f = struct('x_min', -size_ * 0.5, ...
        'x_max', size_ * 0.5, ...
        'y_min', -size_ * 0.5, ...
        'y_max', size_ * 0.5); % domain range
    % it is a rectangle

    Domain_coordinates = [f.x_min, f.y_min; ...
                    f.x_min, f.y_max; ...
                        f.x_max, f.y_max; ...
                        f.x_max, f.y_min ...
                    ];

    Frac(4) = struct('tag', 0, ...
        'orientation_normal', [0, 1], ...
        'orientation_degree', 90.0 * pi / 180.0, ...
        'length', 5, ...
        'position_x', 0.5, ...
        'position_y', 0.5, ...
        'conductivity', 1, ...
        'ends_x', [0, 0], ...
        'ends_y', [1, 1], ...
        'special_comments', 'None');

    for i = 1:1:4
        % the tag
        Frac(i).tag = i;

        % end
        Frac(i).ends_x(1, 1) = Domain_coordinates(i, 1);
        Frac(i).ends_y(1, 1) = Domain_coordinates(i, 2);
        Frac(i).ends_x(1, 2) = Domain_coordinates(mod(i, 4) + 1, 1);
        Frac(i).ends_y(1, 2) = Domain_coordinates(mod(i, 4) + 1, 2);

        % length
        Frac(i).length = norm([Domain_coordinates(i, :)] - [Domain_coordinates(mod(i, 4) + 1, :)]);

        % conductivity is constant
        Frac(i).conductivity = 1;

        % special comments if necessary
        Frac(i).special_comments = 'something';

        mj = [Domain_coordinates(mod(i, 4) + 1, :)] - [Domain_coordinates(i, :)];
        normal_x = -mj(2);
        normal_y = mj(1);

        if (normal_y < 0)
            normal_y = -normal_y;
            normal_x = -normal_x;
        end
        normal_x = normal_x/norm([normal_x, normal_y]);
        normal_y = normal_y/norm([normal_x, normal_y]);
        
        Frac(i).orientation_normal = [normal_x, normal_y];
        Frac(i).orientation_degree = atan2(normal_y, normal_x) * 180.0 / pi;

        TR = ([Domain_coordinates(i, :)] + [Domain_coordinates(mod(i, 4) + 1, :)]) .* 0.5;
        Frac(i).position_x = TR(1);
        Frac(i).position_y = TR(2);
    end

    Bound = Frac;
end
