function [TP, FP, FN, recall, precision, F_measure] = segmentation_evaluation(gt_locations, locations)
if (~isempty(locations))
    TP = 0; % Inicializar contador de verdadeiros positivos
    positives = length(locations(:,1));
    % Calcular o índice de Jaccard para cada par de objetos nas duas imagens
    for i = 1:length(gt_locations(:,1))
        for j = 1:length(locations(:,1))
            % Obter as coordenadas dos retângulos delimitadores
            x1_gt = gt_locations(i, 1);
            y1_gt = gt_locations(i, 2);
            width_gt = gt_locations(i, 3);
            height_gt = gt_locations(i, 4);
            
            x1_outro = locations(j, 1);
            y1_outro = locations(j, 2);
            width_outro = locations(j, 3);
            height_outro = locations(j, 4);
            
            % Calcular a interseção e união dos retângulos delimitadores
            x2_gt = x1_gt + width_gt;
            y2_gt = y1_gt + height_gt;
            x2_outro = x1_outro + width_outro;
            y2_outro = y1_outro + height_outro;
            
            intersecao_x1 = max(x1_gt, x1_outro);
            intersecao_y1 = max(y1_gt, y1_outro);
            intersecao_x2 = min(x2_gt, x2_outro);
            intersecao_y2 = min(y2_gt, y2_outro);
            
            intersecao_area = max(0, intersecao_x2 - intersecao_x1 + 1) * max(0, intersecao_y2 - intersecao_y1 + 1);
            area_gt = width_gt * height_gt;
            area_outro = width_outro * height_outro;
            uniao_area = area_gt + area_outro - intersecao_area;
            
            jaccard = intersecao_area / uniao_area;
            
            % Se o índice de Jaccard for maior que 0.5, contar como verdadeiro positivo
            if jaccard > 0.5
                TP = TP + 1;
                locations(j, :) = [];% Remover objeto da outra lista para evitar contagem dupla
                break; % Sair do loop interno, pois já encontramos um par correspondente
            end
        end
    end
    
    FP = positives-TP;
    FN = length(gt_locations(:,1))- TP;
    recall = TP / (TP + FN);
    precision = TP / (TP + FP);
    beta = 1;
    F_measure = ((beta^2+1)*precision*recall)/((beta^2)*precision+recall);
else
    TP=0;
    FP=0;
    FN=0;
    recall=0;
    precision = 0;
    F_measure = 0;
end