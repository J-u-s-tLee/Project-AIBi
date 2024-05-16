function [counted_cells, TP, FP, FN, recall, precision, F_measure] = Segmentation_Evaluation(gt_locations, locations)
% Funçao que compara as bounding boxes determinadas pelo código e
% fornecidas pela docente, considerando as últimas como GT.
% Devolve os valores de verdadeiros positivos (TP), falsos positiovs (FP),
% falsos negativos (FN), recall, precision e F_measure


if (~isempty(locations))
    TP = 0; % Inicializar contador de verdadeiros positivos
    counted_cells = length(locations(:,1));

    % Calcular o índice de Jaccard para cada par de objetos nas duas imagens
    for i = 1:length(gt_locations(:,1))
        for j = 1:length(locations(:,1))
            % Obter as coordenadas e dimensões dos retângulos delimitadores
            x1_gt = gt_locations(i, 1);
            y1_gt = gt_locations(i, 2);
            width_gt = gt_locations(i, 3);
            height_gt = gt_locations(i, 4);
            
            x1_x = locations(j, 1);
            y1_x = locations(j, 2);
            width_x = locations(j, 3);
            height_x = locations(j, 4);
            
            % Calcular a interseção e união dos retângulos delimitadores
            x2_gt = x1_gt + width_gt;
            y2_gt = y1_gt + height_gt;
            x2_outro = x1_x + width_x;
            y2_outro = y1_x + height_x;
            
            intersection_x1 = max(x1_gt, x1_x);
            intersection_y1 = max(y1_gt, y1_x);
            intersection_x2 = min(x2_gt, x2_outro);
            intersection_y2 = min(y2_gt, y2_outro);
            
            intersection_area = max(0, intersection_x2 - intersection_x1 + 1) * max(0, intersection_y2 - intersection_y1 + 1);
            area_gt = width_gt * height_gt;
            area_x = width_x * height_x;
            union_area = area_gt + area_x - intersection_area;
            
            jaccard = intersection_area / union_area;
            
            % Se o índice de Jaccard for maior que 0.5, contar como verdadeiro positivo
            if jaccard > 0.5
                TP = TP + 1;
                locations(j, :) = []; % Remover objeto da outra lista para evitar contagem dupla
                break; % Sair do loop interno, pois já encontramos um par correspondente
            end
        end
    end
    
    %Cálculo dos restantes valores
    FP = counted_cells-TP;
    FN = length(gt_locations(:,1))- TP;
    recall = TP / (TP + FN);
    precision = TP / (TP + FP);
    beta = 1;
    if (precision == 0 && recall == 0) %F_measure seria inderteminado
        F_measure = 0; 
    else
        F_measure = ((beta^2+1)*precision*recall)/((beta^2)*precision+recall);
    end
else
    %se não houver células detetadas, considerar todos os valores nulos
    counted_cells=0;
    TP=0;
    FP=0;
    FN=0;
    recall=0;
    precision = 0;
    F_measure = 0;
end
