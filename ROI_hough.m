function Mask = ROI_Hough(Image)

    I = im2double(Image);
    Image_gray = im2gray(I);
    SE1 = strel('disk', 9); 
    Image_bottom = imbothat(Image_gray, SE1);
    T = graythresh(Image_bottom);
    Image_final = imbinarize(Image_bottom, T);
    
    [H, theta, rho] = hough(Image_final);
    P = houghpeaks(H,4);
    lines = houghlines(Image_final, theta, rho, P);
    
    [m,n] = size(Image_bottom);
    Background = zeros(m,n);
    
    for k = 1:length(lines)
        for i = lines(k).point1(2):lines(k).point2(2)
            for j = lines(k).point1(1):lines(k).point2(1)
                Background(i,j) = 1;
            end
        end
    end
    
    SE2 = strel('square', 200); 
    Background_close = imclose(Background, SE2);
    Background_fill = imfill(Background_close, 'holes');
    SE3 = strel('square', 2); 
    Mask = imopen(Background_fill, SE3);

end
