function [node, ele, num_particles, ParticlesArray] = Inject_particles(Dom, JXY, JM, ...
    NUM_particles, conductivity, pressure, string_mode)

    node = [];
    ele = [];
    coordinates = [];
    num_particles = [];
    flux_inject = [];

    for i = 1:size(JM, 1)

        for j = 1:2
            node_s = JM(i, j);

            if (abs(JXY(node_s, 2) - Dom.y_max) < 1e-7)
                node = [node; JXY(node_s, :)];
                ele = [ele; i];
                coordinates = [coordinates; JXY(node_s, :)];
                
                eleID = i;
                node1 = JM(eleID, 1);
                node2 = JM(eleID, 2);
                h1 = max(pressure(node1), pressure(node2));
                h2 = min(pressure(node1), pressure(node2));

                flux = conductivity * (h1 - h2) / norm(JXY(node1, :) - JXY(node2, :));
                % flux = flux ./ ((conductivity * 12) ^ (1.0/3.0));
                flux_inject = [flux_inject; abs(flux)];
                break
            end

        end

    end
    
    total_flux = sum(flux_inject);
    
    num_particles = zeros(size(ele, 1), 1);
    
    if (string_mode == "even")
        num_particles = num_particles .* ceil(NUM_particles / size(ele, 1));
    elseif (string_mode == "flux_weighted")
        NUM_ = 1;
        for i = 1:size(ele, 1)
            
            num_particles(i) = ceil(flux_inject(i) / total_flux * NUM_particles);
            
            for j = NUM_:NUM_ + num_particles(i)-1
                ParticlesArray(j, 2) = ele(i);
                ParticlesArray(j, [3, 4]) = coordinates(i, :);
            end
            
            NUM_ = NUM_ + num_particles(i);
        end

    end

end
