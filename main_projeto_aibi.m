clear;clc;close all;
pasta = 'C:\Users\maria\OneDrive\Documentos\MATLAB\Train1';
image_vector = read_data(pasta);
size = length(image_vector{2});
mask_vetor = cell(1,size);

for i=1:size
    Image = im2double(image_vector{2}{i}); 
    mask_vetor{i} = ROI_hough(Image);
    close; %ver se da para nao abrir imagem de todo
end

%%

for i=1:size
    Image = image_vector{2}{i};
    mask=image_vector{3}{i};
    [Image_segmented, Image_squares] = segmentation (Image, mask);
    figure
    imshow(Image_segmented);
end

%% jaccard

cell_location_gt = image_vector{1}{8};
m = length(cell_location_gt.cellLocationsData);
GT_squares = I;
GT_squares(:,:) = 0;
GT_squares = im2bw(GT_squares);
for n=1:m
    x_corner = cell_location_gt.cellLocationsData(n,1); 
    y_corner = cell_location_gt.cellLocationsData(n,2); 
    width = cell_location_gt.cellLocationsData(n,3); 
    height = cell_location_gt.cellLocationsData (n,4);
    GT_squares(y_corner:y_corner+height, x_corner:x_corner+width) = 1;
end
figure
imshow(GT_squares);


