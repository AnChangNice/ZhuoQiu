function position = ballPath(x0, y0, x2, y2, w, h)
%% 做向量的延长线，球交点
% 折射次数
times = 0;
% 坐标
position.x = [];
position.y = [];

while ~((0 < x2 && x2 < w) && (0 < y2 && y2 < h))   
    % 特殊情况 0 90 180 -90
    v_angle = atan2(y2-y0, x2-x0)*180/pi;
    % 设定反射次数
    if times == 2
       break; 
    end
    
    % x = 0
    if x2 < 0 && x0 > 0
        y = y0 + (y2-y0)*(0-x0)/(x2-x0);
        if 0 < y && y < h && y0 ~= y || v_angle == 180
            position.x = [position.x, 0];
            position.y = [position.y, y];
            x2 = 0-x2;
            x0 = 0;
            y0 = y;
            times = times + 1;
            continue;
        end
    end
    % y = h
    if y0 < h && h < y2
        x = x0 + (x2-x0)*(h-y0)/(y2-y0);
        if 0 < x && x < w && x0 ~= x || v_angle == 90
            position.x = [position.x, x];
            position.y = [position.y, h];
            y2 = 2*h - y2;
            x0 = x;
            y0 = h;
            times = times + 1;
            continue;
        end
    end
    % x = w
    if x0 < w && w < x2
        y = y0 + (y2-y0)*(w-x0)/(x2-x0);
        if 0 < y && y < h && y0 ~= y || v_angle == 0
            position.x = [position.x, w];
            position.y = [position.y, y];
            x2 = 2*w - x2;
            x0 = w;
            y0 = y;
            times = times + 1;
            continue;
        end
    end
    % y = 0
    if y2 < 0 && 0 < y0
        x = x0 + (x2-x0)*(0-y0)/(y2-y0);
        if 0 < x && x < w && x0 ~= x || v_angle == -90
            position.x = [position.x, x];
            position.y = [position.y, 0];
            y2 = 0-y2;
            x0 = x;
            y0 = 0;
            times = times + 1;
            continue;
        end
    end 
end

%% 添加终止位置
position.x = [position.x, x2];
position.y = [position.y, y2];
        
