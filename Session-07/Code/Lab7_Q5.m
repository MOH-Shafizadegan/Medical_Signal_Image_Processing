clc; clear; close all;

addpath('../Data/')
%%
clc
close all

t1 = imread('../../../Data/Lab7_data/S1_Q5_utils/t1.jpg');
t1 = double(t1(:,:,1));
t1 = (t1 - min(min(t1)))/(max(max(t1))-min(min(t1)));

figure
subplot(2,3,2)
imshow(t1);
title('original image')

fx_p1 = circshift(t1, 1, 2);
fx_m1 = circshift(t1, -1, 2);
dfx = (fx_p1 - fx_m1) / 2;
dfx = (dfx - min(min(dfx)))/(max(max(dfx))-min(min(dfx)));

subplot(2,3,4)
imshow(dfx);
title('df/dx')

fy_p1 = circshift(t1, 1, 1);
fy_m1 = circshift(t1, -1, 1);
dfy = (fy_p1 - fy_m1) / 2;
dfy = (dfy - min(min(dfy)))/(max(max(dfy))-min(min(dfy)));

subplot(2,3,5)
imshow(dfy);
title('df/dy')

grad_f = (dfx .^ 2 + dfy .^ 2) .^ 1/2;

subplot(2,3,6)
imshow(grad_f);
title('abs gradient vector')
