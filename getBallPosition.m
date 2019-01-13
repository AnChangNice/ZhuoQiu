
%% 获取所有球的位置，并识别出白球、瞄准环、瞄准的球


%% 图像处理
% 提取 hue (色度图)
tempImage = rgb2hsv(Table.outerImage.rgb);
Table.outerImage.h = tempImage(:, :, 1);
% Table.outerImage.s = tempImage(:, :, 2);
% Table.outerImage.v = tempImage(:, :, 3);
% hue（色度），球桌背景色 h 值为归一化值，将归一化映射到 0-360 度
screenTemp_h = Table.outerImage.h * 360;
% 二值化，阈值 160 左右
screenTemp_bw_withHole = (screenTemp_h < 100 | 200 < screenTemp_h);
% 填充
screenTemp_bw = imfill(screenTemp_bw_withHole, 'holes');
% 调试
% figure, imshow(screenTemp_bw);

%% 去除六个洞的干扰
% 生成蒙版，黑边，白心
tempEdgeWidth = round(Table.sizeMassArea.x - Table.sizeInside.x);
mask = ones(size(screenTemp_bw));
% 左边
mask(:, 1:tempEdgeWidth) = 0;
% 右边
mask(:, end-tempEdgeWidth:end) = 0;
% 上边
mask(1:tempEdgeWidth, :) = 0;
% 下边
mask(end-tempEdgeWidth:end, :) = 0;
% 应用蒙版
screenTemp_bw = mask & screenTemp_bw;
% 调试模式
% figure, imshow(screenTemp_bw);

%% 圆形检测
% 灰度化
screenTemp_bw = screenTemp_bw*255;
% 检测圆形
tempRadius = Ball.sizeRadius;
threshold_min = tempRadius - tempRadius * 0.45;
threshold_max = tempRadius + tempRadius * 0.5;
threshold_min = round(threshold_min);
threshold_max = round(threshold_max);
[centers, radius] = imfindcircles(screenTemp_bw, [threshold_min threshold_max], ...
                                      'ObjectPolarity', 'bright', ...
                                      'Method', 'PhaseCode', ...
                                      'Sensitivity', 0.9, ...
                                      'EdgeThreshold',0.09);                              
% 绘制圆形
% 调试
% tempImage = Table.outerImage.rgb;
% L = size(radius);
% for i = 1:L(1)
%     cx = centers(i,1);
%     cy = centers(i,2);
%     cr = radius(i);
%     %img = insertShape(img, 'circle', [cx cy cr], 'LineWidth',2,'Color','b');
%     tempImage = insertShape(tempImage, 'circle', [cx cy cr], 'LineWidth',2,'Color','blue');
% end
% figure, imshow(tempImage);

%% 分辨白球、瞄准环、普通球、瞄准的球
% 瞄准环：特征，中心为空
sampleWidth = 2;
Ball.center.aimRing = [0, 0];
Ball.center.aimRing_index = 0;
Ball.center.aimRing_radius = 0;
for i = 1:length(radius)
    sampleX = centers(i,1);
    sampleY = centers(i,2);
    % 采样
    x = round(sampleX - sampleWidth/2);
    y = round(sampleY - sampleWidth/2);
    sampleM = getImageArea(screenTemp_bw_withHole, x, y, sampleWidth, sampleWidth);
    % 对比
    if sum(sum(sampleM)) < 4
        Ball.center.aimRing = [sampleX, sampleY];
        Ball.center.aimRing_index = i;
        Ball.center.aimRing_radius = radius(i);
        break
    end
end

% 白球：特征，与瞄准环之间有连线，同时测算一下距离，区分目标球
sampleWidth = 4;
Ball.center.whiteBall = [0, 0];
Ball.center.whiteBall_index = 0;
Ball.center.whiteBall_radius = 0;
for i = 1:length(radius)
    % 跳过瞄准环
    if Ball.center.aimRing_index == i
       continue 
    end
    % 计算线段的中心坐标
    sampleX = (centers(i,1) + Ball.center.aimRing(1)) / 2;
    sampleY = (centers(i,2) + Ball.center.aimRing(2)) / 2;
    % 测算下与所有球的距离，跳过临近的球
    dx = centers(i,1) - Ball.center.aimRing(1);
    dy = centers(i,2) - Ball.center.aimRing(2);
    distance = sqrt(dx^2 + dy^2);
    K = distance/Ball.sizeDiameter; % 归一化
    if 0.7 < K && K < 1.5
        continue;
    end
    % 采样
    x = round(sampleX - sampleWidth/2);
    y = round(sampleY - sampleWidth/2);
    sampleM = getImageArea(screenTemp_bw_withHole, x, y, sampleWidth, sampleWidth);
    % 对比
    if sum(sum(sampleM)) > 4
        Ball.center.whiteBall = [centers(i,1), centers(i,2)];
        Ball.center.whiteBall_index = i;
        Ball.center.whiteBall_radius = radius(i);
        break
    end
end

% 瞄准的球：特征，与瞄准环间距接近球的直径
Ball.center.targetBall = [0, 0];
Ball.center.targetBall_index = 0;
Ball.center.targetBall_radius = 0;
for i = 1:length(radius)
    % 跳过瞄准环
    if Ball.center.aimRing_index == i
       continue 
    end
    % 跳过白球
    if Ball.center.whiteBall_index == i
       continue 
    end
    % 计算中心距离
    sampleX = centers(i,1);
    sampleY = centers(i,2);
    dx = sampleX - Ball.center.aimRing(1);
    dy = sampleY - Ball.center.aimRing(2);
    distance = sqrt(dx^2 + dy^2);
    K = distance/Ball.sizeDiameter; % 归一化
    % 对比
    if 0.8 < K && K < 1.2
        Ball.center.targetBall = [centers(i,1), centers(i,2)];
        Ball.center.targetBall_index = i;
        Ball.center.targetBall_radius = radius(i);
        break
    end
end

% 普通球，排除以上的部分球为普通球

Ball.center.normalBall = [];
Ball.center.normalBall_radius = [];
for i = 1:length(radius)
    % 跳过瞄准环
    if Ball.center.aimRing_index == i
       continue 
    end
    % 跳过白球
    if Ball.center.whiteBall_index == i
       continue 
    end
    % 跳过目标球
    if Ball.center.targetBall_index == i
       continue 
    end
    % 添加进 普通球
    Ball.center.normalBall = [Ball.center.normalBall; [centers(i,1), centers(i,2)]];
    Ball.center.normalBall_radius = [Ball.center.normalBall_radius, radius(i)];
end


