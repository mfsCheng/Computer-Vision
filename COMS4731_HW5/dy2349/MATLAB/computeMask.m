function mask = computeMask(img_cell)
[m, n] = size (img_cell{1});
img = im2bw(img_cell{1}, 0);
for i = 2 : length(img_cell)
    imgNext = im2bw(img_cell{i}, 0);
    mask = bitor(img,imgNext);
    img = imgNext;
end
mask = double(mask);
end