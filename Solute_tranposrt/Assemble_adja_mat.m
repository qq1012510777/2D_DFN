function [node2element] = Assemble_adja_mat(JM, NUM_nodes)
    node2element = sparse(NUM_nodes, NUM_nodes);
    for i = 1:size(JM, 1)
        node2element(JM(i, 1), JM(i, 2)) = i;
        node2element(JM(i, 2), JM(i, 1)) = i;
    end

end
