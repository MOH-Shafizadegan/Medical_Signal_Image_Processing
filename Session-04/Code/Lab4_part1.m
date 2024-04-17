clc; clear; close all;

addpath('../Data/')
%% Load data

ERP = load('ERP_EEG.mat').ERP_EEG;
fs = 240;

%% Section 1
clc;

N = 100:100:2500;

figure;
t = (1:size(ERP,1)) / fs - 1/fs;
for n=N
    sig = mean(ERP(:, 1:n), 2);
    subplot(5,5,n/100);
    plot(t, sig)
    xlabel('time')
    ylabel('V(uV)')
    title(strcat('ERP with N = '), num2str(n));
end

%% Section 2

N = 1:2550;
y = [];
for n=N
   sig = mean(ERP(:, 1:n), 2);
   y = [y; max(abs(sig))];
end

figure;
plot(N, y, 'linewidth', 2);
xlabel('n')
ylabel('ERP peak value')
title('ERP peak value vs. N')
xlim([-10 2600])

%% Section 3

clc;

N = 1:2550;
ERPs = [];
for n=N
   sig = mean(ERP(:, 1:n), 2);
   ERPs = [ERPs; sig'];
end
error = diff(ERPs);
ERP_rms = rms(error, 2);

%%
figure;
plot(10*log(ERP_rms), 'linewidth', 2);
xlabel('n')
ylabel('RMS')
title('RMS vs. N')
xlim([-10 2600])
% ylim([-0.5 7])

%% Section 4

N0 = 800;

%% Section 5
clc;

ERP_sig1 = mean(ERP(:, 1:2550), 2);
ERP_sig2 = mean(ERP(:, 1:(N0/3)), 2);
ERP_sig3 = mean(ERP(:, randi(2550, 1, N0)), 2);
ERP_sig4 = mean(ERP(:, randi(2550, 1, round(N0/3))), 2);
t = (1:size(ERP,1)) / fs - 1/fs;

figure;
subplot(2,2,1)
plot(t, ERP_sig1)
xlabel('time(s)')
ylabel('V (uV)')
title('ERP with N = 2550')

subplot(2,2,2)
plot(t, ERP_sig2)
xlabel('time(s)')
ylabel('V (uV)')
title(strcat('ERP with N0 = ', num2str(N0)))

subplot(2,2,3)
plot(t, ERP_sig3)
xlabel('time(s)')
ylabel('V (uV)')
title(strcat('ERP with random N0 = ', num2str(N0), 'trials'))

subplot(2,2,4)
plot(t, ERP_sig4)
xlabel('time(s)')
ylabel('V (uV)')
title(strcat('ERP with random ', num2str(round(N0/3)), 'trials'))

