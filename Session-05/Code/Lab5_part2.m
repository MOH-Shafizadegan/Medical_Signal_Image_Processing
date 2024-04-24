clc; clear; close all;

addpath('../Data/Lab 5_data/')

%% Load data

data = load('Lab 5_data\n_422.mat').n_422;
fs = 256;

normal_1_n422 = data(1:10710);
abnormal_1_n422 = data(10711:11210);
normal_2_n422 = data(11211:11442); 
abnormal_2_n422 = data(11442:59710); 
abnormal_3_n422 = data(61288:end);

%% Pwelch

[p_n_1, f_n_1] = pwelch(normal_1_n422, [], [], [], fs);
[p_n_2, f_n_2] = pwelch(normal_2_n422, [], [], [], fs);
[p_ab_1, f_ab_1] = pwelch(abnormal_1_n422, [], [], [], fs);
[p_ab_2, f_ab_2] = pwelch(abnormal_2_n422, [], [], [], fs);

% visualization

figure;
subplot(2,2,1)
plot(f_n_1, 10*log(p_n_1))
title('Normal data 1')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

subplot(2,2,2)
plot(f_n_2, 10*log(p_n_2))
title('Normal data 2')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

subplot(2,2,3)
plot(f_ab_1, 10*log(p_ab_1))
title('Abnormal data 1')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

subplot(2,2,4)
plot(f_ab_2, 10*log(p_ab_2))
title('Abnormal data 2')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

%% Time plot (Section b)

figure;
subplot(2,2,1)
t = (1:size(normal_1_n422,1)) / fs - 1/fs;
plot(t, normal_1_n422)
title('Normal 1')
xlabel('time (s)')
ylabel('amplitude (v)')

subplot(2,2,2)
t = (1:size(normal_2_n422,1)) / fs - 1/fs;
plot(t, normal_2_n422)
title('Normal 2')
xlabel('time (s)')
ylabel('amplitude (v)')

subplot(2,2,3)
t = (1:size(abnormal_1_n422,1)) / fs - 1/fs;
plot(t, abnormal_1_n422)
title('Abnormal 1')
xlabel('time (s)')
ylabel('amplitude (v)')

subplot(2,2,4)
t = (1:size(abnormal_2_n422,1)) / fs - 1/fs;
plot(t, abnormal_2_n422)
title('Abnormal 2')
xlabel('time (s)')
ylabel('amplitude (v)')

%% Section (c) Labeling
clc;

data = load('Lab 5_data\n_422.mat').n_422;
window_length = 10 * fs;
overlap = 5 * fs;

start_idx = 1:overlap:length(data)-window_length;
epoch_data = zeros(length(start_idx), 10*fs);
labels = zeros(length(start_idx), 1);
for i = 1:length(start_idx)
    end_idx = start_idx(i)+window_length-1;
    epoch_data(i, :) = data(start_idx(i):end_idx);
    
    if end_idx<=10711
        labels(i)=1 ;%normal
    elseif start_idx(i)>10711 &&  end_idx<=11211
        labels(i)=3 ;%VT
    elseif start_idx(i)>11211 &&  end_idx<=11442
        labels(i)=1 ;%normal
    elseif start_idx(i)>11442 &&  end_idx<=59711
        labels(i)=3 ;%VT
    elseif start_idx(i)>59711 &&  end_idx<=61288
        labels(i)=4 ;%noise
    elseif start_idx(i)>=61288
        labels(i)=2 ;%VFIB
    else
        labels(i)=0 ;%None
    end
end

%% Section d: Frequency Features

n_features = 5; % mean_freq, med_freq, bandpower(0, 20), bandpower(20, 40)
features = zeros(length(start_idx), 5);
band1 = [0 40];
band2 = [40 80];
band3 = [80 120];

for i = 1:length(start_idx)
    sig = epoch_data(i, :);
    features(i, 1) = meanfreq(sig, fs);
    features(i, 2) = medfreq(sig, fs);
    features(i, 3) = bandpower(sig, fs, band1);
    features(i, 4) = bandpower(sig, fs, band2);
    features(i, 5) = bandpower(sig, fs, band3);
end

%% Section e

feature_label = ["meanfreq", "medfreq", "band 0-40", "bandpower 40-80", "band 80-120"];
figure;
for i=1:n_features
    subplot(3,2,i)
    normal_data = features(labels == 1, i);
    histogram(normal_data, 10); hold on;
    VFIB_data = features(labels == 2, i);
    histogram(VFIB_data, 10); hold on;
    title(feature_label(i))
end

% result: medfreq and band 40-80 selected

%% section f

[alarm_medfreq ,t1] = va_detect(data,fs, "medfreq");
[alarm_bandpower4080 ,t2] = va_detect(data,fs, "bandpower40");

%% Confusion
clc;

[c,cm,ind,per] = confusion(labels == 2, alarm_medfreq);

%% Section g: demographic Features

n_features_demog = 6; % max, min, peaktopeak, findpeaks, zeros, var
features_demog = zeros(length(start_idx), 5);

for i = 1:length(start_idx)
    sig = epoch_data(i, :);
    features_demog(i, 1) = max(sig);
    features_demog(i, 2) = min(sig);
    features_demog(i, 3) = max(sig) - min(sig);
    features_demog(i, 4) = mean(findpeaks(sig));
    features_demog(i, 5) = sum(sig == 0);
    features_demog(i, 6) = var(sig);
end

%% Section e

feature_label = ["max", "min", "peak to peak", "R peaks avg", "zeros", "var"];
figure;
for i=1:n_features_demog
    subplot(3,2,i)
    normal_data = features_demog(labels == 1, i);
    histogram(normal_data, 10); hold on;
    VFIB_data = features_demog(labels == 2, i);
    histogram(VFIB_data, 10); hold on;
    title(feature_label(i))
end

% result: medfreq and band 40-80 selected
