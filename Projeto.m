% Criação de um vetor de 3 vetores de imagens onde são armazendas 
% todas as imagens originais, os GT do ROI e o GT da segmentaçao 
clear;clc;

pasta_principal = 'C:\Users\lm803\OneDrive\Ambiente de Trabalho\AIBi\2. Projeto\Train1'; 
subpastas = {'cells1', 'images1', 'ROIs1'};
vetores_de_imagens = cell(1,3);

for k = 1:3
    pasta_atual = fullfile(pasta_principal, subpastas{k}); % Caminho completo para a subpasta atual
    arquivos = dir(pasta_atual); % Obtém a lista de arquivos na subpasta atual
    num_imagens = numel(arquivos)-2; % Número total de imagens na subpasta
    image_vector = cell(1, num_imagens); % Vetor de imagens
    for i = 1:num_imagens-2
        nome_arquivo = fullfile(pasta_atual, arquivos(i+2).name); % Caminho completo para o arquivo
        extensao = nome_arquivo(end-2:end);
        if (extensao == "mat")
            image_vector{i} = load(nome_arquivo); % Le o ficheiro e armazena-o no vetor
        else
        image_vector{i} = imread(nome_arquivo); % Le a imagem e armazena-a no vetor
        end
    end
    vetores_de_imagens{k} = image_vector;% Armazena o vetor de imagens desta subpasta no vetor principal
end

%%

teste = vetores_de_imagens{2}{1,23};
teste_gray = im2gray(teste);
teste_box = double(vetores_de_imagens{3}{1,23});

teste_gray_bin = imbinarize(teste_gray);
SE = strel('square', 20);
teste_close = imclose(teste_gray_bin, SE);
SE2 = strel('square', 50);
teste_erode = double(imerode(teste_close, SE2));
SE3 = strel('square',40);
b = imfill(teste_erode,"holes");
teste_close2 = imopen(b,SE3);
teste_gray(~teste_close2) = 0;


% Label the image.
[labeledImage, numberOfBlobs] = bwlabel(teste_close2);
% Find the centroid
measurements = regionprops(labeledImage, 'Centroid');
% Put a cross at the centroid.
xCentroid = measurements.Centroid(1);
yCentroid = measurements.Centroid(2);
% Find out how far the centroid is from points in each quadrant
% First get all the points.
[rows, columns] = find(teste_close2);
xCorners = [0 0 0 0]; % X coordinate of corners in each quadrant.
yCorners = [0 0 0 0]; % X coordinate of corners in each quadrant.
maxDistance = [0 0 0 0]; % Distance of furthers X coordinate from centroid in each quadrant.
for k = 1 : length(columns)
  rowk = rows(k);
  colk = columns(k);
  distanceSquared = (colk - xCentroid)^2 + (rowk - yCentroid)^2;
  if rowk < yCentroid
    % It's in the top half
    if colk < xCentroid
      % It's in the upper left quadrant
      if distanceSquared > maxDistance(1)
        % Record the new furthest point in quadrant #1.
        maxDistance(1) = distanceSquared;
        xCorners(1) = colk;
        yCorners(1) = rowk;
      end
    else
      % It's in the upper right quadrant
      if distanceSquared > maxDistance(2)
        % Record the new furthest point in quadrant #2.
        maxDistance(2) = distanceSquared;
        xCorners(2) = colk;
        yCorners(2) = rowk;
      end
    end
  else
    % It's in the bottom half.
    if colk < xCentroid
      % It's in the lower left quadrant
      if distanceSquared > maxDistance(3)
        % Record the new furthest point in quadrant #3.
        maxDistance(3) = distanceSquared;
        xCorners(3) = colk;
        yCorners(3) = rowk;
      end
    else
      % It's in the lower right quadrant
      if distanceSquared > maxDistance(4)
        % Record the new furthest point in quadrant #4.
        maxDistance(4) = distanceSquared;
        xCorners(4) = colk;
        yCorners(4) = rowk;
      end
    end
  end
end

Minex = xCorners;
Miney = yCorners;
% Label the image.
[labeledImage, numberOfBlobs] = bwlabel(teste_box);
% Find the centroid
measurements = regionprops(labeledImage, 'Centroid');
% Put a cross at the centroid.
xCentroid = measurements.Centroid(1);
yCentroid = measurements.Centroid(2);
% Find out how far the centroid is from points in each quadrant
% First get all the points.
[rows, columns] = find(teste_box);
xCorners = [0 0 0 0]; % X coordinate of corners in each quadrant.
yCorners = [0 0 0 0]; % X coordinate of corners in each quadrant.
maxDistance = [0 0 0 0]; % Distance of furthers X coordinate from centroid in each quadrant.
for k = 1 : length(columns)
  rowk = rows(k);
  colk = columns(k);
  distanceSquared = (colk - xCentroid)^2 + (rowk - yCentroid)^2;
  if rowk < yCentroid
    % It's in the top half
    if colk < xCentroid
      % It's in the upper left quadrant
      if distanceSquared > maxDistance(1)
        % Record the new furthest point in quadrant #1.
        maxDistance(1) = distanceSquared;
        xCorners(1) = colk;
        yCorners(1) = rowk;
      end
    else
      % It's in the upper right quadrant
      if distanceSquared > maxDistance(2)
        % Record the new furthest point in quadrant #2.
        maxDistance(2) = distanceSquared;
        xCorners(2) = colk;
        yCorners(2) = rowk;
      end
    end
  else
    % It's in the bottom half.
    if colk < xCentroid
      % It's in the lower left quadrant
      if distanceSquared > maxDistance(3)
        % Record the new furthest point in quadrant #3.
        maxDistance(3) = distanceSquared;
        xCorners(3) = colk;
        yCorners(3) = rowk;
      end
    else
      % It's in the lower right quadrant
      if distanceSquared > maxDistance(4)
        % Record the new furthest point in quadrant #4.
        maxDistance(4) = distanceSquared;
        xCorners(4) = colk;
        yCorners(4) = rowk;
      end
    end
  end
end

TP = nnz(teste_box&teste_close2);
FP = nnz(teste_close2 == 1 & teste_box == 0);
FN = nnz(teste_close2 == 0 & teste_box == 1);
Jaccard = TP/(TP+FP+FN); % Similarity evaluation

GTx = xCorners;
GTy = yCorners;

Euclidean1 = sqrt((Minex(1)-GTx(1))^2+(Miney(1)-GTy(1))^2);
Euclidean2 = sqrt((Minex(2)-GTx(2))^2+(Miney(2)-GTy(2))^2);
Euclidean3 = sqrt((Minex(3)-GTx(3))^2+(Miney(3)-GTy(3))^2);
Euclidean4 = sqrt((Minex(4)-GTx(4))^2+(Miney(4)-GTy(4))^2);

max = max([Euclidean1 Euclidean2 Euclidean3 Euclidean4]);
mean = mean([Euclidean1 Euclidean2 Euclidean3 Euclidean4]);



