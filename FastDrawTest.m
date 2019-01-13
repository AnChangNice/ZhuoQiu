clear all;
close;

frame = screenShoot([0 0 950 580]);

h = imshow(frame);

%% Loop through subsequent frames and refresh 'CData'
timeCost = zeros(1,1000);

for k = 1:500
    tic
    frame = screenShoot([0 0 950 580]);
    frame = insertShape(frame, 'circle', [150.1 280 k], 'LineWidth',5);
    frame = insertShape(frame, 'line', [150 280 k k], 'LineWidth',5);
    set(h,'Cdata',frame);
    drawnow
    timeCost(k) = 1/toc;
    fprintf('i = %d/1000\t FrameRate = %.2f\n', k, timeCost(k));
end
