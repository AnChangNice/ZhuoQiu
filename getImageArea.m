function [tempImage] = getImageArea(inputImage, x, y, w, h)
%% 截取图片的部分数据
tempImage = inputImage(y:y+h, x:x+w, :);
end