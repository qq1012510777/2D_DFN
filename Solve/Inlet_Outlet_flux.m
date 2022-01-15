function [inlet, outlet] = Inlet_Outlet_flux(pressure, top_ele, bot_ele, JM, JXY, conductivity)

    inlet = 0;
    outlet = 0;

    for i = 1:size(top_ele, 2)
        eleID = top_ele(i);
        node1 = JM(eleID, 1);
        node2 = JM(eleID, 2);

        h1 = max(pressure(node1), pressure(node2));
        h2 = min(pressure(node1), pressure(node2));

        flux = conductivity * (h1 - h2) / norm(JXY(node1, :) - JXY(node2, :));
        inlet = inlet + flux;
    end

    for i = 1:size(bot_ele, 2)
        eleID = bot_ele(i);
        node1 = JM(eleID, 1);
        node2 = JM(eleID, 2);

        h1 = max(pressure(node1), pressure(node2));
        h2 = min(pressure(node1), pressure(node2));

        flux = conductivity * (h1 - h2) / norm(JXY(node1, :) - JXY(node2, :));
        outlet = outlet + flux;
    end
end
