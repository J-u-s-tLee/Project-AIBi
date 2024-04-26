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

for k=1:size
    figure;
    imshow(mask_vetor{k});
end

%preenche ate cima: 3,7,12,14,15,18
%fica preto: 6