function [ROI] = MorphologicalFilters(InputImage)

InputImage_gray = im2gray(InputImage);
InputImage_gray_bin = imbinarize(InputImage_gray);
SE = strel('square', 31);
InputImage_close = imclose(InputImage_gray_bin, SE);
SE2 = strel('square', 51);
InputImage_erode = double(imerode(InputImage_close, SE2));
SE3 = strel('square',41);
InputImage_fill = imfill(InputImage_erode,"holes");
ROI= imopen(InputImage_fill,SE3);

end
