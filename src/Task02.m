function [ output_args ] = Task02( img )
%TASK02 Summary of this function goes here
%   Detailed explanation goes here

space_limit = 2500;

gray = rgb2gray(img);

edges = edge(edge(gray, 'sobel'), 'canny');

edges = imclose(edges,strel('square', 5));



edges = ~edges;

edges = imerode(edges,strel('square', 7));
%figure('Name', 'Fence Regions');
%imshow(edges);

CC = bwconncomp(edges);
stats = regionprops(CC, 'Image');
pp = regionprops(CC, 'PixelList');
arr = zeros(size(stats));

for k = 1:length(stats)
    arr(k) = sum(sum(stats(k).Image));
end
arr = sort(arr);
mm = median(arr);

count = 0;
c2 = 0;
c3 = 0;
for i = 1:length(arr)
    if arr(i)-mm > space_limit
        count = count + floor(arr(i)/mm);
        c3 = c3 + 1;
    else
       c2 = c2 +1; 
    end
end

conI = zeros(size(edges));

for i = 1:length(pp)
    s_pp = size(pp(i).PixelList);
    if s_pp(1)-mm > space_limit
        for xc = 1:length(pp(i).PixelList)
            coor = pp(i).PixelList;
            conI(coor(xc,1), coor(xc,2)) = 1;
        end
    end
end

%figure('Name', 'WithHoles');
%imshow(conI);
imshowpair(edges,conI,'montage');

% fprintf('Units With Holes = %d\n', count);
% fprintf('Regions With Holes = %d\n', c3);
% fprintf('Fence Regions = %d\n', count+c2);
% fprintf('Fence Regions (counting holes regions as ones) = %d\n', length(arr));

m1 = strcat('Units With Holes = ',num2str(count));
m2 = strcat('Regions With Holes = ',num2str(c3));
m3 = strcat('Fence Regions = ', num2str(count+c2));
m4 = strcat('Fence Regions (counting holes regions as ones) = ', num2str(length(arr)));

message = strvcat(m1,m2,m3,m4);

msgbox(message);

end

