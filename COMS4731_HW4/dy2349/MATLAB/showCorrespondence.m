function result_img = ...
    showCorrespondence(orig_img, warped_img, src_pts_nx2, dest_pts_nx2)
[src_m,src_n, k] = size(orig_img);
dest_pts_nx2(:,1) = dest_pts_nx2(:,1)+src_n;
img = [orig_img, warped_img];
fh = figure(); imshow(img);
hold on;
plot(src_pts_nx2(:,1), src_pts_nx2(:,2),'b.', 'MarkerSize', 14);
plot(dest_pts_nx2(:,1), dest_pts_nx2(:,2), 'b.', 'MarkerSize', 14);
for i = 1 : length(src_pts_nx2)
    line([src_pts_nx2(i,1), dest_pts_nx2(i,1)],[src_pts_nx2(i,2), dest_pts_nx2(i,2)], 'LineWidth',2, 'Color', 'r');
end
result_img = saveAnnotatedImg(fh);
end

function annotated_img = saveAnnotatedImg(fh)
figure(fh);  set(fh, 'WindowStyle', 'normal');
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]); 
frame = getframe(fh);
frame = getframe(fh);
pause(0.5); 
annotated_img = frame.cdata;
end