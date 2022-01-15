function [If_on_frac, V, W] = Jump_to_next_line(delta_L, flux_k, node_init_k, node_end_k, JXY, JM, Adja_mat, pressure, conductivity)
    If_on_frac = [];
    V = [];
    W = [];

    %------jump to which frac
    A = find(Adja_mat(node_end_k, :) ~= 0);
    a = find(A == node_init_k);
    A(a) = [];
    record_minux = [];

    flux_ = zeros(size(A, 2), 1);
    ele_ = flux_;
    for i = 1:size(A, 2)
        ele_(i) = Adja_mat(node_end_k, A(i));

        node1 = JM(ele_(i), 1);
        node2 = JM(ele_(i), 2);

        h1 = pressure(node_end_k);
        h2 = pressure(A(i));

        flux = conductivity * (h1 - h2) / norm(JXY(node1, :) - JXY(node2, :));

        flux_(i) = flux;

        if (flux <= 0)
            record_minux = [record_minux, i];
        end

    end

    A(record_minux) = [];
    flux_(record_minux) = [];
    ele_(record_minux) = [];

    proba_ = zeros(size(A, 2), 1);
    proba_ = [0; proba_];

    for i = 1:size(A, 2)
        proba_(i + 1) = flux_(i) / sum(flux_) + proba_(i);
    end

    rand_u = rand;
    flux_u = 0;
    ele_u = 0;
    node_u = 0;

    for i = 1:size(A, 2)

        if (rand_u < proba_(i + 1))
            flux_u = flux_(i);
            ele_u = ele_(i);
            node_u = A(i);
            break;
        end

    end

    %-------------------------------
    L = flux_u / flux_k * delta_L;

    %---------------------------
    L_ele = norm(JXY(node_end_k, :) - JXY(node_u, :));

    if (L <= L_ele)
        If_on_frac = 1;
        v = JXY(node_u, :) - JXY(node_end_k, :);

        x_s = JXY(node_end_k, 1) + L / L_ele * v(1);
        y_s = JXY(node_end_k, 2) + L / L_ele * v(2);

        V = [x_s, y_s, ele_u];

    else
        If_on_frac = 0;
        W = [L - L_ele, flux_u, node_end_k, node_u];
        % (delta_L, flux_k, node_init_k, node_end_k, Adja_mat, pressure, conductivity)
    end

end
