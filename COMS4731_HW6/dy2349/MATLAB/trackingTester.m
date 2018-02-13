function trackingTester(data_params, tracking_params)
img = imread(fullfile(data_params.data_dir,...
    data_params.genFname(data_params.frame_ids(1))));
rect = tracking_params.rect;
bin = tracking_params.bin_n;
search_win_size = tracking_params.search_half_window_size;
tpl = img(rect(2) : rect(2)+rect(4)-1, rect(1) : rect(1)+rect(3)-1, :);
[M, map] = rgb2ind(tpl, bin);
H = histcounts(M(:), bin); 

for i = 1 : size(data_params.frame_ids, 2)
    img = imread(fullfile(data_params.data_dir,...
        data_params.genFname(data_params.frame_ids(i))));
    [m,n,k] = size(img);
    x1 = max(1, rect(2) - search_win_size(2));
    x2 = min(m, rect(2) + rect(4) + search_win_size(2))-1;
    y1 = max(1, rect(1) - search_win_size(1));
    y2 = min(n, rect(1) + rect(3) + search_win_size(1))-1;
    win = img(x1:x2, y1:y2,:);
    wins(:,:,1) = im2col(win(:,:,1), [rect(4), rect(3)]);
    wins(:,:,2) = im2col(win(:,:,2), [rect(4), rect(3)]);
    wins(:,:,3) = im2col(win(:,:,1), [rect(4), rect(3)]);
    
    for j = 1 : size(wins, 2)
        W(:,j) = rgb2ind(wins(:,j,:),map);
        H_w(:,j) = histcounts(W(:,j), bin); 
    end

    C = normxcorr2(H', H_w);
    [ypeak, xpeak] = find(C == max(C(:)));
    xpeak = mean(xpeak);
    space = size(win, 1) - rect(4) + 1;
    x = floor(xpeak / space) + 1 + y1;
    y = round(mod(xpeak, space) + x1);
    rect(1) = x;
    rect(2) = y;
    res = drawBox(img, [x y rect(3) rect(4)], [0 0 255], 1);
    imshow(res);
    imwrite(res, fullfile(data_params.out_dir, data_params.genFname(data_params.frame_ids(i))));
end
end