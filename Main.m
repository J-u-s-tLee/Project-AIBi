%% Read Data
clear;clc;close all;
Directory = 'C:\Users\maria\OneDrive\Documentos\MATLAB\Train1';
image_vector = read_data(Directory);
Size = length(image_vector{2});

%% Task1 - Hough Transform

Metrics_Table = Metrics(image_vector, "ROI_Hough");
disp(Metrics_Table)

%% Task1 - Morphological Filters

Metrics_Table = Metrics(image_vector, "MorphologicalFilters");
disp(Metrics_Table)

%% parte 2 - com ROI GT
evaluation = zeros(Size,7);
for i=1:Size
    Image = image_vector{2}{i};
    mask=image_vector{3}{i};
    locations = segmentation (Image, mask); %por quadrados em vez de circulos!!!
    cell_location_gt = image_vector{1}{i};
    gt_locations = cell_location_gt.cellLocationsData;
    [counted_cells, TP, FP, FN, recall, precision, F_measure] = segmentation_evaluation(gt_locations,locations);
    evaluation(i,:) = [counted_cells, TP, FP, FN, recall, precision, F_measure];
end

Evaluation_table = evaluation_table(evaluation);
disp (Evaluation_table);

%% parte 2 - com ROI Hough
evaluation_extra = zeros(Size,7);
for i=1:Size
    Image = image_vector{2}{i};
    mask = ROI_hough(Image);
    locations = segmentation (Image, mask); %nao funciona porque a mascara nao esta no sitio certo
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
mask = %leandro faz
locations = segmentation (Image, mask);
figure;
imshow(Image_segmented);

%% exemplo do relatório
Image = image_vector{2}{8};
mask_gt = image_vector{3}{8};
locations_GT = segmentation (Image, mask_gt);
show_detected_cells(Image, mask_gt, locations_GT);
title('Segmentação com ROI GT');
% mask_hough = ROI_hough(Image);
% figure;
% imshow(mask_hough);
% title('ROI com Hough');
% locations_hough = segmentation (Image, mask_hough);
% show_detected_cells(Image, mask_hough, locations_hough);
% title('Segmentação com ROI Hough');
