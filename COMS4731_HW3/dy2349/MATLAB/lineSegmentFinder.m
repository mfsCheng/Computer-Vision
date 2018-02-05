function cropped_line_img = lineSegmentFinder(orig_img, hough_img, hough_threshold)
edge_img = edge(orig_img,'canny', [hough_threshold(2),hough_threshold(3)]);
hough_threshold = hough_threshold(1)*max(hough_img(:));
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

[x_l, y_l] = find(edge_img);

gap = 12;
gap = gap*gap;
min_len = 20;
min_len = min_len*min_len;

fh = figure;
imshow(orig_img);
hold on;

for w = 1 : size(peaks,1)
    peak = peaks(w, :);
    th = theta(peak(2));
    rh = round((x_l-1)*cos(th) + (y_l-1)*sin(th)-rho(1));
    index = find(rh == peak(1));
    points = [[y_l(index(1)), x_l(index(1))]];
    for i = 1 : length(index)-1
        if (x_l(index(i))-x_l(index(i+1)))^2 + (y_l(index(i))-y_l(index(i+1)))^2 > gap
            points = [points; [y_l(index(i)), x_l(index(i))]; [y_l(index(i+1)), x_l(index(i+1))]];
        end
    end
    points = [points; [y_l(index(length(index))), x_l(index(length(index)))]];

    for p = 1 : 2 : length(points)-1
        p1 = points(p,:);
        p2 = points(p+1,:);
        seg_len = sum((p2-p1).^2);
        if seg_len >= min_len 
            plot(p1(1),p1(2), '*','MarkerEdgeColor', 'r');
            plot(p2(1),p2(2), '*', 'MarkerEdgeColor', 'r');
            line([p2(1),p1(1)],[p2(2),p1(2)],'linewidth',2);
        end
    end
end
    cropped_line_img = saveAnnotatedImg(fh);
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