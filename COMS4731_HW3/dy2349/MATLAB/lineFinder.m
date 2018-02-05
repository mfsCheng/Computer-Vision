function line_detected_img = lineFinder(orig_img, hough_img, hough_threshold)
hough_threshold = hough_threshold*max(hough_img(:));
[M,N] = size(hough_img);
theta = linspace(-90, 90-180/N, N)*pi/180;
rho = linspace(-(M-1)/2, (M-1)/2, M);
numpeaks = 20;
neighbour = size(hough_img)/60;
neighbour = ceil(neighbour/2);

peaks = [];
while size(peaks, 1) < numpeaks
    [dummy max_idx] = max(hough_img(:));
    x = mod(max_idx(1), M);
    y = ceil(max_idx(1)/M);
    if hough_img(x, y) >= hough_threshold
        peaks = [peaks; [x,y]];
        x1 = max(1, x - neighbour(1)); 
        x2 = min(M, x + neighbour(1));
        y1 = max(1, y - neighbour(2)); 
        y2 = min(N, y + neighbour(2)); 
        hough_img(x1 : x2, y1 : y2) = 0;
    else
        break;
    end
end
fh = figure;
imshow(orig_img);
hold on;
for i = 1 : length(peaks)
    a = rho(peaks(i, 1));
    b = theta(peaks(i, 2));
    k_p = -(sin(b)/cos(b));
    m_p = a/cos(b);
    z = 1:size(orig_img, 2);
    line(z, z*k_p+m_p,'linewidth',1.5);
end
line_detected_img = saveAnnotatedImg(fh);
end

function annotated_img = saveAnnotatedImg(fh)
figure(fh); 
set(fh, 'WindowStyle', 'normal');
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);
frame = getframe(fh);
pause(0.5); 
annotated_img = frame.cdata;
end