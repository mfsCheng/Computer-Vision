function [db, out_img] = compute2DProperties(orig_img, labeled_img)
[m, n] = size(labeled_img);
%find the number of labeled objects
num = max(max(uint8(labeled_img)));
db = zeros(7, num);
for i = 1 : num
    db(1, i) = i;
    row_sum = 0; 
    col_sum = 0;
    a_0 = 0; 
    b_0 = 0;
    c_0 = 0;
    % find the indices of all the pixels equal to the particular label
    points = find(labeled_img==i);
    % the area of the object is the number of pixels equal to the
    % particular label
    area = length(points);
    db(7, i) = area;
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
    db(2, i) = row_pos;
    db(3, i) = col_pos;
    a = a_0 - 2 * row_sum * row_pos + row_pos * row_pos * area;
    b = b_0 - 2*row_sum * col_pos - 2*col_sum * row_pos + 2*row_pos * col_pos * area;
    c = c_0 - 2 * col_sum * col_pos + col_pos * col_pos * area; 
    e_min = (a + c) / 2 - sqrt(b * b + (c-a)^2) / 2;
    e_max = (a + c) / 2 + sqrt(b * b + (a-c)^2) / 2;
    db(4, i) = e_min;
    db(5, i) = atan2(b, a-c) / 2;
    db(6, i) = e_min / e_max;
end
fh1 = figure();
imshow(orig_img);
hold on; 
for i = 1 : length(db(1, :))
    plot( db(2, i), db(3, i), 'ws', 'MarkerFaceColor', [1 0 0]);
    line([db(2, i)-30, db(2, i)+30],[db(3, i)-30*tan(db(5, i)), db(3, i)+ 30*tan(db(5, i))], ...
        'LineWidth',2, 'Color', [0, 1, 0]);
end
out_img = saveAnnotatedImg(fh1);
end

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh
set(fh, 'WindowStyle', 'normal');
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);
frame = getframe(fh);
pause(0.5);  
annotated_img = frame.cdata;
end