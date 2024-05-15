function [Image_Out] = Morphological(Image_In)

    Image_gray = im2gray(im2double(Image_In));
    SE1 = strel('disk', 50);
    Image_bothat = imbothat(Image_gray, SE1);
    T = multithresh(Image_bothat, 7);
    Image_thresh = imquantize(Image_bothat, T);
    Image_thresh1 = Image_thresh <= 2;
    Image_Out = imcomplement(Image_thresh1);
end
