db_img = 'many_objects_1';
labeled_img = imread(['labeled_' db_img '.png']);
orig_img = imread([db_img '.png']);
[obj_db, out_img] = compute2DProperties(orig_img, labeled_img);
% img_list = {'many_objects_1', 'many_objects_2'};
% 
% for i = 1:length(img_list)
%     labeled_img = imread(['labeled_' img_list{i} '.png']);
%     orig_img = imread([img_list{i} '.png']);
%     
%     output_img = recognizeObjects(orig_img, labeled_img, obj_db);
%     %imwrite(output_img, ['testing1c1_' img_list{i} '.png']);
% end
orig = imread('many_objects_2.png');
labeled = imread('labeled_many_objects_2.png');
output_img = recognizeObject(orig, labeled, obj_db);

function output_img = recognizeObject(orig_img, labeled_img, obj_db)
[props, out] = compute2DProperties(orig_img, labeled_img);
count = 0;
labels = zeros(length(props(1, :)),1);
length(props(1, :))
length(obj_db(1, :))

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
imshow(orig_img);
hold on;
for i = 1 : count
    label = labels(i);
    plot( props(2, label), props(3, label), 'ws', 'MarkerFaceColor', [1 0 0]);
    line([props(2, label), props(3, label)],[props(2, label)+20, props(3, label)+ 20*tan(props(5, label))], 'LineWidth',2, 'Color', [0, 1, 0]);
    %quiver(props(2, label), props(3, label), 20, 20*tan(props(5, label)), 'r','LineWidth',1.5);
end
ouput_img = orig_img;
end