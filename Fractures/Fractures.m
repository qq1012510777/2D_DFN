function f = Fractures(Dom, NUM_fracs, len)
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
    % initialize a vector of struct
    % to record attributes of fractures

    % now, randomly generate NUM_fracs fractures, and record them
    for i = 1:1:NUM_fracs
        % the tag
        Frac(i).tag = i;

        % let us generate the position of the barycenter of a fracture first
        % barycenters distribute in the domain uniformly
        % 'rand' function generates a value in [0,1] uniformly
        a = Dom.x_min; % lower x, domain range
        b = Dom.x_max; % upper x
        x = a + (b - a) * rand;
        a = Dom.y_min; % lower y, domain range
        b = Dom.y_max; % upper y
        y = a + (b - a) * rand;
        Frac(i).position_x = x;
        Frac(i).position_y = y;

        % then address the orientation
        % still uniform distribution
        % we use the normal vector of a fracture to represent the orientations first
        normal_x = -1 + (1 - (-1)) * rand; % random value within [-1, 1]
        normal_y = -1 + (1 - (-1)) * rand;

        if (normal_y < 0)
            normal_y = -normal_y;
            normal_x = -normal_x;
        end % this treatment has the normal vector alway points to the upper circle, i.e., y always > 0

        Frac(i).orientation_normal = [normal_x, normal_y];
        % now, express the orientation in polar system
        Frac(i).orientation_degree = atan2(normal_y, normal_x) * 180.0 / pi;
        % disp(Frac(i).orientation_degree);

        % for length, also, only uniform distribution
        Frac(i).length = 0.5 + (len - 0.5) * rand;

        % now, the coordinates of the two ends
        % the line equation is k x + c + h y = 0
        % k = normal_x, h = normal_y
        % but we move the barycenter of the fracture to (0,0), so c = 0
        x1 = Frac(i).length / 2;
        x2 = Frac(i).length / 2 * -1;
        f1 = Quaternion_Rotation(Frac(i).orientation_degree, 0, 0, 1, x1, 0, 0);
        f1 = f1 + [Frac(i).position_x, Frac(i).position_y, 0];
        Frac(i).ends_x(1, 1) = f1(1);
        Frac(i).ends_y(1, 1) = f1(2);
        f2 = Quaternion_Rotation(Frac(i).orientation_degree, 0, 0, 1, x2, 0, 0);
        f2 = f2 + [Frac(i).position_x, Frac(i).position_y, 0];
        Frac(i).ends_x(1, 2) = f2(1);
        Frac(i).ends_y(1, 2) = f2(2);

        Frac(i).if_connect_to_bounds = [0, 0, 0, 0];
        % conductivity is constant
        Frac(i).conductivity = 1;

        % special comments if necessary
        Frac(i).special_comments = 'something';

    end

    f = Frac;
end
