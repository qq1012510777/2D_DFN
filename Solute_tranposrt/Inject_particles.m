function [node, ele, num_particles] = Inject_particles(Dom, JXY, JM, NUM_particles, string_mode)
    node = [];
    ele = [];
    num_particles = [];

    for i = 1:size(JM, 1)

        for j = 1:2
            node_s = JM(i, j);

            if (abs(JXY(node_s, 2) - Dom.y_max) < 1e-7)
                node = [node; JXY(node_s, :)];
                ele = [ele; i];
                break
            end

        end

    end

    if (string_mode == 'even')
        num_particles = ones(size(ele, 1), 1);
        num_particles = num_particles .* ceil(NUM_particles / size(ele, 1));
    elseif (string_mode == 'flux_weighted')

        for i = 1:size(ele, 1)

        end

    end

end
