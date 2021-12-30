function f = Show_DFN_mesh(JXY, JM, string_i)
    hold on

    for i = 1:size(JM, 1)
        line(JXY([JM(i, :)], 1), JXY([JM(i, :)], 2), 'linestyle', '-', 'color', [rand rand rand], 'linewidth', 2); hold on
    end

    if(string_i == 1)
        hold on
        text(JXY(:, 1), JXY(:, 2), num2str([1:1:size(JXY, 1)]'));
    end
    f = 0;
end
