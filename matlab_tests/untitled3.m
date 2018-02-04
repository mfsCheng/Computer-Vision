img = imread('two_objects.png');
threshold = 0.5;
bw_img = im2bw(img, threshold);
labeled_img = bwlabel(bw_img);
subplot(1,2,1)
imshow(label2rgb(labeled_img));

label_img = bwconncomp(bw_img);
l = labelmatrix(label_img);
subplot(1,2,2);
imshow(label2rgb(l));