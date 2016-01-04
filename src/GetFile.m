function [ img ] = GetFile()

   [imgFileName,imgPath] = uigetfile('*.*','Open File');
   
   if imgFileName ~= 0
       path = strcat(imgPath,imgFileName);
       img = imread(path);
   end
   
end

