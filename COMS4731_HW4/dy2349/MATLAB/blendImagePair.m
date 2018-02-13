function out_img = blendImagePair(wrapped_imgs, masks, wrapped_imgd, maskd, mode)
wrapped_imgs = im2double(wrapped_imgs);
wrapped_imgd = im2double(wrapped_imgd);
if strcmpi(mode, 'blend')
      overlap = bitand(masks, maskd);
      [idx, idy] = find(overlap ~= 0);
      mask_overlap = ~zeros(max(idx) - min(idx) + 1, max(idy) - min(idy) + 1);
      mask_ols = zeros(max(idx) - min(idx) + 1, max(idy) - min(idy) + 1);
      mask_ols(:,max(idy) - min(idy) + 1) = ones(max(idx) - min(idx) + 1, 1);
      mask_ols = double(bwdist(mask_ols));
      mask_ols = mask_ols / max(mask_ols(:));
      mask_old = zeros(max(idx) - min(idx) + 1, max(idy) - min(idy) + 1);
      mask_old(:,1) = ones(max(idx) - min(idx) + 1, 1);
      mask_old = double(bwdist(mask_old));
      mask_old = mask_old / max(mask_old(:));
      masks = double(logical(masks));
      maskd = double(logical(maskd));
      masks(min(idx):max(idx),min(idy):max(idy)) = mask_ols;
      maskd(min(idx):max(idx),min(idy):max(idy)) = mask_old;
%     imshow(wrapped_imgs .* masks);
%     imshow(wrapped_imgd .* maskd);
    out_img = wrapped_imgs .* cat(3, masks, masks, masks) + ...
        wrapped_imgd .* cat(3, maskd, maskd, maskd);
end
if strcmpi(mode, 'overlay')
    masks = logical(masks);
    out_img = wrapped_imgs .* cat(3, masks, masks, masks);
    maskd = logical(maskd);
    imaskd = ~maskd;
    out_img = out_img .* cat(3, imaskd, imaskd, imaskd) + ...
        wrapped_imgd .* cat(3, maskd, maskd, maskd);
end
end