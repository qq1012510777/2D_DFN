function f = Plot_particles_movement(JXY, JM, Pressure, Dom, location_particles, timestep)
    %[X, Y] = meshgrid(Dom.x_min:(Dom.x_max - Dom.x_min) / 100:Dom.x_max, ...
    %    Dom.y_min:(Dom.y_max - Dom.y_min) / 100:Dom.y_max);
    %
    %Ptr = griddata(JXY(:, 1), JXY(:, 2), full(Pressure), X, Y, 'linear');
    %
    %hold on
    %contourf(X, Y, Ptr); view(2); colorbar; hold on
    %

    Domain_coordinates = [Dom.x_min, Dom.y_min; ...
                    Dom.x_min, Dom.y_max; ...
                        Dom.x_max, Dom.y_max; ...
                        Dom.x_max, Dom.y_min ...
                    ];
    plot([Domain_coordinates(:, 1); Domain_coordinates(1, 1)], [Domain_coordinates(:, 2); Domain_coordinates(1, 2)], 'r-', 'linewidth', 3);
    hold on;
    fill([Domain_coordinates(:, 1); Domain_coordinates(1, 1)], [Domain_coordinates(:, 2); Domain_coordinates(1, 2)], ...
        [0.8500 0.3250 0.0980], 'FaceAlpha', 0.5); hold on

    for i = 1:size(JM, 1)
        x = [JXY(JM(i, 1), 1), JXY(JM(i, 2), 1)];
        y = [JXY(JM(i, 1), 2), JXY(JM(i, 2), 2)];
        z = [0 0];
        col = [Pressure(JM(i, 1)), Pressure(JM(i, 2))];
        surface([x; x], [y; y], [z; z], [col; col], ...
            'facecol', 'no', ...
            'edgecol', 'interp', ...
            'linew', 2); hold on; colormap(jet);
    end
    axis off
    % colorbar; 
    hold on

    GGI = zeros(timestep, 2 * size(location_particles, 2));

    for i = 1:size(location_particles, 2)
        GGI(:, i) = location_particles(i).location(:, 1);
        GGI(:, i + size(location_particles, 2)) = location_particles(i).location(:, 2);
    end

     currentPath_tr = fileparts(mfilename('fullpath'));
     currentPath_tr = strrep(currentPath_tr,'/Solute_tranposrt','');
%     particles_video_object = VideoWriter([currentPath_tr, '/moive_particles.avi']);
%     particles_video_object.FrameRate = 10;
%     open(particles_video_object);

    ph = [];

    for i = 1:timestep

        if (i ~= 1)
            ph.XData = GGI(i, [1:size(location_particles, 2)]); %change x coordinate of the point
            ph.YData = GGI(i, [size(location_particles, 2) + 1:end]); %change y coordinate of the point
            drawnow

            if(sum(GGI(i, [size(location_particles, 2) + 1:end]) - Dom.y_min) < 1e-5)
                break
            end
        else
            ph = scatter(GGI(1, [1:size(location_particles, 2)]), GGI(1, [size(location_particles, 2) + 1:end]), 'k', 'o', 'filled');

        end

        pause(0.05)
        M=getframe(gcf);
        % writeVideo(particles_video_object,M);
        [I,map]=rgb2ind(M.cdata, 256);
        if(i == 1)
            imwrite(I, map,[currentPath_tr, '/PT_movie.gif'],'DelayTime',.0001)
        else if (mod(i, 20) == 0)
            imwrite(rgb2ind(M.cdata,map),map,[currentPath_tr, '/PT_movie.gif'],'WriteMode','append','DelayTime',.0001)
        end 
        
    end

%     close(particles_video_object);

    f = 0;
end
