function k = Intersection_of_a_line_seg_with_x_axis(frac1_end1_x, frac1_end1_y, ...
        frac1_end2_x, frac1_end2_y)

    if (abs(frac1_end1_y) < 1e-5 && abs(frac1_end2_y) < 1e-5)
        k = [frac1_end1_x, 0;
            frac1_end2_x, 0];
    else

        if (abs(frac1_end1_y) > 1e-5 && abs(frac1_end2_y) < 1e-5)
            k = [frac1_end2_x, 0];
        else if (abs(frac1_end1_y) < 1e-5 && abs(frac1_end2_y) > 1e-5)
            k = [frac1_end1_x, 0];
        else

            if ((frac1_end1_y > 0 && frac1_end2_y < 0) || (frac1_end1_y < 0 && frac1_end2_y > 0))
                Vector = [frac1_end2_x - frac1_end1_x, frac1_end2_y - frac1_end1_y];
                Vector = [Vector(2), -Vector(1)];
                % normal vector of a line segment
                if (Vector(2) < 0)
                    Vector = [-Vector(1), -Vector(2)];
                end

                % ax + by + c = 0, [a, b] is the normal vector
                c = -(Vector(1) * frac1_end1_x + Vector(2) * frac1_end1_y);
                x = -c / Vector(1);
                k = [x, 0];
            else
                k = 0;
            end

        end

    end

end
