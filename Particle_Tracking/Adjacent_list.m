function f = Adjacent_list(JM_2D, sizeMax, NUMpnts)
    f = zeros(NUMpnts, sizeMax + 1) .* NaN;
    f(:, 1) = 0;
    
    for i = 1:size(JM_2D, 1)
        node1 = JM_2D(i, 1);
        node2 = JM_2D(i, 2);
        
        f(node1, 1) = f(node1, 1) + 1;
        if (f(node1, 1) + 1 > sizeMax)
            error('the size of list is not enough')
        end
        f(node1, f(node1, 1) + 1) = node2;
        
        %-------------
        f(node2, 1) = f(node2, 1) + 1;
        if (f(node2, 1) + 1 > sizeMax)
            error('the size of list is not enough')
        end
        f(node2, f(node2, 1) + 1) = node1;
    end
end