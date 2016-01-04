function [p_out, holes] = GetPeaks(img)
img = uint8(img);


%detect skin
%imshow(img);
img_size = size(img);
r=1;
g=2;
b=3;
y=1;
u=2;
v=3;

yuv = img;
region=yuv;

for i = 1:img_size(1)
    for j = 1:img_size(2)
        yuv(i,j,y) = (img(i,j,r)+2*img(i,j,g)+img(i,j,b))/4;
        yuv(i,j,u) = img(i,j,r)-img(i,j,g);
        yuv(i,j,v) = img(i,j,b)-img(i,j,g);
    end
end

%imshow(yuv);

for i = 1:img_size(1)
    for j = 1:img_size(2)
        if yuv(i,j,u)>10 && yuv(i,j,u)<75
            region(i,j,r) = 255;
            region(i,j,g) = 255;
            region(i,j,b) = 255;
        else
            region(i,j,r) = 0;
            region(i,j,g) = 0;
            region(i,j,b) = 0;
        end
    end
end

%imshow(region);

fimg = region;

fimg = im2bw(fimg);
fimg = bwareaopen(fimg,125);
fimg = imdilate(fimg,strel('diamond',7));

%imshow(fimg);

cc = bwconncomp(fimg);
arr = (cellfun('length',cc.PixelIdxList));

newLabel = fimg;
if ~isempty(round(arr))
    sizes = 0;
    for i = 1:length(arr)
        if sizes < arr(i:i)
            sizes = arr(i:i);
            index = i;
        end
    end
    
    labels = labelmatrix(cc);
    newLabel = (labels==index);
    out1 = newLabel;
end

%out1 = imfill(out1,'holes');

%figure(3);
%imshow(out1);

after_hole = imfill(out1, 'holes');
img_holes = after_hole & ~out1;

big_holes = bwareaopen(img_holes, 300);

cc_h = bwconncomp(big_holes);

if(cc_h.NumObjects > 1)
    holes = cc_h.NumObjects;
else
    holes = 0;
end

bin_img = out1;
[B,L] = bwboundaries(bin_img, 'noholes');

max_boundary = [];
max_koko=0;

for i = 1:length(B)
    boundary = B{i};
    bsize = size(boundary);
    if(bsize(1) > max_koko)
        max_boundary = boundary;
        max_koko = bsize(1);
    end
end

ref_point = [0 0];
for i = 1:max_koko
    pointx = max_boundary(i,1);
    pointy = max_boundary(i,2);
    if (ref_point(1) < pointx || ref_point(2) < pointy)
        ref_point = [pointx pointy];
    end
end

f = zeros(max_koko, 1);
for i = 1:max_koko
    dist = sqrt(sum((max_boundary(i,:) - ref_point) .^ 2));
    f(i) = dist;
end


%figure(2);
XX = linspace(1,max_koko,max_koko);
%plot(XX,f(:),'g');

rat = (img_size(2)/img_size(1));
raw_pp = findpeaks(f,'npeaks',10);
p_out = raw_pp;
end