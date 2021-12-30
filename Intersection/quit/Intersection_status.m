% this function returens the interesction status of two fractures
% 0 = no intersection
% 1 = intersect
% 2 = overlapping
% k = [interesction status, x, y], x and y are the intersection point
% if overlapping, k = [interesction status, x1, y1, x2, y2]
function k = Intersection_status(frac1_end1_x, frac1_end1_y, ...
        frac1_end2_x, frac1_end2_y, ...
        frac2_end1_x, frac2_end1_y, ...
        frac2_end2_x, frac2_end2_y, ...
        orientation_degree1, orientation_degree2, ...
        center1x, center1y, ...
        center2x, center2y)

    Frac1 = [];
    Frac2 = [];
    f = Quaternion_Rotation(orientation_degree1, 0, 0, -1, frac1_end1_x - center1x, frac1_end1_y - center1y, 0);
    Frac1(1, :) = f;

    f = Quaternion_Rotation(orientation_degree1, 0, 0, -1, frac1_end2_x - center1x, frac1_end2_y - center1y, 0);
    Frac1(2, :) = f;

    f = Quaternion_Rotation(orientation_degree1, 0, 0, -1, frac2_end1_x - center1x, frac2_end1_y - center1y, 0);
    Frac2(1, :) = f;

    f = Quaternion_Rotation(orientation_degree1, 0, 0, -1, frac2_end2_x - center1x, frac2_end2_y - center1y, 0);
    Frac2(2, :) = f;

    s = 0;
    %kxi = 0;
    if ((Frac2(1, 2) >= 0 && Frac2(2, 2) <= 0) || (Frac2(1, 2) <= 0 && Frac2(2, 2) >= 0))
        s = 1;
    end

    if (s == 0)
        k = [0];
    else
        p = Intersection_of_a_line_seg_with_x_axis(Frac2(1, 1), Frac2(1, 2), Frac2(2, 1), Frac2(2, 2));
        [s, u] = size(p);

        if (s + u == 1)
            k = 0;
        else
            [m, n] = size(p);

            if (m == 1 && n == 2)

                if ((p(1) < Frac1(1, 1) && p(1) > Frac1(2, 1)) || (p(1) > Frac1(1, 1) && p(1) < Frac1(2, 1)))
                    k = [1, p(1), p(2)];
                    %kxi = 1;
                    %disp('+');
                else
                    k = 0;
                end

            else
                R = range_intersection([Frac1(1, 1), Frac1(2, 1)], [p(1, 1), p(2, 1)]);
                k = [2, R(1), 0, R(2), 0];
            end

        end

    end

    [m, n] = size(k);

    if (m == 1 && n == 3)

        f = Quaternion_Rotation(orientation_degree1, 0, 0, 1, k(2), k(3), 0);
        k = [1, f(1) + center1x, f(2) + center1y];
    else if (m == 1 && n == 5)
        f1 = Quaternion_Rotation(orientation_degree1, 0, 0, 1, k(2), k(3), 0);
        f2 = Quaternion_Rotation(orientation_degree1, 0, 0, 1, k(4), k(5), 0);
        k = [2, f1(1) + center1x, f1(2) + center1y, f2(1) + center1x, f2(2) + center1y];
    end

end
