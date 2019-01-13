function [ tempTable ] = getTablePosition(screenTemp)
%% 获取台球桌布的位置
% 获取的参数分别为：
% x ：相对于截图的水平位置
% y ：相对于截图的垂直位置
% width ：宽度
% hight ：高度
% 存储位置：
% 结构体 ：Table 

%% 图像预处理
% RGB to HSV
screenTemp_hsv = rgb2hsv(screenTemp);
screenTemp_h = screenTemp_hsv(:,:,1); % hue 色调 0-1 0-360
%screenTemp_s = screenTemp_hsv(:,:,2); % Saturation 饱和度 0-1 0-100（%）
%screenTemp_v = screenTemp_hsv(:,:,3); % Value 亮度 0-1 0-255

% hue（色度），球桌背景色 h 值为归一化值，将归一化映射到 0-360 度
screenTemp_h = screenTemp_h * 360;

% 阈值通过 histogram() 可以观察到占比最大的颜色范围：[159 165]
% figure, histogram(screenTemp_h);

% 二值化，阈值[159 165]
screenTemp_greentable = (screenTemp_h <= 165) & (screenTemp_h >= 159);
% figure, imagesc(screenTemp_greentable);

%% 桌面检测，边缘检测、霍夫变换、线段提取
% 因为霍夫变换会对图像内的所有点进行扫描
% 而实心的图形对于线条的检测是没有作用、甚至是干扰
% 所以必须先将边缘识别出来，而后对边缘进行霍夫变换
% 这样也会减小运行算量
%（最重要的还是因为霍夫变换的性质决定了必须这样操作）

% 边缘检测
screenTemp_greentable_edge = edge(screenTemp_greentable,'Canny');
% figure, imagesc(screenTemp_greentable_edge);

% 霍夫变换
[H,T,R] = hough(screenTemp_greentable_edge);
% figure, imagesc(H);

% 去除所有非 水平(1)、垂直(91)的结果,填充为 0 
tempSize = size(H);
tempMaxDistance = tempSize(1);
tempMaxAngle = tempSize(2);
tempZeros = zeros(tempMaxDistance, 1);
for cow = 1:tempMaxAngle+1
   if cow ~= 1 && cow ~= 91
      H(:, cow) = tempZeros; 
   end
end
% figure, imagesc(H);

% 提取顶点，即各线段的距离
P = houghpeaks(H, 4);
lines = houghlines(screenTemp_greentable_edge,T,R,P);

tempX1 = zeros(1, length(lines)); % 提取所有数据
tempY1 = zeros(1, length(lines));
tempX2 = zeros(1, length(lines));
tempY2 = zeros(1, length(lines));

for index = 1:length(lines)
   tempX1(index) = lines(index).point1(1);
   tempY1(index) = lines(index).point1(2);
   tempX2(index) = lines(index).point2(1);
   tempY2(index) = lines(index).point2(2);
end

tempX_max = max([tempX1, tempX2]);
tempX_min = min([tempX1, tempX2]);
tempY_max = max([tempY1, tempY2]);
tempY_min = min([tempY1, tempY2]);

% 写入 tempTable 桌面的范围
tempTable.x = tempX_min;
tempTable.y = tempY_min;
tempTable.width = tempX_max - tempX_min;
tempTable.hight = tempY_max - tempY_min;

% 调试输出测得的桌布范围：
% figure, imshow(screenTemp);
% rectangle('Position',[tempTable.x, tempTable.y, tempTable.width, tempTable.hight],...
%            'EdgeColor','b',...
%           'LineWidth',1);

end




