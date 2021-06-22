image = imread('pout.tif');
colormap gray
subplot(221)
imagesc(image)

subplot(222)
imhist(image)
%%
image = double(image)/255;
[Nx,Ny] = size(image);
bins = 0:0.01:1;
h = hist(image(:),bins);
subplot(223)
bar(bins,h)
subplot(224)
bar(bins,cumsum(h)/sum(h))
%% equalization
f1 = cumsum(h)/sum(h);
imgeql = interp1(bins,f1,image);
figure(2)
colormap gray
subplot(221)
imagesc(image)
title('Original')
subplot(222)
imagesc(imgeql)
title('Equalized')
subplot(223)
imhist(image)
subplot(224)
imhist(imgeql)
%% local equalization
patch1 = image(1:145,1:120);
patch2 = image(146:291,1:120);
patch3 = image(1:145,121:240);
patch4 = image(146:291,121:240);
h1 = hist(patch1(:),bins);
h2 = hist(patch2(:),bins);
h3 = hist(patch3(:),bins);
h4 = hist(patch4(:),bins);
f1 = cumsum(h1)/sum(h1);
f2 = cumsum(h2)/sum(h2);
f3 = cumsum(h3)/sum(h3);
f4 = cumsum(h4)/sum(h4);
imgeq1 = interp1(bins,f1,patch1);
imgeq2 = interp1(bins,f2,patch2);
imgeq3 = interp1(bins,f3,patch3);
imgeq4 = interp1(bins,f4,patch4);
%% stiching the four patches
img4 = zeros(291,240);
img4(1:145,1:120) = imgeq1(1:145,1:120);
img4(146:291,1:120) = imgeq2(1:146,1:120);
img4(1:145,121:240) = imgeq3(1:145,1:120);
img4(146:291,121:240) = imgeq4(1:146,1:120);
figure(3)
colormap gray
imagesc(img4)
title('Histogram Equal x4')

%% interp3 local equalization
img = imread('pout.tif');
img = double(img);
z1 = [0:255]';
patch_1 = img(1:145, 1:120);
f(1,1,:) = cumsum(hist(patch_1(:),z1));
patch_2 = img(146:291,1:120);
f(1,2,:) = cumsum(hist(patch_2(:),z1));
patch_3 = img(1:145,121:240);
f(2,1,:) = cumsum(hist(patch_3(:),z1));
patch_4 = img(146:291,121:240);
f(2,2,:) = cumsum(hist(patch_4(:),z1));
[X,Y,Z] = meshgrid([1 291],[1 240],z1);
[Xq,Yq] = meshgrid(1:240,1:291);
img_new = interp3(X,Y,Z,f,Xq,Yq,img);
figure(4)
colormap gray
subplot(221)
imagesc(img)
title('Original Image')
subplot(222)
imagesc(imgeql);
title('Equalized Image')
subplot(223)
imagesc(img4)
title('Histogram Equalization 4 titles')
subplot(224)
imagesc(img_new)
title('Locally Equalized Image')
ylim([0 240])


