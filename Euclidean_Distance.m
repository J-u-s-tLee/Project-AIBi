function [Mean, Max] = Euclidean_Distance(ROI, ROI_GT)

% Label the image.
[labeledImage, ~] = bwlabel(ROI);

% Find the centroid
measurements = regionprops(labeledImage, 'Centroid');

% Put a cross at the centroid.
xCentroid = measurements.Centroid(1);
yCentroid = measurements.Centroid(2);

% Find out how far the centroid is from points in each quadrant
% First get all the points.
[rows, columns] = find(ROI);

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
[labeledImage, ~] = bwlabel(ROI_GT);
% Find the centroid
measurements = regionprops(labeledImage, 'Centroid');
% Put a cross at the centroid.
xCentroid = measurements.Centroid(1);
yCentroid = measurements.Centroid(2);
% Find out how far the centroid is from points in each quadrant
% First get all the points.
[rows, columns] = find(ROI_GT);
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

GTx = xCorners;
GTy = yCorners;

Euclidean1 = sqrt((Minex(1)-GTx(1))^2+(Miney(1)-GTy(1))^2);
Euclidean2 = sqrt((Minex(2)-GTx(2))^2+(Miney(2)-GTy(2))^2);
Euclidean3 = sqrt((Minex(3)-GTx(3))^2+(Miney(3)-GTy(3))^2);
Euclidean4 = sqrt((Minex(4)-GTx(4))^2+(Miney(4)-GTy(4))^2);

Max = max([Euclidean1 Euclidean2 Euclidean3 Euclidean4]);
Mean = mean([Euclidean1 Euclidean2 Euclidean3 Euclidean4]);

end
