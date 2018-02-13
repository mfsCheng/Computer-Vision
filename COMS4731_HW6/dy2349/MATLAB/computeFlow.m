function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
[M, N] = size(img1);
m = grid_MN(1);
n = grid_MN(2);
interval_m = M / m;
interval_n = N / n;
px = zeros(m, n);
py = zeros(m, n);
for i = interval_m / 2 : interval_m : M - interval_m / 2
    for j = interval_n / 2 : interval_n : N - interval_n / 2
        %template = img1(i - template_radius : i + template_radius, j - template_radius : j + template_radius);
        a1 = max(1,i - template_radius);
        a2 = min(M,i + template_radius);
        b1 = max(1,j - template_radius);
        b2 = min(N, j + template_radius);
        template = img1(a1 : a2, b1 : b2);
        x1 = max(1, i - win_radius);
        x2 = min(M, i + win_radius);
        y1 = max(1, j - win_radius);
        y2 = min(N, j + win_radius);
        window = img2(x1 : x2, y1 : y2);
        C = normxcorr2(template, window);
        C = C(size(template,1) : size(C,1) - size(template, 1),size(template,2):size(C,2) - size(template, 2));
        [xpeak, ypeak] = find(C == max(C(:)));
        y = ypeak(1);% - size(template,2) + 1;
        x = xpeak(1);% - size(template,1) + 1;
        a = x - (a1 - x1 + 1);
        b = y - (y1 - b1 + 1);
        px(i - interval_m / 2 + 1, j - interval_n / 2 + 1) = x - (a1 - x1 + 1);
        py(i - interval_m / 2 + 1, j - interval_n / 2 + 1) = y - (b1 - y1 + 1);
    end
end
fh = figure;
imshow(img1);
hold on;
for i = 1 : interval_m : M
    for j = 1 : interval_n : N
        quiver(j + interval_n/2, i + interval_m/2, py(i, j), px(i, j),'filed', 'y','MaxHeadSize',1, 'LineWidth', 0.7);
    end
end
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);
frame = getframe(fh);
result = frame.cdata;
end

