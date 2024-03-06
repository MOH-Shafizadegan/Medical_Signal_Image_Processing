clc; clear; close all;

%% load data
X_org = load('X_org.mat');
X_org = X_org.X_org;
X_noise = load('X_noise.mat');
X_noise = X_noise.X_noise;

%% Section 1
plotEEG(X_org)
title('Original signal');

%% Section 2
plotEEG(X_noise)
title('Noise signal');

%% Section 3
SNR = -5;
P_s = mean(mean(X_org.^2));
P_N = mean(mean(X_noise.^2));

sigma = sqrt((P_s/P_N) * 10^(-SNR/10));
x_noisy_5 = X_org + sigma .* X_noise;


SNR = -15;
P_s = mean(mean(X_org.^2));
P_N = mean(mean(X_noise.^2));

sigma = sqrt((P_s/P_N) * 10^(-SNR/10));
x_noisy_15 = X_org + sigma .* X_noise;

plotEEG(x_noisy_5)
title('Signal with -5 db noise');

plotEEG(x_noisy_15)
title('Signal with -15 db noise');

%% Section 4: ICA
clc; close all;

[F_5,W_5,~] = COM2R(x_noisy_5,32);
source_ICA_5 = W_5*x_noisy_5;

[F_15,W_15,~] = COM2R(x_noisy_15,32);
source_ICA_15 = W_15*x_noisy_15;

plotSENSOR(source_ICA_5)
title('ICA with SNR = -5');

plotSENSOR(source_ICA_15)
title('ICA with SNR = -15');

%% Section 5: Select Spikey Sources

spikey_sources_idx_5 = [2 5 9 10 11 12 15 18 21 23 26 28 30 32];
spikey_sources_5 = source_ICA_5(spikey_sources_idx_5, :);

spikey_sources_idx_15 = [2 5 9 10 11 12 15 18 21 23 26 28 30 32];
spikey_sources_15 = source_ICA_15(spikey_sources_idx_15, :);

%% Section 6
X_den_5 = F_5(:,spikey_sources_idx_5)*source_ICA_5(spikey_sources_idx_5,:);
plotEEG(X_den_5);
title('denoised -5 SNR signal with ica');

X_den_15 = F_15(:,spikey_sources_idx_15)*source_ICA_15(spikey_sources_idx_15,:);
plotEEG(X_den_15);
title('denoised -15 SNR signal with ica');

%% Section 7
clc; close all;
ch_id = [13, 24];
for i = 1:length(ch_id)
    figure()
    subplot(3,1,1)
    plot(X_den_5(ch_id(i), :))
    title(strcat('denoised -5 SNR signal with ica, Channel-', num2str(ch_id(i))))

    subplot(3,1,2)
    plot(X_org(ch_id(i), :))
    title(strcat('Original signal, Channel-', num2str(ch_id(i))));

    subplot(3,1,3)
    plot(X_noise(ch_id(i), :))
    title(strcat('Noise signal, Channel-', num2str(ch_id(i))));
end

for i = 1:length(ch_id)
    figure()
    subplot(3,1,1)
    plot(X_den_15(ch_id(i), :))
    title(strcat('denoised -15 SNR signal with ica, Channel-', num2str(ch_id(i))))

    subplot(3,1,2)
    plot(X_org(ch_id(i), :))
    title(strcat('Original signal, Channel-', num2str(ch_id(i))));

    subplot(3,1,3)
    plot(X_noise(ch_id(i), :))
    title(strcat('Noise signal, Channel-', num2str(ch_id(i))));
end

%% Section 8: RRMSE
clc
RRMSE_ica(1) = RRMSE(X_org,X_den_5);
RRMSE_ica(2) = RRMSE(X_org,X_den_15);

fprintf('RRMSE_ica for SNR=-5dB : %f\n', RRMSE_ica(1))
fprintf('RRMSE_ica for SNR=-15dB: %f\n', RRMSE_ica(2))

%% funcitons

function plotSENSOR(X) 
% Plot Data
% Use function disp_eeg(X,offset,feq,ElecName)
offset = max(abs(X(:)));
freq = 250;
ElecName = {};
for i = 1:32
    ElecName{i} = strcat('s', num2str(i));
end
disp_eeg(X,offset,freq,ElecName);
end

function out = RRMSE(X_org,X_den)
    out = sqrt(sum(sum((X_org-X_den).^2))/(sum(sum((X_org.^2)))));
end






