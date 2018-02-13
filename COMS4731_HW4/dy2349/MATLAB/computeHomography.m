function H_3x3 = computeHomography(src_pts_nx2, dest_pts_nx2)
A = zeros(length(src_pts_nx2),9);
% for i = 1 : 4
%     A(2*i-1,:) = [src_pts_nx2(i,2), src_pts_nx2(i,1),1,0,0,0,-src_pts_nx2(i,2)*dest_pts_nx2(i,2),...
%         -src_pts_nx2(i,1)*dest_pts_nx2(i,2), -dest_pts_nx2(i,2)];
%     A(i*2,:) = [0,0,0, src_pts_nx2(i,2), src_pts_nx2(i,1), 1, -src_pts_nx2(i,2)*dest_pts_nx2(i,1),...
%         -src_pts_nx2(i,1)*dest_pts_nx2(i,1), -dest_pts_nx2(i,1)];
% end
for i = 1 : length(src_pts_nx2(:,1))
    A(2*i-1,:) = [src_pts_nx2(i,1), src_pts_nx2(i,2),1,0,0,0,-src_pts_nx2(i,1)*dest_pts_nx2(i,1),...
        -src_pts_nx2(i,2)*dest_pts_nx2(i,1), -dest_pts_nx2(i,1)];
    A(i*2,:) = [0,0,0, src_pts_nx2(i,1), src_pts_nx2(i,2), 1, -src_pts_nx2(i,1)*dest_pts_nx2(i,2),...
        -src_pts_nx2(i,2)*dest_pts_nx2(i,2), -dest_pts_nx2(i,2)];
end
[V,D,W] = eig(A'*A);
% find the smallest eigenvalue
[m,index] = min(D(:));
H_3x3 = W(:,mod(index, 9));
H_3x3 = reshape(H_3x3, 3, 3);
H_3x3 = H_3x3.';
end