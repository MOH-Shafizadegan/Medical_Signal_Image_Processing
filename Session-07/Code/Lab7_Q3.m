clc; clear; close all;

addpath('../Data/')
%%
close all

image = imread('../../../Data/Lab7_data/S1_Q3_utils/ct.jpg');
image_gray = image(:,:,1);
figure
subplot(1,2,1)
imshow(image_gray);
title('original image')

fft_image = fftshift(fft2(image_gray));

% Perform zero-padding
pad_size = 128;
padded_image = padarray(fft_image, [pad_size, pad_size]);

zoomed_image = ifft2(ifftshift(padded_image));

% Crop the image to the original image size
zoomed_image = abs(zoomed_image);
zoomed_image_croped = zoomed_image(pad_size+1:end-pad_size,pad_size+1:end-pad_size); 

subplot(1,2,2)
imshow(zoomed_image_croped, []);
title('zoomed image')
