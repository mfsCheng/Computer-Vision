%first ????1
%???
img = imread('two_objects.png');
threshold = 0.5;
bw_img = im2bw(img, threshold);
[m,n] = size(bw_img);
temp_img = zeros(m+1, n+1);
label = 1;
equ_table = containers.Map('KeyType','double','ValueType','double');
for i = 2 : m+1
    for j = 2 : n+1
        temp_img(i,j) = bw_img(i-1, j-1);
    end
end
for i = 2 : m+1
    for j = 2 : n+1
        if temp_img(i, j) == 1
            if temp_img(i-1, j-1) ~= 0
                temp_img(i,j) = temp_img(i-1, j-1);
            elseif temp_img(i-1, j-1) == 0 && temp_img(i, j-1) == 0 && temp_img(i-1, j) == 0
                temp_img(i, j) = label;
                label = label + 1;
            elseif temp_img(i, j-1) ~= 0 && temp_img(i-1, j) == 0
                temp_img(i, j) = temp_img(i, j-1);
            elseif temp_img(i-1, j) ~= 0 && temp_img(i, j-1) == 0
                temp_img(i, j) = temp_img(i-1, j);
%             elseif temp_img(i, j-1) ~= 0 && temp_img(i-1, j) ~= 0
%                 temp_img(i, j) = temp_img(i-1, j);
%                 if isKey(equ_table, temp_img(i, j-1)) && isKey(equ_table, temp_img(i-1,j))
%                     equ_table(equ_table(temp_img(i-1, j))) = equ_table(temp(i, j-1));
%                 elseif isKey(equ_table, temp_img(i-1,j))
%                     equ_table(temp_img(i, j-1)) = equ_table(temp_img(i-1, j));
%                 elseif isKey(equ_table, temp_img(i,j-1)) 
%                     equ_table(temp_img(i-1, j)) = equ_table(temp_img(i, j-1));
%                 else
%                     equ_table(temp_img(i,
%                 end
%                 if ~isKey(equ_table, temp_img(i, j-1))
%                     equ_table(temp_img(i, j-1)) = temp_img(i-1, j);
%                 elseif ~isKey(equ_table, temp_img(i-1,j)) 
%                     equ_table(temp_img(i-1, j)) = temp_img(i, j-1);
%                 elseif isKey(equ_table, temp_img(i, j-1)) && isKey(equ_table, temp_img(i-1,j))
%                     pre = temp_img(i, j-1);
%                     key = temp_img(i-1, j);
%                     next = equ_table(temp_img(i-1, j));
%                     while isKey(equ_table, key)
%                         equ_table(key) = pre;
%                         pre = key;
%                         key = next;
%                         disp(key);
%                         if isKey(equ_table, key)
%                             next = equ_table(key);
%                         else
%                             equ_table(key) = pre;
%                             break;
%                         end
%                     end
%                 end
            end
        end       
    end
end
for i = 1 : m
    for j = 1 : n
        bw_img(i, j) = temp_img(i+1, j+1);
    end
end

keys = equ_table.keys();
for i = 1 : length(equ_table)
    key = keys{i}(1);
    while isKey(equ_table,key)
        key = equ_table(key);
    end
    equ_table(keys{i}(1)) = key;
end
    
bw_img = uint8(bw_img);
for i = 1 : m
    for j = 1 : n
        if isKey(equ_table,temp_img(i+1, j+1))
            bw_img(i, j) = equ_table(temp_img(i+1, j+1));
        else
            bw_img(i, j) = temp_img(i+1, j+1);
        end
    end
end

subplot(1,2,1)
imshow(label2rgb(bw_img));

labeled_img = bwconncomp(bw_img);
l = labelmatrix(labeled_img);
subplot(1,2,2);
imshow(label2rgb(l));