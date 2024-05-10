clear;clc;close all;
pasta = 'C:\Users\maria\OneDrive\Documentos\MATLAB\Train1';
image_vector = read_data(pasta);
size = length(image_vector{2});
mask_vetor = cell(1,size);
right_limit = zeros (1,size);
bottom_limit = zeros(1,size);
for i=1:size
    Image = im2double(image_vector{2}{i}); 
    [mask_vetor{i}, right_limit(i), bottom_limit(i)] = ROI_hough(Image);
    close; %ver se da para nao abrir imagem de todo
end

Image = image_vector{2}{8};
mask=image_vector{3}{8};
Image_gray = im2gray(Image);
Image_gray(~mask)=0;
SE1 = strel('square', 25);
Image_bothat = imbothat(Image_gray, SE1);
T = multithresh(Image_bothat, 4);
Image_thresh = imquantize(Image_bothat, T);
[centers, radii] = imfindcircles(Image_thresh == 3, [15 800]);

indices = true(1, length(centers)); 
for c = 1:length(centers)
    if (centers(c,1) + radii(c) > right_limit(8)) || (centers(c,2) - radii(c) < bottom_limit(8))
        indices(c) = false; % Define índice para false se não atender às condições
    end
end

centers = centers(indices, :);

figure(1);
imshow(Image_gray,[]);
viscircles(centers, radii, 'EdgeColor', 'b');


% Se o pixel não for preto e o da frente e/ou abaixo for preto então
% não conta. 
% Tenho de iterar pela imagem toda e se encontrar um pixel da bounding
% box ver a condição de antes. 
% Se não respeitar as condições então apaga-se os centros e raios

num_circles= length(centers);
corners = zeros (4, 2, num_circles);
for i = 1:num_circles
    x_center = centers(i, 1);
    y_center = centers(i, 2);

    x1=x_center - radii(i);
    y1=y_center - radii(i);
    x2=x_center + radii(i);
    y2=y_center + radii(i);

    corners(:,:,i)=[x1 y1;x1 y2;x2 y1; x2 y2];

end

for i = 1:num_circles
corner1 = corners(1, :, i);
corner4 = corners(4, :, i);

% Calcular as coordenadas do retângulo
x1 = corner1(1);
y1 = corner1(2);
width = corner4(1) - x1;
height = corner4(2) - y1;

% Desenhar retângulo com cor branca na imagem original
Image_gray(y1:y1+height, x1:x1+width) = 1;

end

Image_gray(Image_gray ~= 1) = 0;
figure(2)
imshow(Image_gray,[])

cell_location_gt = image_vector{1}{8};
m = length(cell_location_gt.cellLocationsData);
%heigth = cell_location_gt.cellLocationsData  

Image_gray(y1:y1+height, x1:x1+width) = 1;