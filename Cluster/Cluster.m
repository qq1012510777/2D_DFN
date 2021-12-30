function f = Cluster(s, t, NUM_fracs)
    [m1, n1] = size(s);
    [m2, n2] = size(t);

    if((n1 ~= n2) || m1 ~= 1 || m2 ~= 1)
        throw('In function Cluster, the array s and t are problematic!');
    end

    G = graph(s, t);

    Cluster = struct('cluster', []);
    V = dfsearch(G, 1);
    Cluster(1).cluster = V;

    for i = 2:1:NUM_fracs

        [p_1, q_1] = size(Cluster);
        n = 0;

        for j = 1:1:q_1
            n = n + ismember(i, Cluster(j).cluster);
        end

        if (n == 0)
            V = dfsearch(G, i);
            Cluster(i).cluster = V;
        end

    end

    f = Cluster;

end
