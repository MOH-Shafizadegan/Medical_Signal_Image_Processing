clc; clear; close all;

addpath('../Data/')

%%
clc; close all
sigma = 0.6;
dims = [256, 256];

f = imread('../../../Data/Lab8_data/S2_Q2_utils/t2.jpg');
f = double(f(:,:,1));
f = (f - min(min(f)))/(max(max(f))-min(min(f)));

h = Gaussian(sigma, dims);

g = conv2(f, h, 'same');

G = fft2(g);
H = fft2(h);
F = (G./H);

f2 = fftshift(ifft2((F)));

figure();
subplot(1, 3 , 1)
imshow(f)
title('original image');

subplot(1, 3 , 2)
imshow(g)
title('blurred image');

subplot(1, 3 , 3)
imshow(f2)
title(strcat('reconstructed image (sigma=', num2str(sigma), ')'));

%%
clc; close all;

g_noisy = g + randn(dims) * sqrt(0.001);

G_N = fft2(g_noisy);
F_N = (G_N./H);

f2_N = fftshift(ifft2((F_N)));

figure();
subplot(1, 3, 1)
imshow(f)
title('original image');

subplot(1, 3, 2)
imshow(g_noisy)
title('blurred-noisy image');

subplot(1, 3, 3)
imshow(f2_N)
title(strcat('reconstructed noisy image (sigma=', num2str(sigma), ')'));
