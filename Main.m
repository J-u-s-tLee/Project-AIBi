%% Read Data
clear;clc;close all;
Directory = 'C:\Users\lm803\OneDrive\Ambiente de Trabalho\AIBi\2. Projeto\Train1';
Vetor_de_Imagens = Read_Data(Directory);
Size = length(Vetor_de_Imagens{2});

%% Task1 - Hough Transform

Metrics_Table = Metrics(Vetor_de_Imagens, "ROI_Hough");
disp(Metrics_Table)

%% Task1 - Morphological Filters

Metrics_Table = Metrics(Vetor_de_Imagens, "MorphologicalFilters");
disp(Metrics_Table)

%% pate 2 - com ROI GT
evaluation = zeros(size,7);
for i=1:size
    Image = image_vector{2}{i};
    mask=image_vector{3}{i};
    [Image_segmented, locations] = segmentation (Image, mask); %por quadrados em vez de circulos!!!
    cell_location_gt = image_vector{1}{i};
    gt_locations = cell_location_gt.cellLocationsData;
    [counted_cells, TP, FP, FN, recall, precision, F_measure] = segmentation_evaluation(gt_locations,locations);
    evaluation(i,:) = [counted_cells, TP, FP, FN, recall, precision, F_measure];
end

Evaluation_table = evaluation_table(evaluation);
disp (Evaluation_table);

%% parte 2 - com ROI Hough
evaluation_extra = zeros(size,7);
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
mask = 
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
mask_hough = ROI_hough(Image);
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
