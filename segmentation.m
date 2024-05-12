function [Image_segmented, Image_squares] = segmentation (Image, mask)
Image_gray = im2gray(Image);
Image_gray(~mask)=0;
SE1 = strel('square', 25);
Image_bothat = imbothat(Image_gray, SE1);
T = multithresh(Image_bothat, 4);
Image_thresh = imquantize(Image_bothat, T);
[centers, radii] = imfindcircles(Image_thresh == 3, [15 800]);

% Se o extremo direito ou extremo baixo do circulo estiver fora da ROI,
% então a célula não deve ser detetada.
% Nesse caso, apagam-se os centros e raios correspondentes:

n = length(centers(:,1));
indices = true(1,n); 
for c = 1:n
    if (Image_gray(round(centers(c,2)), round(centers(c,1) + radii(c))) == 0 || Image_gray(round(centers(c,2) + radii(c)), round(centers(c,1))) ==0)
        indices(c) = false; % Define índice para false se não atender às condições
    end
end

centers = centers(indices, :);
radii = radii (indices, :);

figure(1);
imshow(Image_gray,[]);
viscircles(centers, radii, 'EdgeColor', 'b');
frame = getframe(gcf);
Image_segmented = frame.cdata;

%Criar imagem binária com quadrados das celulas detetadas:

Image_squares = Image_gray;
num_circles = length(centers(:,1));
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
Image_squares(y1:y1+height, x1:x1+width) = 1;

end

Image_squares(Image_squares ~= 1) = 0;
end