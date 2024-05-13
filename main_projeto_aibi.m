clear;clc;close all;
pasta = 'C:\Users\maria\OneDrive\Documentos\MATLAB\Train1';
image_vector = read_data(pasta);
size = length(image_vector{2});

%% parte 1
mask_vector = cell(1,size);

for i=1:size
    Image = im2double(image_vector{2}{i}); 
    mask_vector{i} = ROI_hough(Image);
    close; %ver se da para nao abrir imagem de todo
end
%% pate 2
%com ROI dado
evaluation = zeros(size,6);
for i=1:size
    Image = image_vector{2}{i};
    mask=image_vector{3}{i};
    [Image_segmented, locations] = segmentation (Image, mask); %por quadrados em vez de circulos!!!
    cell_location_gt = image_vector{1}{i};
    gt_locations = cell_location_gt.cellLocationsData;
    [TP, FP, FN, recall, precision, F_measure] = segmentation_evaluation(gt_locations,locations);
    evaluation(i,:) = [TP, FP, FN, recall, precision, F_measure];
end

average_evaluation = zeros (1,6);
for n=1:6
    average_evaluation(1,n) = mean(evaluation(:,n));
end
std_evaluation = zeros(1,6);
for n=1:6
    std_evaluation(1,n) = std(evaluation(:,n));
end
Evaluation_table = table (average_evaluation(1), average_evaluation(2), average_evaluation(3), average_evaluation(4), average_evaluation(5), average_evaluation(6));
%% agora - acabar
Evaluation_table = addrow (Evaluation_table, [std_evaluation(1),std_evaluation(2), std_evaluation(3), std_evaluation(4), std_evaluation(5), std_evaluation(6)]);
Evaluation_table.Properties.VariableNames = {'TP', 'FP', 'FN', 'recall', 'precision', 'F_measure'};
Evaluation_table.Properties.RowNames = {'average', 'standart desviation'};

disp (Evaluation_table);
% por media e desvio dos valores da evaluation em tabela bonita!!!

%% extra
evaluation_extra = zeros(size,6);
for i=1:size
    Image = image_vector{2}{i};
    mask = mask_vector{i};
    [Image_segmented, locations] = segmentation (Image, mask);
    figure
    imshow(Image_segmented); %por quadrados em vez de circulos!!!
    cell_location_gt = image_vector{1}{i};
    gt_locations = cell_location_gt.cellLocationsData;
    [TP, FP, FN, recall, precision, F_measure] = segmentation_evaluation(gt_locations,locations);
    evaluation(i,:) = [TP, FP, FN, recall, precision, F_measure];
end
%% nao vou usar acho
% Image = image_vector{2}{8};
% mask=image_vector{3}{8};
% [Image_segmented, Image_squares, locations] = segmentation (Image, mask);

% m = length(cell_location_gt.cellLocationsData);
% GT_squares = I;
% GT_squares(:,:) = 0;
% GT_squares = im2bw(GT_squares);
% for n=1:m
%     x_corner = cell_location_gt.cellLocationsData(n,1); 
%     y_corner = cell_location_gt.cellLocationsData(n,2); 
%     width = cell_location_gt.cellLocationsData(n,3); 
%     height = cell_location_gt.cellLocationsData (n,4);
%     GT_squares(y_corner:y_corner+height, x_corner:x_corner+width) = 1;
% end
% figure
% imshow(GT_squares);