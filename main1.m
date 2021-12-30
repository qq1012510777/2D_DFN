clc;
close all;
clear all;

currentPath = fileparts(mfilename('fullpath'));
% get the current path of the .m file

addpath(genpath([currentPath, '/Quaternion']));
addpath(genpath([currentPath, '/Intersection']));
addpath(genpath([currentPath, '/Cluster']));
addpath(genpath([currentPath, '/Domain']));
addpath(genpath([currentPath, '/Fractures']));
addpath(genpath([currentPath, '/Plot_DFN']));
addpath(genpath([currentPath, '/Geometry']));
addpath(genpath([currentPath, '/Mesh']));
addpath(genpath([currentPath, '/Solve']));
% including the self-defined functions

NUM_fracs = 150; % number of fractures
domain_size = 20;
len = 10;

% set a domain % it is a rectangle
[Dom Domain_coordinates Bound_] = Domain(domain_size);

% add fractures
Frac = Fractures(Dom, NUM_fracs, len);

% now let us visualize the DFN!
% please extract fracture attributes first

figure(1); title('A 2D DFN'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_DFN(Domain_coordinates, Frac, "No");

%f = Intersection_status(0,0,1,1,0,1,1,0,45,135,0.5,0.5,0.5,0.5)
Intersections_ = Intersections(Frac, "NO");
% now, visualize the fractures and intersections
figure(2); title('Intersections'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_DFN_intersections(Domain_coordinates, Frac, Intersections_);

%------------------------------------------------------------------------------
% now, identify the connecting fractures!
% a cluster of fractures means several fractures are intersected with each other and form a connecting path
n = size(Intersections_, 2);

s = [];
t = [];

for i = 1:1:n
    s(i) = Intersections_(i).frac1_tag;
    t(i) = Intersections_(i).frac2_tag;
end

ui = ismember(NUM_fracs, t);

if (ui == 0)
    s(n + 1) = NUM_fracs;
    t(n + 1) = NUM_fracs;
end

% a self defined algorithm to identify fracture clusters
if (s(1) == 0)
    s(1) = []; t(1) = [];
end

Cluster_ = Cluster(s, t, NUM_fracs);
figure(3); title('Connecting fractures'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_DFN_clusters(Domain_coordinates, Cluster_, Frac);

%---------------------

%---------truncate the fractures
Frac = Trim_fracs(Domain_coordinates, Frac, Bound_, Dom);
figure(4); title('A truncated 2D DFN'); xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_DFN(Domain_coordinates, Frac, "truncated");

%-----identify percolating cluster
Percoalting_cluster = Identify_percolating_cluster(Frac, Cluster_);

if (size(Percoalting_cluster, 2) > 0)
    figure(5); title('Percolating_cluster'); xlabel('x(m)'); ylabel('y(m)'); hold on
    f = Plot_DFN_percolating_clusters(Domain_coordinates, Cluster_, Frac, Percoalting_cluster);
end

%------- output
Lines_ = [];
for i = 1:size(Percoalting_cluster, 2)
    clusterID = Percoalting_cluster(i);

    Lineii = [];
    for j = 1:size(Cluster_(clusterID).cluster, 1)
        FracID = Cluster_(clusterID).cluster(j);
        
        Lineii = [Frac(FracID).truncated_ends_x(1), Frac(FracID).truncated_ends_y(1), Frac(FracID).truncated_ends_x(2), Frac(FracID).truncated_ends_y(2)];
        Lines_ = [Lines_; Lineii];
    end
end

save([currentPath, '/Lines.mat'], 'Lines_')