clc; clear; close all;

addpath('../Data/')

%% Load data

load('SSVEP_EEG.mat')
fs = 250;
eeg_labels = ["Pz", "Oz", "P7", "P8", "O2", "O1"];

%% Preprocess (section 1)
clc;
EEG_filt = bandpass(SSVEP_Signal', [1 40], fs)';

figure;
t = (1:size(SSVEP_Signal, 2)) /fs - 1/fs;
for i=1:length(eeg_labels)
    subplot(3,2, i)
    plot(t, SSVEP_Signal(i,:)); hold on;
    plot(t, EEG_filt(i,:)); hold off;
    xlabel('time')
    ylabel('V(uV)')
    title(strcat('Electrode-', eeg_labels(i)))
end

%% section 2

clc;
epoched_data = zeros(size(EEG_filt, 1), 5*fs, 15);
for i=1:length(Event_samples)
    epoched_data(:,:,i) = EEG_filt(:, Event_samples(i):Event_samples(i)+5*fs-1);
end

%% Section 3

figure;
labels = ['Pz', 'Oz', 'P7', 'P8', 'O2', 'O1'];
for i=1:15
    subplot(3,5,i)
    for j=1:6
        [p, f] = pwelch(epoched_data(j, :, i), [], [], [], fs);
        plot(f, p); hold on;
    end
    title(strcat('Trial-', num2str(i)))
%     legend('Pz', 'Oz', 'P7', 'P8', 'O2', 'O1')
end

