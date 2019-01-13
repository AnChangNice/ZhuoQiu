%% 清除变量
clear;
close all;
clc;

%% 系统初始化
system_config;

%% 初始图像
% 截取整个屏幕的左上角、四分之一
screenTemp = screenShoot([0, 0, Monitor.width/2, Monitor.hight/2 + 20]);
% 提取球桌面部分
Table.outerImage.rgb = getImageArea(screenTemp, Table.sizeOuter.x, Table.sizeOuter.y,...
                               Table.sizeOuter.width, Table.sizeOuter.hight); 
handle = imshow(Table.outerImage.rgb);
pause(2);
%% 抓取一帧图像、并标出所有的圆
tic;
while true
    tic;
    % 截取整个屏幕的左上角、四分之一
    screenTemp = screenShoot([0, 0, Monitor.width/2, Monitor.hight/2 + 20]);
    % 提取球桌面部分
    Table.outerImage.rgb = getImageArea(screenTemp, Table.sizeOuter.x, Table.sizeOuter.y,...
                                   Table.sizeOuter.width, Table.sizeOuter.hight); 
    
    % 检测所有的球
    getBallPosition;
    % 背景图片
    tempImage = Table.outerImage.rgb;
    % 绘出白球 r
    cx = Ball.center.whiteBall(1);
    cy = Ball.center.whiteBall(2);
    cr = Ball.center.whiteBall_radius;
    tempImage = insertShape(tempImage, 'circle', [cx cy cr], 'LineWidth',2,'Color','red');
    % 绘出瞄准环 g
    cx = Ball.center.aimRing(1);
    cy = Ball.center.aimRing(2);
    cr = Ball.center.aimRing_radius;
    tempImage = insertShape(tempImage, 'circle', [cx cy cr], 'LineWidth',2,'Color','green');
    % 绘出目标球 b
    cx = Ball.center.targetBall(1);
    cy = Ball.center.targetBall(2);
    cr = Ball.center.targetBall_radius;
    tempImage = insertShape(tempImage, 'circle', [cx cy cr], 'LineWidth',2,'Color','blue');
    % 绘出普通球 
    for i = 1:length(Ball.center.normalBall_radius)
        cx = Ball.center.normalBall(i, 1);
        cy = Ball.center.normalBall(i, 2);
        cr = Ball.center.normalBall_radius(i);
        tempImage = insertShape(tempImage, 'circle', [cx cy cr], 'LineWidth',2,'Color','yellow');
    end
    % 若检测到目标球，绘出击球轨迹
    if Ball.center.targetBall_index ~= 0
        v2.x = Ball.center.targetBall(1) - Ball.center.aimRing(1);
        v2.y = Ball.center.targetBall(2) - Ball.center.aimRing(2);
        v1.x = Ball.center.targetBall(1);
        v1.y = Ball.center.targetBall(2);
        v2.x = v2.x * 50;
        v2.y = v2.y * 50;
        % 偏移量
        x_offset = Table.sizeMassArea.x - Table.sizeOuter.x;
        y_offset = Table.sizeMassArea.y - Table.sizeOuter.y;
        tempImage = insertShape(tempImage, 'Line', [v1.x, v1.y, v1.x+v2.x, v1.y+v2.y], 'LineWidth',2,'Color','blue');
        
        % 绘制出反射轨迹
        x_offset = Table.sizeMassArea.x + 0 - Table.sizeOuter.x;
        y_offset = Table.sizeMassArea.y + 0 - Table.sizeOuter.y;
        x0 = v1.x - x_offset;
        y0 = v1.y - y_offset;
        x2 = v1.x+v2.x - x_offset;
        y2 = v1.y+v2.y - y_offset;
        w = Table.sizeMassArea.width;
        h = Table.sizeMassArea.hight;
        position = ballPath(x0, y0, x2, y2, w, h);
        position.x = position.x + x_offset;
        position.y = position.y + y_offset;
        % 绘出反射轨迹
        tempImage = insertShape(tempImage, 'Line', [position.x(1), position.y(1), position.x(2), position.y(2)], 'LineWidth',2,'Color','blue');
%         tempImage = insertShape(tempImage, 'Line', [position.x(2), position.y(2), position.x(3), position.y(3)], 'LineWidth',2,'Color','blue');
%         tempImage = insertShape(tempImage, 'Line', [position.x(3), position.y(3), position.x(4), position.y(4)], 'LineWidth',2,'Color','blue');
        % 绘出反射位置
        for i = 1:length(position.x)
            cx = position.x(i);
            cy = position.y(i);
            cr = Ball.center.targetBall_radius;
            tempImage = insertShape(tempImage, 'circle', [cx cy cr], 'LineWidth',2,'Color','yellow'); 
        end
    end

    set(handle,'Cdata',tempImage);
    %getframe;
    drawnow;
    % 计算帧率
    fprintf('FrameRate: %0.2f F/s\r\n', 1/toc);
end

