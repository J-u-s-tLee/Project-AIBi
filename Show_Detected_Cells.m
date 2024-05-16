function Show_Detected_Cells (Image, Locations)

%Desenhar bounding box na imagem original
if (~isempty(Locations))
    figure;
    imshow(Image);
    hold on;

    for i=1:length(Locations(:,1)) % desenha retângulo para cada célula
        rectangle('Position', [round(Locations(i,1)), round(Locations(i,2)), round(Locations(i,3)), round(Locations(i,4))], 'EdgeColor', 'g', 'LineWidth', 1);  
    end

else
    imshow(Image); %se não forem detetadas células
end
