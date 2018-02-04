% Write a program named compute2DProperties that takes a labeled image from the previous step and computes 
% properties for each labeled object in the image. Store these properties in an objects database.
% [obj_db, out_img] = compute2DProperties(gray_img, labeled_img)
% The generated object database obj_db should be a 2D matrix, 
% with each column corresponding to an object and each row corresponding to a property. 
% The first six rows should correspond to the following properties: 
% 1. Object label,
% 2. Row position of the center,
% 3. Column position of the center,
% 4. The minimum moment of inertia,
% 5. The orientation (angle in degrees between the axis of minimum inertia and the horizontal axis, positive = clockwise from the horizontal axis),
% 6. The roundness.

img = imread('variable_test.png');
img = rgb2gray(img);
threshold = 0.5;
bw_img = im2bw(img, threshold);
labeled_img = bwlabel(bw_img);
[m, n] = size(labeled_img);
%find the number of labeled objects
num = max(max(uint8(labeled_img)));
prop = zeros(6, num);
for i = 1 : num
    prop(1, i) = i;
    row_sum = 0; 
    col_sum = 0;
    a_0 = 0; 
    b_0 = 0;
    c_0 = 0;
    points = find(labeled_img==i);
    area = length(points);
    for j = 1 : length(points)
        x = points(j) / m;
        y = mod(points(j), m);
        
        row_sum = row_sum + x;
        col_sum = col_sum + y;
        
        a_0 = a_0 + x*x;
        b_0 = b_0 + 2*x*y;
        c_0 = c_0 + y*y;
    end
    row_pos = row_sum / area;
    col_pos = col_sum / area;
    prop(2, i) = row_pos;
    prop(3, i) = col_pos;
    a = a_0 - 2 * row_sum * row_pos + row_pos * row_pos * area;
    b = b_0 - 2*row_sum * col_pos - 2*col_sum * row_pos + 2*row_pos * col_pos * area;
    c = c_0 - 2 * col_sum * col_pos + col_pos * col_pos * area; 
    orientation = atan2(b, a-c) / 2;
    e_min = (a + c) / 2 - sqrt(b * b + (c-a)^2) / 2;
    prop(4, i) = e_min;
    prop(5, i) = orientation;
    prop(6, i) = round(a, b, c);
end
orien = regionprops(labeled_img, 'Orientation');
sha = orien.Orientation;
shasha = orien(2).Orientation;
k = regionprops(labeled_img, 'Centroid');
draw(img, prop,orien);


function roundness = round(a, b, c)
e_min = (a + c) / 2 - sqrt(b * b + (a-c)^2) / 2;
e_max = (a + c) / 2 + sqrt(b * b + (a-c)^2) / 2;
roundness = e_min / e_max;
end

function draw(img, prop,orien)
imshow(img);
hold on; 
for i = 1 : length(prop(1, :))
    plot( prop(2, i), prop(3, i), 'ws', 'MarkerFaceColor', [1 0 0]);
    orien1 = prop(5, i);
    quiver(prop(2, i), prop(3, i), 20, 20*tan(orien1), 'r','LineWidth',1.5);
    tan(orien(i).Orientation*pi / 180)
    %quiver(prop(2, i), prop(3, i), 100, 100*tan(orien(i).Orientation * pi / 180), 0.15, 'b','LineWidth',1.5);
    %quiver(300, 300, -100, 100, 0.15, 'b','LineWidth',1.5);
    %annotation('arrow',[prop(2, i), prop(3, i)],[prop(2, i)+10 prop(3, i)+10*tan(orientation)],'LineStyle','-','color',[1 0 0]);
end
end
