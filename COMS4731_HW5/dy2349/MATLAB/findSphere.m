function [center, radius] = findSphere(img)
bw = im2bw(img, 0.05);
%imshow(bw);
props = regionprops(bw, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
center = getfield(props,'Centroid');
diameters = mean([getfield(props,'MajorAxisLength') getfield(props,'MinorAxisLength')], 2);
radius = diameters / 2;
end
