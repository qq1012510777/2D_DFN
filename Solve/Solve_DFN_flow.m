function f = Solve_DFN_flow(JXY, JM, Dom, conductivity, htop, hbot)
    Dim_ = size(JXY, 1);

    K = sparse(Dim_, Dim_);
    b = sparse(Dim_, 1);

    Top_nodes = [];
    Bot_nodes = [];
    Left_nodes = [];
    Right_nodes = [];

    for i = 1:size(JM, 1)

        for j = 1:2
            ID1 = JM(i, j);
            ID2 = JM(i, mod(j, 2) + 1);

            len = norm(JXY(ID1, :) - JXY(ID2, :));

            K(ID1, ID1) = K(ID1, ID1) - 1 / len * conductivity;
            K(ID1, ID2) = K(ID1, ID2) + 1 / len * conductivity;

            coord = JXY(ID1, :);

            if (coord(2) == Dom.y_max)
                Top_nodes = [Top_nodes, ID1];
            elseif (coord(2) == Dom.y_min)
                Bot_nodes = [Bot_nodes, ID1];
            elseif (coord(1) == Dom.x_min)
                Left_nodes = [Left_nodes, ID1];
            elseif (coord(1) == Dom.x_max)
                Right_nodes = [Right_nodes, ID1];
            end

        end

    end

    for i = 1:size(Top_nodes, 2)
        ID = Top_nodes(i);

        b(:, 1) = b(:, 1) - K(:, ID) * htop;

        K(:, ID) = 0;

        K(ID, :) = 0;

        K(ID, ID) = 1;

        b(ID, 1) = htop;
    end

    for i = 1:size(Bot_nodes, 2)
        ID = Bot_nodes(i);

        b(:, 1) = b(:, 1) - K(:, ID) * hbot;

        K(:, ID) = 0;

        K(ID, :) = 0;

        K(ID, ID) = 1;

        b(ID, 1) = hbot;
    end
    % full(K)
    % full(b)
    f = inv(K) * b;
end
