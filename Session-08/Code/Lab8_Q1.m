clc; clear; close all;

addpath('../Data/')

%% Load data

img = imread('../Data/S2_Q1_utils/t2.jpg');

img_1 = double(img(:,:,1));
var = 15^2;
noise = sqrt(var) * randn(size(img_1));
noisy_img1 = img_1 + noise;

%% Kernel

kernel = zeros(size(img_1));
[x_len, y_len] = size(img_1);
kernel(x_len/2 - 2:x_len/2 + 2, y_len/2 - 2:y_len/2 + 2) = 1;
kernel = kernel /sum(kernel, 'all');

f_kernel = fft2(kernel);
f_noisy_img_1 = fft2(noisy_img1);

res_f_img = f_noisy_img_1 .* f_kernel;

recons_img = ifftshift(ifft2(res_f_img));

%% Visualization

figure;
subplot(2,2,1)
imshow(img_1/max(max(img_1)))
title('Original Img')

subplot(2,2,2)
imshow(noisy_img1/max(max(noisy_img1)))
title('Noisy Img')

subplot(2,2,3)
imshow(recons_img/max(max(recons_img)))
title('Filtered Img')

subplot(2,2,4)
conv_img = imgaussfilt(img_1, 1);
imshow(conv_img/max(max(conv_img)))
title('Conv Img')