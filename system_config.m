
%% 显示器尺寸,自动获取
tempArray = getMonitorSize();
Monitor = struct; % 定义一个结构体
Monitor.width = tempArray(3);
Monitor.hight = tempArray(4);

%% 球桌
Table = struct;
% 截取整个屏幕的左上角、四分之一
screenTemp = screenShoot([0, 0, Monitor.width/2, Monitor.hight/2 + 20]);
% 获取外部尺寸
Table.sizeOuter = getTablePosition(screenTemp);
% 调试
% figure, imshow(screenTemp);
% rectangle('Position',[Table.sizeOuter.x, Table.sizeOuter.y, Table.sizeOuter.width, Table.sizeOuter.hight],...
%           'EdgeColor','r',...
%           'LineWidth',2);


% 计算内部尺寸
tempWidth = Table.sizeOuter.width / 60; % 根据比例计算边的宽度
Table.sizeInside.x = Table.sizeOuter.x + tempWidth;
Table.sizeInside.y = Table.sizeOuter.y + tempWidth;
Table.sizeInside.width = Table.sizeOuter.width - tempWidth * 2;
Table.sizeInside.hight = Table.sizeOuter.hight - tempWidth * 2;
% 调试
% figure, imshow(screenTemp);
% rectangle('Position',[Table.sizeInside.x, Table.sizeInside.y, Table.sizeInside.width, Table.sizeInside.hight],...
%           'EdgeColor','g',...
%           'LineWidth',2);

% 计算球心运动的范围
tempRadius = Table.sizeOuter.width / 32 / 2; % 根据比例计算边的半径
Table.sizeMassArea.x =  Table.sizeInside.x + tempRadius;
Table.sizeMassArea.y =  Table.sizeInside.y + tempRadius;
Table.sizeMassArea.width =  Table.sizeInside.width - tempRadius * 2;
Table.sizeMassArea.hight =  Table.sizeInside.hight - tempRadius * 2;
% 调试模式
% figure, imshow(screenTemp);
% rectangle('Position',[Table.sizeMassArea.x, Table.sizeMassArea.y, Table.sizeMassArea.width, Table.sizeMassArea.hight],...
%           'EdgeColor','b',...
%           'LineWidth',2);

%% 球
Ball.sizeDiameter = Table.sizeOuter.width / 32; % 根据比例计算球的直径
Ball.sizeRadius = Ball.sizeDiameter / 2;



