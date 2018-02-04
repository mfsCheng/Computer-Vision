img = imread('variable_test.png');
imshow(img); hold on;
plot( 100, 200, 'ws', 'MarkerFaceColor', [1 0 0]);

x = [0,0,0;0,0,1;0,0,0];
find(x==1)