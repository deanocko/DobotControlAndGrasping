function ColouredBlobDetection()
clc;
clear;
close all;
imtool close all;
workspace;

% Set the image filepath
image_filepath = 'image_2.jpg';

% Define threshold values
not_mask_top_threshold = 90;
is_mask_bottom_threshold = 160;
eliminate_blob_size = 100;

% Create and setup a new figure
figure;
font_size = 16;
set(gcf, 'Position', get(0, 'ScreenSize'));

% Check if the image exists
if ~exist(image_filepath, 'file')
	message = sprintf('The file could not be found:\n%s ', image_filepath);
	uiwait(msgbox(message));
	return;
end

% Read the image from the filepath.
[rgb_image, ~] = imread(image_filepath);

% Separate the colour bands of the image
red_band = rgb_image(:, :, 1);
green_band = rgb_image(:, :, 2);
blue_band = rgb_image(:, :, 3);

% Show each colour band
subplot(3, 3, 1);
imshow(red_band);
title('Red Band', 'FontSize', font_size);
subplot(3, 3, 2);
imshow(green_band);
title('Green Band', 'FontSize', font_size);
subplot(3, 3, 3);
imshow(blue_band);
title('Blue Band', 'FontSize', font_size);

% Apply colour band masks based on thresholds
not_red_mask = (red_band >= 0) & (red_band <= not_mask_top_threshold);
not_green_mask = (green_band >= 0) & (green_band <= not_mask_top_threshold);
not_blue_mask = (blue_band >= 0) & (blue_band <= not_mask_top_threshold);

red_mask = (red_band >= is_mask_bottom_threshold) & (red_band <= 255);
green_mask = (green_band >= is_mask_bottom_threshold) & (green_band <= 255);
blue_mask = (blue_band >= is_mask_bottom_threshold) & (blue_band <= 255);

% Combine not masks with inclusive masks for increased accuracy
not_red_mask = uint8(not_red_mask | green_mask | blue_mask);
not_green_mask = uint8(not_green_mask | red_mask | blue_mask);
not_blue_mask = uint8(not_blue_mask | red_mask | green_mask);

% Eliminate blobs in the masks smaller than a defined number of pixels
not_red_mask = uint8(bwareaopen(not_red_mask, eliminate_blob_size));
not_green_mask = uint8(bwareaopen(not_green_mask, eliminate_blob_size));
not_blue_mask = uint8(bwareaopen(not_blue_mask, eliminate_blob_size));

% Show the not masks
subplot(3, 3, 4);
imshow(not_red_mask, []);
title('Not Red Mask', 'FontSize', font_size);

subplot(3, 3, 5);
imshow(not_green_mask, []);
title('Not Green Mask', 'FontSize', font_size);

subplot(3, 3, 6);
imshow(not_blue_mask, []);
title('Not Blue Mask', 'FontSize', font_size);

% Calculate and show the inclusive masks
just_red_mask = uint8(not_green_mask & not_blue_mask & not(not_red_mask));
just_red_mask = uint8(bwareaopen(just_red_mask, 200));
subplot(3, 3, 7);
imshow(just_red_mask, []);
caption = sprintf('Mask of Just\nRed Objects');
title(caption, 'FontSize', font_size);

just_green_mask = uint8(not_red_mask & not_blue_mask & not(not_green_mask));
just_green_mask = uint8(bwareaopen(just_green_mask, 200));
subplot(3, 3, 8);
imshow(just_green_mask, []);
caption = sprintf('Mask of Just\nGreen Objects');
title(caption, 'FontSize', font_size);

just_blue_mask = uint8(not_red_mask & not_green_mask & not(not_blue_mask));
just_blue_mask = uint8(bwareaopen(just_blue_mask, 200));
subplot(3, 3, 9);
imshow(just_blue_mask, []);
caption = sprintf('Mask of Just\nBlue Objects');
title(caption, 'FontSize', font_size);

% Create and setup a new figure
figure();
set(gcf, 'Position', get(0, 'ScreenSize'));

% Get the centroids & mean intensity of all red objects
connected_components = bwconncomp(just_red_mask);
blob_properties = regionprops(connected_components, (red_band - blue_band - green_band) .* just_blue_mask, {'MeanIntensity', 'Centroid'});
centroids = [blob_properties.Centroid];
mid_x = centroids(1:2:end-1);
mid_y = centroids(2:2:end);

[~, idx] = max([blob_properties.MeanIntensity]);

red_x = mid_x(idx);
red_y = mid_y(idx);

% Show the original rgb image, highlighting the most red blob
subplot(3, 1, 1);
imshow(red_band);
hold on;
plot(red_x, red_y, 'or')
title('Most Red Object', 'FontSize', font_size)

% Get the centroids & mean intensity of all green objects
connected_components = bwconncomp(just_green_mask);
blob_properties = regionprops(connected_components, (green_band - red_band - blue_band) .* just_blue_mask, {'MeanIntensity', 'Centroid'});
centroids = [blob_properties.Centroid];
mid_x = centroids(1:2:end-1);
mid_y = centroids(2:2:end);

[~, idx] = max([blob_properties.MeanIntensity]);

green_x = mid_x(idx);
green_y = mid_y(idx);

% Show the original rgb image, highlighting the most green blob
subplot(3, 1, 2);
imshow(green_band);
hold on;
plot(green_x, green_y, 'or')
title('Most Green Object', 'FontSize', font_size)

% Get the centroids & mean intensity of all blue objects
connected_components = bwconncomp(just_blue_mask);
blob_properties = regionprops(connected_components, (blue_band - red_band - green_band) .* just_blue_mask, {'MeanIntensity', 'Centroid'});
centroids = [blob_properties.Centroid];
mid_x = centroids(1:2:end-1);
mid_y = centroids(2:2:end);

[~, idx] = max([blob_properties.MeanIntensity]);

blue_x = mid_x(idx);
blue_y = mid_y(idx);

% Show the original rgb image, highlighting the most blue blob
subplot(3, 1, 3);
imshow(blue_band);
hold on;
plot(blue_x, blue_y, 'or');
title('Most Blue Object', 'FontSize', font_size);

return;
