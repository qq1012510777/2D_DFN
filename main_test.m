clc
close all
clear all

for i = 1:50
    x = [i i];
    y = [0 1];
    z = [0 0];
    col = [30 * (i + 1) 40 * (i + 1)];
    surface([x;x],[y;y],[z;z],[col;col],...
            'facecol','no',...
            'edgecol','interp',...
            'linew',4); hold on;
end

colorbar