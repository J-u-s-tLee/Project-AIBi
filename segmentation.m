function [locations] = segmentation (Image, mask,method)
%Função que, após pré-processamento da imagem, deteta as células na região 
%de interesse e determina as bounding boxes à volta das mesmas.
%Devolve a localização e coordenadas das bounding boxes

%Pré-processamento
if method=="morphological"
    Image_preprocessed = Preprocessing(Image);
else 
    Image_preprocessed=Clustering(Image);
end
%Deteção das células
[centers, radii] = imfindcircles(Image_preprocessed, [20 1000]); 

% Se o canto inferior direito da bounding box estiver fora da ROI,
% então a célula não deve ser detetada.
% Nesse caso, apagam-se os centros e raios correspondentes:

[m n]=size(mask);

%Criação de um vetor com localizações das bounding boxes
if (~isempty(centers))
    num_circles = length(centers(:,1));
    corners = zeros (4, 2, num_circles);
    %Definição das coordenadas da bounding box para cada célula detetada
    for i = 1:num_circles 
        x_center = centers(i, 1);
        y_center = centers(i, 2);
    
        x1=round(x_center - radii(i));
        y1=round(y_center - radii(i));
        x2=round(x_center + radii(i));
        y2=round(y_center + radii(i));
    
        corners(:,:,i)=[x1 y1;x1 y2;x2 y1; x2 y2];    
    end
    
    locations = zeros(num_circles,4);
    
    for i = 1:num_circles
    corner1 = corners(1, :, i);
    corner4 = corners(4, :, i);
   
    if corner4(2)>m || corner4(1)>n
        continue;
    elseif mask(corner4(2),corner4(1))==0
        continue;
    end
    % Definição das dimensões da bounding box
    x1 = corner1(1);
    y1 = corner1(2);
    width = corner4(1) - x1;
    height = corner4(2) - y1;

    %Guardar coordenadas e dimensões da bounding box
    locations(i,1:4) = [x1, y1, width, height];

    end
c = size(locations, 1);
for i = c:-1:1
    if locations(i, 3) == 0
        locations(i, :) = [];
    end
end
else
    locations = []; %se não forem detetadas células
end

end
