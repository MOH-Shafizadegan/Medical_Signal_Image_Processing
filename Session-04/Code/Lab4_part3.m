clc; clear; close all;

addpath('../Data/')

%% Load data

load('FiveClass_EEG.mat')
fs = 256;

labels = ['AFz', 'F7', 'F3', 'Fz', 'F4', 'F8', 'FC3', 'FCz', 'FC4', 'T3',...
    'C3', 'Cz', 'C4', 'T4', 'CP3', 'CPz', 'CP4', 'P7', 'P5', 'P3', 'P1', ...
    'Pz', 'P2', 'P4', 'P6', 'P8', 'PO3', 'PO4', 'O1', 'O2'];

%% Section 1

eeg_delta = bandpass(X, [1 4], fs);
eeg_theta = bandpass(X, [4 8], fs);
eeg_alpha = bandpass(X, [8 13], fs);
eeg_beta = bandpass(X, [13 30], fs);

%%
clc;

figure;
t = (1:5*fs) /fs - 1/fs;
subplot(3,2,[1 2])
plot(t, X(1:5*fs,1))
title('X - channel 1')
xlabel('time(s)')

subplot(3,2,3)
plot(t, eeg_delta(1:5*fs,1))
title('X - channel 1 - delta')
xlabel('time(s)')

subplot(3,2,4)
plot(t, eeg_theta(1:5*fs,1))
title('X - channel 1 - theta')
xlabel('time(s)')

subplot(3,2,5)
plot(t, eeg_alpha(1:5*fs,1))
title('X - channel 1 - alpha')
xlabel('time(s)')

subplot(3,2,6)
plot(t, eeg_beta(1:5*fs,1))
title('X - channel 1 - beta')
xlabel('time(s)')

%% Section 2
clc;

eeg_delta_epoch = zeros(10*fs, size(X,2), 200);
for i=1:200
    eeg_delta_epoch(:,:,i) = eeg_delta(trial(i): trial(i)+256*10-1,:);
end

eeg_theta_epoch = zeros(10*fs, size(X,2), 200);
for i=1:200
    eeg_theta_epoch(:,:,i) = eeg_theta(trial(i): trial(i)+256*10-1,:);
end

eeg_alpha_epoch = zeros(10*fs, size(X,2), 200);
for i=1:200
    eeg_alpha_epoch(:,:,i) = eeg_alpha(trial(i): trial(i)+256*10-1,:);
end

eeg_beta_epoch = zeros(10*fs, size(X,2), 200);
for i=1:200
    eeg_beta_epoch(:,:,i) = eeg_beta(trial(i): trial(i)+256*10-1,:);
end

%% Section 3-4
clc;

delta_X_avg = zeros(2560, 30, 5);
for label=1:5
    idx = find(y == label);
    delta_X_avg(:,:,label) = rms(eeg_delta_epoch(:,:,idx), 3);
end

theta_X_avg = zeros(2560, 30, 5);
for label=1:5
    idx = find(y == label);
    theta_X_avg(:,:,label) = rms(eeg_theta_epoch(:,:,idx), 3);
end

alpha_X_avg = zeros(2560, 30, 5);
for label=1:5
    idx = find(y == label);
    alpha_X_avg(:,:,label) = rms(eeg_alpha_epoch(:,:,idx), 3);
end

beta_X_avg = zeros(2560, 30, 5);
for label=1:5
    idx = find(y == label);
    beta_X_avg(:,:,label) = rms(eeg_beta_epoch(:,:,idx), 3);
end
 
%% Section 5

window = ones(1,200)/sqrt(200);
delta_X_avg_smth = zeros(2560, 30, 5);
for i=1:5
    for j=1:30
        delta_X_avg_smth(:,j,i) = conv(delta_X_avg(:,j,i), window, 'same');
    end
end

theta_X_avg_smth = zeros(2560, 30, 5);
for i=1:5
    for j=1:30
        theta_X_avg_smth(:,j,i) = conv(theta_X_avg(:,j,i), window, 'same');
    end
end

alpha_X_avg_smth = zeros(2560, 30, 5);
for i=1:5
    for j=1:30
        alpha_X_avg_smth(:,j,i) = conv(alpha_X_avg(:,j,i), window, 'same');
    end
end

beta_X_avg_smth = zeros(2560, 30, 5);
for i=1:5
    for j=1:30
        beta_X_avg_smth(:,j,i) = conv(beta_X_avg(:,j,i), window, 'same');
    end
end

%% Section 6

