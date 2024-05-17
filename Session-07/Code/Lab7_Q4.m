clc; clear; close all;

addpath('../Data/')

%% Load data

img = imread('../Data/S1_Q4_utils/ct.jpg');

%% Viaulization


imshow(img);
title('S1-Q4-utils/ct')

%%

img_slice1 = double(img(:,:,1));
img_fft2 = fftshift(fft2(img_slice1));
[xF,yF] = meshgrid(-127:128,-127:128);

x0 = 20;
y0 = 40;

kernel = exp(-1i*2*pi.*(xF*x0+yF*y0)/256);
shifted_fft2 = img_fft2 .* kernel;
img_shifted = abs(ifft2(ifftshift(shifted_fft2)));
norm_img_shifted = img_shifted / max(max(img_shifted));

figure;
subplot(1,2,1)
imshow(img);
title('Original Image')

subplot(1,2,2)
imshow(norm_img_shifted)
title('Shifted Image')

%%

figure;
subplot(1,2,1)
imshow(abs(kernel))
title('Kernel FFT2 Magnitude')

subplot(1,2,2)
imshow(angle(kernel))
title('Kernel FFT2 Phase')


%% Section 2

img_s1_norm = img_slice1 / max(max(img_slice1));
img_rotated = imrotate(img_s1_norm, 30);

figure;
subplot(1,2,1)
imshow(img_s1_norm)
title('Original Image')

subplot(1,2,2)
imshow(img_rotated)
title('Rotated image with 30^\circ')

%%

figure;
subplot(1,2,1)
img_fft2 = fftshift(fft2(img_s1_norm));
img_fft2_dB = 10*log10(abs(img_fft2));
img_fft2_norm = img_fft2_dB/max(max(abs(img_fft2_dB)));
imshow(abs(img_fft2_norm),[])
title('Original image FFT2 magnitude')


subplot(1,2,2)
img_rotated_fft2 = fftshift(fft2(img_rotated));
img_rotated_fft2_dB = 10*log10(abs(img_rotated_fft2));
img_rotated_fft2_norm = img_rotated_fft2_dB/max(max(abs(img_rotated_fft2_dB)));
imshow(abs(img_rotated_fft2_norm))
title('Rotated image FFT2 magnitude')

%% Freq rotation

img_fft2  = fftshift(fft2(ifftshift(img_s1_norm)));
rot_img_fft2 = imrotate(img_fft2, 30);
rot_img = abs(fftshift(ifft2(ifftshift(rot_img_fft2))));
norm_img_rot = rot_img / max(max(rot_img));

figure;

imshow(norm_img_rot)
title('Rotated image')
