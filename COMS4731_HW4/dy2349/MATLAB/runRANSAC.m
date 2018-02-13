function [inliers_id, H] = runRANSAC(Xs, Xd, ransac_n, eps)
eps = eps*eps;
max = 0;
for i = 1 : ransac_n
    ind = randperm(length(Xs), 4);
    src_pts = Xs(ind,:);
    dest_pts = Xd(ind,:);
    H_3x3 = computeHomography(src_pts, dest_pts);
    res_pts = applyHomography(H_3x3, Xs);
    diff = (res_pts - Xd).^2;
    dist = sum(diff,2);
    num = length(find(dist < eps));
    if num > max
        H = H_3x3;
        inliers_id = find(dist < eps);
        max = num;
    end
end
end