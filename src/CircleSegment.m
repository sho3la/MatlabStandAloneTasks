function [ CoinsImg ] = CircleSegment( InputImage )
%CIRCLESEGMENT Summary of this function goes here
%   Detailed explanation goes here

[centers] = imfindcircles(InputImage,[30 60],'ObjectPolarity','dark','Sensitivity',0.9,'Method','twostage');

[centersBright] = imfindcircles(InputImage,[30 60],'ObjectPolarity','bright','Sensitivity',0.9,'EdgeThreshold',0.1);

centers = round([centers; centersBright]);

radius = 45;
circ_mask = double(getnhood(strel('ball',radius,radius,0)));

bw = false(size(InputImage,1),size(InputImage,2));
bw(sub2ind(size(bw),centers(:,2),centers(:,1))) = true;


bw = imfilter(bw,circ_mask);
bw = imcomplement(bw);

bw = ~bw;

mask = cast(bw, class(InputImage));

redPlane = InputImage(:, :, 1);
greenPlane = InputImage(:, :, 2);
bluePlane = InputImage(:, :, 3);

maskedRed = redPlane .* mask;
maskedGreen = greenPlane .* mask;
maskedBlue = bluePlane .* mask;
CoinsImg = cat(3, maskedRed, maskedGreen, maskedBlue);

end

