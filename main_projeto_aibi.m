clear;clc;close all;
pasta = 'C:\Users\maria\OneDrive\Documentos\MATLAB\Train1';
image_vector = read_data(pasta);
size = length(image_vector{2});

%% parte 1 - Hough
mask_vector = cell(1,size);

for i=1:size
    Image = im2double(image_vector{2}{i}); 
    mask_vector{i} = ROI_hough(Image);
    close; %ver se da para nao abrir imagem de todo
end

%% parte 1 - Leandro

%% pate 2 - com ROI GT
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

Evaluation_table = evaluation_table(evaluation);
disp (Evaluation_table);

%% parte 2 - com ROI Hough
evaluation_extra = zeros(size,6);
for i=1:size
    Image = image_vector{2}{i};
    mask = mask_vector{i};
    [Image_segmented, locations] = segmentation (Image, mask); %nao funciona porque a mascara nao esta no sitio certo
    figure
    imshow(Image_segmented); 
    cell_location_gt = image_vector{1}{i};
    gt_locations = cell_location_gt.cellLocationsData;
    [TP, FP, FN, recall, precision, F_measure] = segmentation_evaluation(gt_locations,locations);
    evaluation_extra(i,:) = [TP, FP, FN, recall, precision, F_measure];
end

Evaluation_table = evaluation_table(evaluation);
disp (Evaluation_table);

%% parte 2 - com ROI Leandro
Image = image_vector{2}{8};
mask = mask_vector{8};
[Image_segmented, locations] = segmentation (Image, mask);
figure;
imshow(Image_segmented);

%% exemplo do relatório
Image = image_vector{2}{8};
mask_gt = image_vector{3}{8};
[Image_segmented_GT, locations_GT] = segmentation (Image, mask_gt);
figure;
imshow(Image_segmented_GT);
title('Segmentação com ROI GT');
mask_hough = mask_vector{8};
figure;
imshow(mask_hough);
title('ROI com Hough');
[Image_segmented_hough, locations_hough] = segmentation (Image, mask_hough);
figure;
imshow(Image_segmented_hough);
title('Segmentação com ROI Hough');
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