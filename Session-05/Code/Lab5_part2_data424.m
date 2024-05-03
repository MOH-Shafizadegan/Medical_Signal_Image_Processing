clc; clear; close all;

addpath('../Data/Lab 5_data/')

%% Load data

data = load('Lab 5_data\n_424.mat').n_424;
fs = 256;

normal_1_n424 = data(1:27248);
abnormal_1_n424 = data(27249:53673);
abnormal_2_n424 = data(53674:55134); 
abnormal_3_n424 = data(55135:end);

%% Pwelch

[p_n_1, f_n_1] = pwelch(normal_1_n424, [], [], [], fs);
[p_ab_1, f_ab_1] = pwelch(abnormal_1_n424, [], [], [], fs);
[p_ab_2, f_ab_2] = pwelch(abnormal_2_n424, [], [], [], fs);
[p_ab_3, f_ab_3] = pwelch(abnormal_3_n424, [], [], [], fs);

% visualization

figure;
subplot(2,2,1)
plot(f_n_1, 10*log(p_n_1))
title('Normal data 1')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

subplot(2,2,2)
plot(f_ab_1, 10*log(p_ab_1))
title('Abnormal data 2')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

subplot(2,2,3)
plot(f_ab_2, 10*log(p_ab_2))
title('Abnormal data 2')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

subplot(2,2,4)
plot(f_ab_3, 10*log(p_ab_3))
title('Abnormal data 3')
xlabel('frequency (Hz)')
ylabel('power (dB)')
ylim([-60 100])

%% Time plot (Section b)

figure;
subplot(2,2,1)
t = (1:size(normal_1_n424,1)) / fs - 1/fs;
plot(t, normal_1_n424)
title('Normal 1')
xlabel('time (s)')
ylabel('amplitude (v)')

subplot(2,2,2)
t = (1:size(abnormal_1_n424,1)) / fs - 1/fs;
plot(t, abnormal_1_n424)
title('Abnormal 1')
xlabel('time (s)')
ylabel('amplitude (v)')

subplot(2,2,3)
t = (1:size(abnormal_2_n424,1)) / fs - 1/fs;
plot(t, abnormal_2_n424)
title('Abnormal 2')
xlabel('time (s)')
ylabel('amplitude (v)')

subplot(2,2,4)
t = (1:size(abnormal_3_n424,1)) / fs - 1/fs;
plot(t, abnormal_3_n424)
title('Abnormal 3')
xlabel('time (s)')
ylabel('amplitude (v)')

%% Section (c) Labeling
clc;

data = load('Lab 5_data\n_424.mat').n_424;
window_length = 10 * fs;
overlap = 5 * fs;

start_idx = 1:overlap:length(data)-window_length;
epoch_data = zeros(length(start_idx), 10*fs);
labels = zeros(length(start_idx), 1);
for i = 1:length(start_idx)
    end_idx = start_idx(i)+window_length-1;
    epoch_data(i, :) = data(start_idx(i):end_idx);
    
    if end_idx<=27248
        labels(i)=1 ;%normal
    elseif start_idx(i)>27248 &&  end_idx<=53673
        labels(i)=2 ;%VFIB
    elseif start_idx(i)>53673 &&  end_idx<=55134
        labels(i)=4 ;%Noise
    elseif start_idx(i)>55135 &&  end_idx<=58288
        labels(i)=3 ;%NOD
    else
        labels(i)=0 ;%None
    end
end

%% Section d: Frequency Features

n_features = 5; % mean_freq, med_freq, bandpower(0, 20), bandpower(20, 40)
features = zeros(length(start_idx), 5);
band1 = [0 20];
band2 = [30 40];
band3 = [100 120];

for i = 1:length(start_idx)
    sig = epoch_data(i, :);
    features(i, 1) = meanfreq(sig, fs);
    features(i, 2) = medfreq(sig, fs);
    features(i, 3) = bandpower(sig, fs, band1);
    features(i, 4) = bandpower(sig, fs, band2);
    features(i, 5) = bandpower(sig, fs, band3);
end

%% Section e

feature_label = ["meanfreq", "medfreq", "band 0-20", "bandpower 30-40", "band 100-120"];
figure;
for i=1:n_features
    subplot(3,2,i)
    normal_data = features(labels == 1, i);
    histogram(normal_data, 30); hold on;
    VFIB_data = features(labels == 2, i);
    histogram(VFIB_data, 30); hold on;
    title(feature_label(i))
end

% result: meanfreq and band 30-40 selected

%% section f

[alarm_meanfreq ,t1] = va_detect(data,fs, "meanfreq");
[alarm_medfreq ,t2] = va_detect(data,fs, "medfreq");

%% Confusion
clc;

idx = [find(labels == 1); find(labels == 2)];
true_labels = (labels(idx) - 1)';
pred_labels1 = alarm_meanfreq(idx)';
[c1,cm1,ind1,per1] = confusion(true_labels, pred_labels1);

pred_labels2 = alarm_medfreq(idx)';
[c2,cm2,ind2,per2] = confusion(true_labels, pred_labels2);

figure;
subplot(1,2,1)
heatmap(cm1)
title('Feaature = meanfreq')

subplot(1,2,2)
heatmap(cm2)
title('Feaature = medfreq')

% report accuracy, ...

disp('Feature = mean frequency')
acc_medfreq = sum(diag(cm1)) / sum(cm1, 'all');
sens_medfreq = cm1(1,1)/(cm1(1,1)+cm1(2,1));
spec_medfreq = cm1(2,2)/(cm1(2,2)+cm1(1,2));
fprintf('accuracy = %f , sensitivity = %f , specificity = %f \n\n', ...
        acc_medfreq, sens_medfreq, spec_medfreq);
    
disp('Feature = median frequency')
acc_bandpower = sum(diag(cm2)) / sum(cm2, 'all');
sens_bandpower = cm2(1,1)/(cm2(1,1)+cm2(2,1));
spec_bandpower = cm2(2,2)/(cm2(2,2)+cm2(1,2));

fprintf('accuracy = %f , sensitivity = %f , specificity = %f \n', ...
        acc_bandpower, sens_bandpower, spec_bandpower);

%% Section g: demographic Features

n_features_demog = 6; % max, min, peaktopeak, findpeaks, zeros, var
features_demog = zeros(length(start_idx), n_features_demog);

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
    histogram(normal_data, 20); hold on;
    VFIB_data = features_demog(labels == 2, i);
    histogram(VFIB_data, 20); hold on;
    title(feature_label(i))
end

% result: max and R peaks avg

%%
clc;

[alarm_max ,t1] = va_detect(data,fs, "zeros");
[alarm_Rpeak ,t2] = va_detect(data,fs, "peak-to-peak");

pred_labels1 = alarm_max(idx)';
[c1,cm1,ind1,per1] = confusion(true_labels, pred_labels1);

pred_labels2 = alarm_Rpeak(idx)';
[c2,cm2,ind2,per2] = confusion(true_labels, pred_labels2);

figure;
subplot(1,2,1)
heatmap(cm1)
title('Feaature = zeros')

subplot(1,2,2)
heatmap(cm2)
title('Feaature = peak to peak')

% report accuracy, ...

disp('Feature = zeros')
acc_medfreq = sum(diag(cm1)) / sum(cm1, 'all');
sens_medfreq = cm1(1,1)/(cm1(1,1)+cm1(2,1));
spec_medfreq = cm1(2,2)/(cm1(2,2)+cm1(1,2));
fprintf('accuracy = %f , sensitivity = %f , specificity = %f \n\n', ...
        acc_medfreq, sens_medfreq, spec_medfreq);
    
disp('Feature = peak to peak')
acc_bandpower = sum(diag(cm2)) / sum(cm2, 'all');
sens_bandpower = cm2(1,1)/(cm2(1,1)+cm2(2,1));
spec_bandpower = cm2(2,2)/(cm2(2,2)+cm2(1,2));

fprintf('accuracy = %f , sensitivity = %f , specificity = %f \n', ...
        acc_bandpower, sens_bandpower, spec_bandpower);

    
%% part ژ

clc;

[alarm_Rpeak ,t2] = va_detect(data,fs, "R-peak-avg");

pred_labels2 = alarm_Rpeak(idx)';
[c2,cm2,ind2,per2] = confusion(true_labels, pred_labels2);

figure;
heatmap(cm2)
title('Feaature = R peak avg')

% report accuracy, ...

disp('Data 2 - Feature = R peak avg')
acc_bandpower = sum(diag(cm2)) / sum(cm2, 'all');
sens_bandpower = cm2(1,1)/(cm2(1,1)+cm2(2,1));
spec_bandpower = cm2(2,2)/(cm2(2,2)+cm2(1,2));

fprintf('accuracy = %f , sensitivity = %f , specificity = %f \n', ...
        acc_bandpower, sens_bandpower, spec_bandpower);
