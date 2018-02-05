function hough_img = generateHoughAccumulator(img, theta_num_bins, rho_num_bins)
[m,n] = size(img);
theta = linspace(-90, 90-180/theta_num_bins, theta_num_bins)*pi/180;
len_th = length(theta);
D = round(norm([m,n]));
dist = ceil(D/rho_num_bins);
bins = ceil(D/dist);
len_rh = 2*bins + 1;
rho = linspace(-bins*dist, bins*dist, len_rh);
[x,y] = find(img);
hough_img = zeros(len_rh,len_th);
cos_value = cos(theta);
sin_value = sin(theta);

for i = 1 : length(x)
    for k = 1 : len_th
        rho_index = round((x(i)-1)*cos_value(k) + (y(i)-1)*sin_value(k) - rho(1));
        hough_img(rho_index, k) = hough_img(rho_index, k) + 1;
    end
end
hough_img = round((hough_img - min(hough_img(:))).*255./(max(hough_img(:)-min(hough_img))));
end