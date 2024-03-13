clc; clear; close all;

addpath('../Data/Lab3_data/data')
addpath('../Data/Lab3_data/matlab')

%% Load data

mecg = load('mecg1.dat');
fecg = load('fecg1.dat');
noise = load('noise1.dat');

fs = 256;

sig = mecg + fecg + noise;

%% Section 1

t = (1:length(sig))/fs;

figure;
subplot(4,1,1)
plot(t, mecg)
title('ECG of mother')
ylim([-10 10])

subplot(4,1,2)
plot(t, fecg)
title('ECG of fetus')
ylim([-10 10])

subplot(4,1,3)
plot(t, noise)
title('Noise')
ylim([-10 10])

subplot(4,1,4)
plot(t, sig)
title('Mixed signal')
ylim([-10 10])

%% Section 2 Spectrom

figure;
subplot(2,2,1)
[p, f] = pwelch(mecg, [], [], [], fs);
plot(f,p);
title('ECG of mother')
xlabel('freq (Hz)')
% ylim([-10 10])

subplot(2,2,2)
[p, f] = pwelch(fecg, [], [], [], fs);
plot(f,p);
title('ECG of fetus')
xlabel('freq (Hz)')
% ylim([-10 10])

subplot(2,2,3)
[p, f] = pwelch(noise, [], [], [], fs);
plot(f,p);
title('Noise')
xlabel('freq (Hz)')
% ylim([-10 10])

subplot(2,2,4)
[p, f] = pwelch(sig, [], [], [], fs);
plot(f,p);
title('Mixed signal')
xlabel('freq (Hz)')
% ylim([-10 10])

%% Var and Mean
clc;

mecg_avg = mean(mecg)
mecg_var = var(mecg, 1)

fecg_avg = mean(fecg)
fecg_var = var(fecg, 1)

noise_avg = mean(noise)
noise_var = var(noise, 1)

%% Histogram

n_bins = 200;
x_range = [-5 5];

figure;
subplot(3,1,1)
histogram(mecg, n_bins)
xlim(x_range)
title('ECG of mother')

subplot(3,1,2)
histogram(fecg, n_bins)
xlim(x_range)
title('ECG of fetus')

subplot(3,1,3)
histogram(noise, n_bins)
xlim(x_range)
title('Noise')

%% kurtosis
clc;

k_mecg = kurtosis(mecg)
k_fecg = kurtosis(fecg)
k_noise = kurtosis(noise)
