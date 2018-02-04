function output_img = recognizeObjects(orig_img, labeled_img, obj_db)
[props, out] = compute2DProperties(orig_img, labeled_img);
count = 0;
% labels of the recognized objects
labels = zeros(length(props(1, :)),1);
for i = 1 : length(props(1, :))
    for j = 1 : length(obj_db(1, :))
        if abs(props(6, i) - obj_db(6, j)) >= props(6, i)*0.1
            continue;
        end
        if abs(props(7, i) - obj_db(7, j)) >= 300
            continue;
        end
        count = count + 1;
        labels(count) = props(1, i);
    end
end
fh = figure();
imshow(orig_img);
hold on;
for i = 1 : count
    label = labels(i);
    plot( props(2, label), props(3, label), 'ws', 'MarkerFaceColor', [1 0 0]);
    line([props(2, label)-30, props(2, label)+30], ...
        [props(3, label)-30*tan(props(5, label)), props(3, label)+30*tan(props(5, label))],...
        'LineWidth',2, 'Color', [0, 1, 0]);
    %quiver(props(2, label), props(3, label), 20, 20*tan(props(5, label)), 'r','LineWidth',1.5);
end
output_img = saveAnnotatedImg(fh);
end

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh
set(fh, 'WindowStyle', 'normal');
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);
frame = getframe(fh);
pause(0.5);  
annotated_img = frame.cdata;
end