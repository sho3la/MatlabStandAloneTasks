function[out_img] = DetectLines(img, angle, sigma_val)

img_size = size(img);

angle_line = angle;
angle_process = angle_line;
sigma = sigma_val;
line_length = 3;

original = uint8(img);

if img_size(3) == 3
    img = rgb2gray(img);
elseif img_size(3) > 3
    original = uint8(img(:,:,1:3));
    img = rgb2gray(img(:,:,1:3));
end


edges = edge(edge(img,'sobel'), 'canny');

processed = edges;
% figure('Name', 'Pre Edges'), imshow(processed), hold on;
% waitforbuttonpress;

segmented = uint8(zeros([img_size(1), img_size(2), 3]));
min_length = 125;
llength = 100;
count = 1;

while llength >= min_length || count > 0

    hough_img = processed;
    [H, T, R] = hough(hough_img);

    P = houghpeaks(H, 1);
    distance = 0;

    Lines = houghlines(hough_img, T, R, P, 'FillGap', 20);
    
    for k = 1: length(Lines)
        blank_image = zeros([img_size(1), img_size(2), 3]);
        
        %disp(Lines(k).theta);
        
        xy = [Lines(k).point1; Lines(k).point2];
        
        blank_image = insertShape(blank_image, 'line',[xy(1,:) xy(2,:)], 'LineWidth', 25, ...
        'Color', 'White');
    
        processed = processed .* ~rgb2gray(blank_image);
        
        dd = pdist(xy,'euclidean');
        %fprintf('sub dist: %f\n', dd);
        distance = max(dd,distance);
        
        %m = (xy(2,2)-xy(1,2))/(xy(2,1)-xy(1,1));
        
        if Lines(k).theta >= angle_line - sigma && Lines(k).theta <= angle_line + sigma        
            %sseg = img .* uint8(blank_image);
            add_img = uint8(blank_image);
            segmented = segmented + add_img;
        end
    end
    
%     figure(2)
%     imshow(segmented);
%     
%     figure(3);
%     imshow(processed);
    llength = distance;
    if llength < min_length && count>0
        llength = min_length;
        count = count-1;
    end
    %fprintf('max dist: %f\n', distance);
    %waitforbuttonpress
end


% imshow(original .* segmented);
out_img = original .* segmented;
end