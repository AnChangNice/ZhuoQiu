%% 预处理
% clear all;
close all;
clc;

%% 创建一个绘图区域
h = 100;
w = 150;
% x = 0;
line([0 0],[0 h],'Color','red','LineStyle','--')
axis equal;
% x = w;
line([w w],[0 h],'Color','red','LineStyle','--')
% y = 0;
line([0 w],[0 0],'Color','red','LineStyle','--')
% y = h;
line([0 w],[h h],'Color','red','LineStyle','--')

%% 设定一个线段
x0 = 90;
y0 = 60;
% angle = angle + 10;
angle = 150;
x1 = x0 + 10*cos(angle*pi/180);
y1 = y0 + 10*sin(angle*pi/180);
% 画出
line([x0 x1],[y0 y1],'Color','green','LineStyle','-')

%% 做向量的延长线，球交点
x2 = x0 + (x1 - x0) * 50;
y2 = y0 + (y1 - y0) * 50;
% 画出
line([x0 x2],[y0 y2],'Color','green','LineStyle','-')
xlim([-10 w+10]);
ylim([-10 h+10]);
while ~((0 < x2 && x2 < w) && (0 < y2 && y2 < h))
    
    % 特殊情况 0 90 180 -90
    v_angle = atan2(y2-y0, x2-x0)*180/pi;
    
    %line([x0 x2],[y0 y2],'Color','green','LineStyle','-')
    pause(1);
    % x = 0
    if x2 < 0 && x0 > 0
        y = y0 + (y2-y0)*(0-x0)/(x2-x0);
        if 0 < y && y < h && y0 ~= y || v_angle == 180
            rectangle('Position',[0 y 2 2])
            line([x0 0],[y0 y],'Color','green','LineStyle','-')
            x2 = 0-x2;
            x0 = 0;
            y0 = y;
            continue;
        end
    end
    % y = h
    if y0 < h && h < y2
        x = x0 + (x2-x0)*(h-y0)/(y2-y0);
        if 0 < x && x < w && x0 ~= x || v_angle == 90
            rectangle('Position',[x h 2 2])
            line([x0 x],[y0 h],'Color','green','LineStyle','-')
            y2 = 2*h - y2;
            x0 = x;
            y0 = h;
            continue;
        end
    end
    % x = w
    if x0 < w && w < x2
        y = y0 + (y2-y0)*(w-x0)/(x2-x0);
        if 0 < y && y < h && y0 ~= y || v_angle == 0
            rectangle('Position',[w y 2 2])
            line([x0 w],[y0 y],'Color','green','LineStyle','-')
            x2 = 2*w - x2;
            x0 = w;
            y0 = y;
            continue;
        end
    end
    % y = 0
    if y2 < 0 && 0 < y0
        x = x0 + (x2-x0)*(0-y0)/(y2-y0);
        if 0 < x && x < w && x0 ~= x || v_angle == -90
            rectangle('Position',[x 0 2 2])
            line([x0 x],[y0 0],'Color','green','LineStyle','-')
            y2 = 0-y2;
            x0 = x;
            y0 = 0;
            continue;
        end
    end 
end

line([x0 x2],[y0 y2],'Color','green','LineStyle','-')
rectangle('Position',[x2 y2 2 2])

