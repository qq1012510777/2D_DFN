clc;
close all;
clear all;

% get the current path of the .m file
currentPath = fileparts(mfilename('fullpath'));

% including the self-defined functions
addpath(genpath([currentPath, '/Quaternion']));
addpath(genpath([currentPath, '/Intersection']));
addpath(genpath([currentPath, '/Cluster']));
addpath(genpath([currentPath, '/Domain']));
addpath(genpath([currentPath, '/Fractures']));
addpath(genpath([currentPath, '/Plot_DFN']));
addpath(genpath([currentPath, '/Geometry']));
addpath(genpath([currentPath, '/Mesh']));
addpath(genpath([currentPath, '/Solve']));
addpath(genpath([currentPath, '/Solute_tranposrt']));

% set a domain % it is a rectangle (including square)
domain_size = 30;
[Dom Domain_coordinates Bound_] = Domain(domain_size);

% add fractures
NumGroups = 3; % three fracture groups
NUM_fracs = [8, 8, 8]; % num of fractures in each group
len = [4, 6;
    10, 15;
    8, 11]; % length distributions of the three groups; all are uniforms
orientation = [1, 1;
            1, 0.2;
            -1, 1]; % orientations (normal vectors) of three groups, all orientations are fixed
Frac = Fractures_grouped_fixed_orienation(Dom, NumGroups, NUM_fracs, len, orientation);

%---------truncate the fractures
Frac = Trim_fracs(Domain_coordinates, Frac, Bound_, Dom);

Intersections_ = Intersections(Frac, "truncated");
% now, visualize the fractures and intersections
figure(1); title('2D DFN and intersections');
xlabel('x(m)'); ylabel('y(m)'); hold on
Plot_DFN_intersections(Domain_coordinates, Frac, Intersections_, "truncated");
pbaspect([1 1 1]);

% now output data
fid = fopen([currentPath, '/FracData.txt'], 'w');
oi = 'Fracture ID, end1_x, end1_y, end2_x, end2y\n';
fprintf(fid, oi);

for i = 1:size(Frac, 2)
    fprintf(fid, '%d\t', i);
    fprintf(fid, '%.60f\t', [Frac(i).truncated_ends_x(1), Frac(i).truncated_ends_y(1), ...
                    Frac(i).truncated_ends_x(2), Frac(i).truncated_ends_y(2)]);
    fprintf(fid, '\n');
end

oi = 'Fracture ID1/Fracture ID2, intersection_x, intersection_y\n';
fprintf(fid, oi);

for i = 1:size(Intersections_, 2)
    fprintf(fid, '%d/', [Intersections_(i).frac1_tag]);
    fprintf(fid, '%d\t', [Intersections_(i).frac2_tag]);
    fprintf(fid, '%.60f\t', [Intersections_(i).intersection(1)]);
    fprintf(fid, '%.60f\n', [Intersections_(i).intersection(2)]);
end

fclose(fid);

disp(['if the DFN is satisfying, please see the FracData.txt in the current working directory\n']);