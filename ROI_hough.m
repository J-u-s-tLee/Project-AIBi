%aplica o linear hough para detetar as linhas da imagem e assim defenir a
%mascara a utilizar
function mask = ROI_hough (I)

%"processamento" da imagem (ver nome)
Image_gray=im2gray(I);
SE1 = strel('disk', 9); 
Image_bottom = imbothat(Image_gray, SE1);
T = graythresh(Image_bottom);
Image_final = imbinarize(Image_bottom, T);

%deteçao das 4 linhas limitantes
[H, theta, rho] = hough(Image_final);
P = houghpeaks(H,4);
lines = houghlines(Image_final, theta, rho, P);
% figure;
% imshow(Image_gray);
% hold on;
% 
% for k = 1:length(lines)
% xy = [lines(k).point1; lines(k).point2];
% plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'r');
% end
% 
% hold off;
% title('Linhas detetadas pela transformada de Hough');

%criação da máscara
background = Image_bottom;
background(:,:)=0;

for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    background = insertShape(background, 'Line', [xy(1,1) xy(1,2) xy(2,1) xy(2,2)], 'Color', 'white', 'LineWidth', 2);
end

box_gray = im2gray(background);
box_bin = imbinarize(box_gray);
box_filled = imfill(box_bin,'holes');
SE2=strel('disk',3);
mask = imopen(box_filled,SE2);
% figure;
% title('ROI final');
% imshow(mask);

end