function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)
light_dirs_5x3 = zeros(5, 3);
for i = 1 : length(img_cell)
    img = img_cell{i};
    val = max(img(:));
    [m,n]=find(img == val);
    idy = mean(m);
    idx = mean(n);
    
    x = double(idx - center(1));
    y = double(idy - center(2));
    z = double(sqrt(radius^2 - x^2 - y^2));
    
    n = [x, y, z]';
    
    n = n * double(val) / 255.0 / double(radius);
    light_dirs_5x3(i, :) = n;

end