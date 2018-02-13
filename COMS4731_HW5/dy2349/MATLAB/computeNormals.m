function [normals, albedo_img] = ...
    computeNormals(light_dirs, img_cell, mask)

 [idx, idy] = find(mask == 1);
 normals = zeros(size(img_cell{1},1), size(img_cell{1},2), 3);
 albedo_img = zeros(size(img_cell{1},1), size(img_cell{1},2));
 
for i = 1 : length(idx)
    I = double([img_cell{1}(idx(i),idy(i)), img_cell{2}(idx(i),idy(i)),...
         img_cell{3}(idx(i),idy(i)), img_cell{4}(idx(i),idy(i)), img_cell{5}(idx(i),idy(i))]');
    S = light_dirs;
    N = inv(S' * S) * S' * I;
    normals(idx(i),idy(i),:) = N / norm(N);
    albedo_img(idx(i),idy(i)) = norm(N);
end

albedo_img = albedo_img / max(albedo_img(:));
end
 
