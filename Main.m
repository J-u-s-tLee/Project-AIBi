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

%% Task2 - Morphological + ROI GT

Evaluation = zeros(Size, 7);

for i=1:Size
    Image = Vetor_de_Imagens{2}{i};
    Mask = Vetor_de_Imagens{3}{i}; 
    Cell_Location_GT = Vetor_de_Imagens{1}{i};
    [Locations] = Segmentation(Image, Mask, "Morphological");
    GT_Locations = Cell_Location_GT.cellLocationsData;
    [Counted_cells, TP, FP, FN, Recall, Precision, F_measure] = Segmentation_Evaluation(GT_Locations,Locations);
    Evaluation(i,:) = [Counted_cells, TP, FP, FN, Recall, Precision, F_measure];
    clc;
    disp("Loading: " + i*100/Size+ "% ")
end
%%
Evaluation_Table = Evaluation_Table(Evaluation);
disp (Evaluation_Table);

%% Task2 - Morphological + Morphological ROI

Evaluation = zeros(Size, 7);

for i=1:Size
    Image = Vetor_de_Imagens{2}{i};
    Mask = MorphologicalFilters(Image);
    Cell_Location_GT = Vetor_de_Imagens{1}{i};
    [Locations] = Segmentation(Image, Mask, "Morphological");
    GT_Locations = Cell_Location_GT.cellLocationsData;
    [Counted_cells, TP, FP, FN, Recall, Precision, F_measure] = Segmentation_Evaluation(GT_Locations,Locations);
    Evaluation(i,:) = [Counted_cells, TP, FP, FN, Recall, Precision, F_measure];

end

Evaluation_Table = Evaluation_Table(Evaluation);
disp (Evaluation_Table);


%% Task2 - Clustering + ROI GT

Evaluation = zeros(Size, 7);

for i=1:Size
    Image = Vetor_de_Imagens{2}{i};
    Mask = Vetor_de_Imagens{3}{i};
    Cell_Location_GT = Vetor_de_Imagens{1}{i};
    [Locations] = Segmentation(Image, Mask, "Clustering");
    GT_Locations = Cell_Location_GT.cellLocationsData;
    [Counted_cells, TP, FP, FN, Recall, Precision, F_measure] = Segmentation_Evaluation(GT_Locations,Locations);
    Evaluation(i,:) = [Counted_cells, TP, FP, FN, Recall, Precision, F_measure];

end

Evaluation_Table = Evaluation_Table(Evaluation);
disp (Evaluation_Table);

%% Task2 - Clustering + Morphological ROI

Evaluation = zeros(Size, 7);

for i=1:Size
    Image = Vetor_de_Imagens{2}{i};
    Mask = MorphologicalFilters(Image);
    Cell_Location_GT = Vetor_de_Imagens{1}{i};
    [Locations] = Segmentation(Image, Mask, "Clustering");
    GT_Locations = Cell_Location_GT.cellLocationsData;
    [Counted_cells, TP, FP, FN, Recall, Precision, F_measure] = Segmentation_Evaluation(GT_Locations,Locations);
    Evaluation(i,:) = [Counted_cells, TP, FP, FN, Recall, Precision, F_measure];

end

Evaluation_Table = Evaluation_Table(Evaluation);
disp (Evaluation_Table);

%% Example

index = 16;
Image = Vetor_de_Imagens{2}{index};
Mask_Morph = MorphologicalFilters(Image);
Mask_GT = Vetor_de_Imagens{3}{index};
Cells_GT = Vetor_de_Imagens{1}{index};
Locations_Morph = Segmentation(Image, Mask_GT, "Morphological");
Show_Detected_Cells (Image, Locations_Morph)
