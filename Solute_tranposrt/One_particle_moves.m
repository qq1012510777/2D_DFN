function [x1, y1, ele1, If_target] = One_particle_moves(x0, y0, ele0, delta_t, ...
        JXY, JM, Adja_mat, pressure, conductivity, target_ele)

    If_target = 0;
    node1 = JM(ele0, 1);
    node2 = JM(ele0, 2);

    h1 = max(pressure(node1), pressure(node2));
    h2 = min(pressure(node1), pressure(node2));

    flux = conductivity * (h1 - h2) / norm(JXY(node1, :) - JXY(node2, :));

    h_t1 = pressure(node1);
    vec = [];
    node_init = [];
    node_end = [];

    if (h_t1 ~= h1)
        vec = (JXY(node1, :) - JXY(node2, :)) / norm((JXY(node1, :) - JXY(node2, :)));
        node_init = node2;
        node_end = node1;
    else
        vec = (JXY(node2, :) - JXY(node1, :)) / norm((JXY(node1, :) - JXY(node2, :)));
        node_init = node1;
        node_end = node2;
    end

    for i = 1:1e10; L = flux * delta_t + randn * (2 * flux * delta_t)^0.5; if(L > 0); break; end; end;

    L_1 = ((x0 - JXY(node_end, 1))^2 + (y0 - JXY(node_end, 2))^2)^0.5;

    if (L > L_1)

        if (find(target_ele == ele0) ~= 0)
            If_target = 1;
            x1 = JXY(node_end, 1);
            y1 = JXY(node_end, 2);
            ele1 = ele0;
            return
        end

        delta_L = L - L_1;
        flux_k = flux;
        node_init_k = node_init;
        node_end_k = node_end;

        for i = 1:1e10
            [If_on_frac, V, W] = Jump_to_next_line(delta_L, flux_k, node_init_k, node_end_k, JXY, JM, Adja_mat, pressure, conductivity);

            if (If_on_frac == 1)
                x1 = V(1);
                y1 = V(2);
                ele1 = V(3);
                break
            end

            delta_L = W(1);
            flux_k = W(2);
            node_init_k = W(3);
            node_end_k = W(4);

            ele_k = Adja_mat(node_init_k, node_end_k);

            if (find(target_ele == ele_k) ~= 0)
                If_target = 1;
                x1 = JXY(node_end_k, 1);
                y1 = JXY(node_end_k, 2);
                ele1 = ele_k;
                break;
            end

        end

    else
        V = [JXY(node_end, 1) - x0, JXY(node_end, 2) - y0];

        x1 = x0 + L / L_1 * V(1);
        y1 = y0 + L / L_1 * V(2);
        ele1 = ele0;
    end

end
