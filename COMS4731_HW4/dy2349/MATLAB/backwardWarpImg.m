function [mask, result_img] = backwardWarpImg(src_img, resultToSrc_H,...
    dest_canvas_width_height)
result_img = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1), 3);
mask = zeros(dest_canvas_width_height(2), dest_canvas_width_height(1));
[m, n, k] = size(src_img);

for i = 1 : dest_canvas_width_height(1)
    for j = 1 : dest_canvas_width_height(2)
        A = resultToSrc_H * ([i, j, 1]');
        x = round(A(1)/A(3));
        y = round(A(2)/A(3));
        if 1 <= y && y <= m && 1 <= x && x <= n
            result_img(j,i, :) = src_img(y, x, :);
            mask(j, i) = 1;
        end
    end
end
%imshow(result_img);
end