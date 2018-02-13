function dest_pts_nx2 = applyHomography(H_3x3, src_pts_nx2)
src_pts_nx2 = src_pts_nx2.';
%src = [src_pts_nx2(2,:); src_pts_nx2(1,:); ones(1,4)];
src = [src_pts_nx2; ones(1,length(src_pts_nx2))];
dest = H_3x3 * src;
%dest_pts_nx2 = [(dest(2,:)./dest(3,:)).', (dest(1,:)./dest(3,:)).'];
dest_pts_nx2 = [((dest(1,:)./dest(3,:)))', ((dest(2,:)./dest(3,:)))'];
end