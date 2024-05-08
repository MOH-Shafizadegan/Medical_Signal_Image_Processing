clc; clear; close all;

addpath('../Data/')
%%
clc
close all

t1 = imread('../../../Data/Lab7_data/S1_Q5_utils/t1.jpg');
t1 = double(t1(:,:,1));
t1 = (t1 - min(min(t1)))/(max(max(t1))-min(min(t1)));

figure
subplot(1,3,1)
imshow(t1);
title('original image')

df_sobel = edge(t1, 'sobel');

subplot(1,3,2)
imshow(df_sobel);
title('sobel edges')

df_canny = edge(t1, 'canny');

subplot(1,3,3)
imshow(df_canny);
title('canny edges')
