function refocusApp(rgb_stack, depth_map)
[m, n, k] =size(rgb_stack);
img = rgb_stack(:, :, 1:3);
figure; imshow(img/255); title('Please choose a scene point');
[X, Y] = ginput(1); hold on;
plot(X,Y,'Color','r','Marker', '.', 'MarkerSize', 10);
X = round(X);
Y = round(Y);
while (0 <= X && X <= n && 0 <= Y && Y <= m)
    index = depth_map(Y,X);
    img = rgb_stack(:, :, (index-1)*3+1:index*3);
    imshow(img/255); hold on;
    [X, Y] = ginput(1);
    plot(X,Y,'Color','r','Marker', '.', 'MarkerSize', 10);
    X = round(X);
    Y = round(Y);
end
close all;
end
