function show_detected_cells (Image, mask, locations)
Image = im2gray(Image);
Image(~mask)=0;
%Desenhar bounding box na imagem original
if (~isempty(locations))
    figure;
    imshow(Image);
    hold on;

    for i=1:length(locations(:,1)) %desenha retângulo para cada célula
        rectangle('Position', [locations(i,1), locations(i,2), locations(i,3),locations(i,4)], 'EdgeColor', 'g', 'LineWidth', 2);  
    end

    hold off;
else
    figure;
    imshow(Image); %se não forem detetadas células
end