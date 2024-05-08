clc; clear; close all;

addpath('../Data/')
%%
close all
figure
[a,b] = ndgrid(-127:128,-127:128);
G = zeros(256);
G( sqrt(a.^2 + b.^2) < 15) = 1;
subplot(1,3,1)
imshow(G);
title('G')

F  = zeros(256);
F(100,50) = 1;
F(120,48) = 2;
subplot(1,3,2)
imshow(F);
title('F')

fft_G = fft2(G);
fft_F = fft2(F);
fft_Conv = (fft_G.*fft_F);
conv_img = fftshift(ifft2((fft_Conv)));
conv_img = conv_img/max(max(conv_img));
subplot(1,3,3)
imshow(conv_img)
title('convolution of two pics');


%%
clc
close all

pd = imread('../../../Data/Lab7_data/S1_Q2_utils/pd.jpg');
pd_1 = pd(:,:,1);

figure
subplot(1,3,1)
imshow(G);
title('G')

subplot(1,3,2)
imshow(pd_1);
title('pd.jpg, first slice')

fft_pd = fft2(pd_1);
fft_Conv = (fft_G.*fft_pd);
conv_img = fftshift(ifft2((fft_Conv)));
conv_img = conv_img/max(max(conv_img));
subplot(1,3,3)
imshow(conv_img)
title('convolution of two pics');
