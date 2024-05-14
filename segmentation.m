function [Image_segmented, locations] = segmentation (Image, mask)
%Função que, após pré-processamento da imagem, deteta as células na região 
%de interesse e cria bounding box à volta das mesmas.
%Devolve imagem original marcada nas células detetadas 
%e localização e coordenadas da bounding box

%Pré-processamento
Image_gray = im2gray(Image);
Image_gray(~mask)=0; %aplicação da máscara
SE1 = strel('square', 25);
Image_bothat = imbothat(Image_gray, SE1);
T = multithresh(Image_bothat, 4);
Image_thresh = imquantize(Image_bothat, T);

%Deteção das células
[centers, radii] = imfindcircles(Image_thresh == 3, [15 800]); 

% Se o extremo direito ou extremo baixo do circulo estiver fora da ROI,
% então a célula não deve ser detetada.
% Nesse caso, apagam-se os centros e raios correspondentes:

if (~isempty(centers))
    n = length(centers(:,1));
    indices = true(1,n); 
    for c = 1:n
        if (Image_gray(round(centers(c,2)), round(centers(c,1) + radii(c))) == 0 || Image_gray(round(centers(c,2) + radii(c)), round(centers(c,1))) ==0)
            indices(c) = false;
        end
    end
    
    centers = centers(indices, :);
    radii = radii (indices, :);
end

%Criação da imagem com bounding boxes desenhadas
%e vetor com localizações das bounding boxes
figure(1);
imshow(Image_gray,[]);
hold on;

if (~isempty(centers))
    num_circles = length(centers(:,1));
    corners = zeros (4, 2, num_circles);
    %Definição das coordenadas da bounding box para cada célula detetada
    for i = 1:num_circles 
        x_center = centers(i, 1);
        y_center = centers(i, 2);
    
        x1=x_center - radii(i);
        y1=y_center - radii(i);
        x2=x_center + radii(i);
        y2=y_center + radii(i);
    
        corners(:,:,i)=[x1 y1;x1 y2;x2 y1; x2 y2];    
    end
    
    locations = zeros(num_circles,4);
    
    for i = 1:num_circles
    corner1 = corners(1, :, i);
    corner4 = corners(4, :, i);
    
    % Definição das dimensões da bounding box
    x1 = corner1(1);
    y1 = corner1(2);
    width = corner4(1) - x1;
    height = corner4(2) - y1;

    %Guardar coordenadas e dimensões da bounding box
    locations(i,1:4) = [x1, y1, width, height];

    %Desenhar bounding box na imagem original
    rectangle('Position', [x1, y1, width, height], 'EdgeColor', 'g', 'LineWidth', 2);
    end
    
else
    locations = []; %se não forem detetadas células
end

hold off;
frame = getframe(gcf);
Image_segmented = frame.cdata;

end