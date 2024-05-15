clc; clear; close all;

addpath('../Data/')

%%
clc; close all
sigma = 0.4;
dims = [64, 64];

f = imread('../../../Data/Lab8_data/S2_Q2_utils/t2.jpg');
f = double(f(:,:,1));
f = (f - min(min(f)))/(max(max(f))-min(min(f)));
f_down = downsample(f, 4);
f_down = downsample(f_down', 4)';

h = Gaussian(sigma, [3,3]);
% h = [0, 1, 0;
%      1, 2, 1;
%      0, 1, 0];
h = h / sum(h, 'all') 

K = zeros(size(f_down));
K(1:3, 1:3) = h;

D = zeros(size(K).^2);

for r = 1:size(K, 1)
    Kp = circshift(K,r-1,1);
    for c = 1:size(K, 1)
        Kz = circshift(Kp,c-1,2);
        D((r-1) * length(K) + c, :) = reshape(Kz, [1, length(K).^2]);
    end
end

g = conv2(f_down, h, 'same');

g_noisy = g + randn(dims) * 0.05;

f_reconst = pinv(D) * reshape(g_noisy, [size(g, 1) * size(g, 2), 1]);


figure();
subplot(1, 4, 1)
imshow(f_down)
title('original image');

subplot(1, 4, 2)
imshow(g)
title('blurred image');

subplot(1, 4, 3)
imshow(g_noisy)
title('blurred-noisy image');

subplot(1, 4, 4)
imshow(reshape(f_reconst, size(g))')
title(strcat('reconstructed noisy image (sigma=', num2str(sigma), ')'));

err = norm(g - reshape(f_reconst, size(g))');
fprintf('reconstruction error= %d \n', err)
