function stitched_img = stitchImg(varargin)
imgd = varargin{1};
for i = 2 : numel(varargin)
    [md, nd, k] = size(imgd);
    imgs = double(varargin{i});
%     imshow(imgd);
%     imshow(imgs);
    [ms, ns, k] = size(imgs);
    [xs, xd] = genSIFTMatches(imgs, imgd);
    ransac_n = 20;
    ransac_eps = 10;
    [inliers_id, H_3x3] = runRANSAC(xs, xd, ransac_n, ransac_eps);
    corners = [0,0; 0, ms; ns, 0; ns, ms];
    cornerd = applyHomography(H_3x3, corners);
    col_min = min(cornerd(:,1));
    col_max = max(cornerd(:,1));
    row_min = min(cornerd(:,2));
    row_max = max(cornerd(:,2));
    % direct = 0, imgd on the right
    % direct = 1, imgd on the left
    direct = 0;
    if col_min < 0
        imgd = [zeros(size(imgd,1), round(-col_min), 3), imgd];
        cornerd(:, 1) = cornerd(:, 1) - col_min;
    end
    if col_max > nd
        imgd = [imgd, zeros(size(imgd,1), round(col_max) - nd,3)];
        direct = 1;
    end
    if row_min < 0
        imgd = [zeros(round(-row_min), size(imgd,2),3); imgd];
        cornerd(:, 2) = cornerd(:, 2) - row_min;
    end
    if row_max > md
        imgd = [imgd; zeros(round(row_max) - md, size(imgd,2),3)];
    end
    %H = computeHomography(corners,cornerd);
    [xs_new, xd_new] = genSIFTMatches(imgs, imgd);
    [inliers_id, H] = runRANSAC(xs_new, xd_new, ransac_n, ransac_eps);
    dest_width_height = [size(imgd, 2), size(imgd, 1)];
    [mask, dest_img] = backwardWarpImg(imgs, inv(H), dest_width_height);
%      imshow(dest_img);
%      imshow(imgd);
    imgd_mask = logical(rgb2gray(imgd));
    dest_mask = logical(rgb2gray(dest_img));
    if direct == 0
        imgd = blendImagePair(dest_img, dest_mask(:,:,1), imgd, imgd_mask(:,:,1), 'blend');
    else
         imgd = blendImagePair(imgd, imgd_mask(:,:,1), dest_img, dest_mask(:,:,1) , 'blend');
    end
    %imshow(imgd);
end
stitched_img = imgd;
 imshow(stitched_img);
end