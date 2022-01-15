function f = Identify_target_eles(JXY, JM, Dom)
    f = [];

    for i = 1:size(JM, 1)

        for j = 1:2
            node_s = JM(i, j);

            if (abs(JXY(node_s, 2) - Dom.y_min) < 1e-7)
                f = [f; i];
                break
            end

        end

    end

end
