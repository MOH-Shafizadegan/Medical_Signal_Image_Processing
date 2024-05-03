clc; clear; close all;

addpath('../Data/Lab 5_data/')

%% 

data = load('Lab 5_data\n_426.mat').n_426;
fs = 256;
window_length = 10 * fs;
overlap = 5 * fs;

start_idx = 1:overlap:length(data)-window_length;
epoch_data = zeros(length(start_idx), 10*fs);
labels = zeros(length(start_idx), 1);
for i = 1:length(start_idx)
    end_idx = start_idx(i)+window_length-1;
    epoch_data(i, :) = data(start_idx(i):end_idx);
    
    if end_idx<= 26432
        labels(i)=1 ;%normal
    elseif start_idx(i)> 26432
        labels(i)=2 ;%VF
    else
        labels(i)=0 ;%None
    end
end

%% part ژ

clc;

[alarm_Rpeak ,t2] = va_detect(data,fs, "R-peak-avg");

idx = [find(labels == 1); find(labels == 2)];
true_labels = (labels(idx) - 1)';
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

