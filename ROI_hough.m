%aplica o linear hough para detetar as linhas da imagem e assim defenir a
%mascara a utilizar
function [mask, right_limit, bottom_limit] = ROI_hough (I)

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
[m,n] = size(Image_bottom);
background = zeros(m,n);

figure;
imshow(background);
hold on;

for k = 1:length(lines)
xy = [lines(k).point1; lines(k).point2];
plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color','white');
end

hold off;
frame = getframe;
box_inicial = frame.cdata;

box_gray = im2gray(box_inicial);
box_bin = imbinarize(box_gray);
box_filled = imfill(box_bin,'holes');
SE2=strel('disk',3);
mask = imopen(box_filled,SE2);
% figure;
% title('ROI final');
% imshow(mask);

count_x=1;
count_y=1;
for n = 1:length(lines)
    if (lines(n).point1(1)==lines(n).point2(1))
        x_values(count_x) = lines(n).point1(1);
        count_x=count_x+1;
    elseif(lines(n).point1(2)==lines(n).point2(2))
        y_values(count_y) = lines(n).point1(2);
        count_y=count_y+1;
    end
end

right_limit = max(x_values);
bottom_limit = min(y_values);
end