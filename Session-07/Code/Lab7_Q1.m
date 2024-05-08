clc; clear; close all;

addpath('../Data/')

%% Load data

img = imread('../Data/S1_Q1_utils/t1.jpg');

%% Viaulization


imshow(img);
title('S1-Q1-utils/t1')

%% 1D FFT

img_slice1 = img(:,:,1);

img_row_128 = img_slice1(128, :);
img_row_128_fft = fftshift(fft(img_row_128, 128));

figure();
subplot(2,1,1);
f = linspace(-pi,pi,length(img_row_128_fft));
plot(f,abs(img_row_128_fft), 'linewidth', 2);
title('Magnitude');
xlabel('frequency');

subplot(2,1,2);
plot(f,(angle(img_row_128_fft)));
title('Phase');
xlabel('frequency');

%% FFT2

img_s1_d = img_slice1;
img_fft2 = fftshift(fft2(img_s1_d));

figure;
subplot(1,2,1)
imshow(img_s1_d)
title('Original Image')

subplot(1,2,2)
fft2_dB = 10*log10(abs(img_fft2));
fft2_dB = fft2_dB/max(max(abs(fft2_dB)));
imshow(fft2_dB)
title('log(Magnitude)')
