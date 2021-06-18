%% Loading the CT scan
clear all
load('C:\Users\lenovo\Downloads\mouse_ct.mat');
%% Filtering the stack to remove the background
sigma = 1;
image = imgaussfilt3(img, sigma);

figure(1)
colormap gray
subplot(221)
title('Original Slice')
imagesc(img(:,:,150))
subplot(222)
title('Filtered Slice')
imagesc(image(:,:,150))
subplot(223)
title('Identifying ROI')
imagesc(image(:,:,150))
h = drawcircle('Center',[146,146],'Radius',114,'StripeColor','red');

mask = createMask(h);
mask = double(mask);
mask1 = 1-mask;

subplot(224)
title('Mask')
imagesc(mask1);
%% thresholding to capture the area representing lung vol
v_thresh = image<90 & image>1;
v_thresh = double(v_thresh);
%% Applying the mask on the thresholded volume
vol = zeros(308,308,786);
for i = 1:size(img,3)
    J = regionfill(v_thresh(:,:,i),mask1);
    vol(:,:,i) = J;
end
%% Filling holes inside the lung area
vol_filled = zeros(size(img));
for i = 1:size(img,3)
    bwfilled =  imfill(vol(:,:,i),8, 'holes'); % filling holes in the area representing lung vol
    vol_filled(:,:,i) = bwfilled;
end

%% Morphological erosion to smoothen edges
SE = strel('sphere',3);
BW = imopen(vol_filled,SE);

%%
figure(2)
clf
colormap gray
subplot(221)
title('Original Binary')
imagesc(vol(:,:,160))
subplot(222)
title('Holes Filled')
imagesc(vol_filled(:,:,160))
subplot(223)
title('Edges smoothened')
imagesc(BW(:,:,160))

%% Displaying the different sections
image = reshape(img,[308 308 262 3]);
bw = reshape(BW,[308 308 262 3]);
figure(3)
colormap gray
title('Set 1 Original')
subplot(232)
title('Set 2 Original')
subplot(233)
title('Set 3 Original')
subplot(234)
title('Set 1 Processed')
subplot(235)
title('Set 2 Processed')
subplot(236)
title('Set 3 Processed')
for j = 1:3
    for k = 1:size(img,3)/3
        subplot(2,3,j)
        imagesc(image(:,:,k,j)); drawnow;
        subplot(2,3,j+3)
        imagesc(bw(:,:,k,j)); drawnow;
    end
end
%% Computing Lung Volume in Voxels
% Set 1 volume
for ii = 1:3
    L(:,:,:,ii) = bwlabeln(bw(:,:,:,ii));
    zeros = L(:,:,:,ii)==0;
    total_zeros(:,ii) = sum(zeros(:));
    ones = L(:,:,:,ii)==1;
    total_ones(:,ii) = sum(ones(:));
    total_voxels(:,ii) = total_zeros(:,ii) +total_ones(:,ii);
end
%%
disp('Total Voxels in set 1')
disp(total_voxels(1))
disp('No. of voxels representing lung volume out of total voxels')
disp(total_zeros(1))
disp('Total Voxels in set 2')
disp(total_voxels(2))
disp('No. of voxels representing lung volume out of total voxels')
disp(total_zeros(2))
disp('Total Voxels in set 3')
disp(total_voxels(3))
disp('No. of voxels representing lung volume out of total voxels')
disp(total_zeros(3))

