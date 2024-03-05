clc; clear; close all;

addpath('../Data/Lab1_data')

%% load data

data = load('ECG_sig.mat');
sig = data.Sig';
fs = data.sfreq;
Rwave_t = data.ATRTIMED;
label = data.ANNOTD;

%% Section 1
figure;
subplot(2,1,1);
plot_time_sig(sig, 1, fs, [0 length(sig)/fs], "Lead 1")
subplot(2,1,2);
plot_time_sig(sig, 2, fs, [0 length(sig)/fs], "Lead 2")

%%

subplot(2,1,1);
plot_time_sig(sig, 1, fs, [0 10], "Lead 1 (0s - 10s)")
subplot(2,1,2);
plot_time_sig(sig, 1, fs, [900 910], "Lead 1 (900s - 910s)")


%% Section 2

clc;
close all;

label_id = [1 4 5 6 7 8 11 14 28 37];
label_name = {'Normal', 'ABERR', 'PVC', 'FUSION', 'NPC', 'APC', ...
                'NESC', 'NOISE', 'RHYTHM', 'NAPC'};

label_name_map = containers.Map(label_id, label_name);
figure;
subplot(2,1,1);
plot_time_sig(sig, 1, fs, [0 length(sig)/fs], "Lead 1")
for i = 1:length(label)
    text(Rwave_t(i),sig(1,round(Rwave_t(i)*fs)),label_name_map(label(i)));
end

subplot(2,1,2);
plot_time_sig(sig, 2, fs, [0 length(sig)/fs], "Lead 2")
for i = 1:length(label)
    text(Rwave_t(i),sig(2,round(Rwave_t(i)*fs)),label_name_map(label(i)));
end

%% Section 3
close all
plotted_label = [];
figure()
index = 1;
for i = 2:length(label)-2
    if find(plotted_label==label(i))
        continue
    else
        subplot(5,4,index)
        plot_time_sig(sig, 1, fs, [Rwave_t(i-1) Rwave_t(i+1)], strcat(label_name_map(label(i)), ' - lead I'))
        text(Rwave_t(i),sig(1,round(Rwave_t(i)*fs)),label_name_map(label(i)));
        subplot(5,4,index+1)
        plot_time_sig(sig, 2, fs, [Rwave_t(i-1) Rwave_t(i+1)], strcat(label_name_map(label(i)), ' - lead II'))
        text(Rwave_t(i),sig(2,round(Rwave_t(i)*fs)),strcat(label_name_map(label(i))));
        plotted_label = [plotted_label, label(i)];
        index = index + 2;
    end
    
end

%% Section 4
close all; clc;

normal_pulse_3 = strfind(label', [1,1,1]);
idx = normal_pulse_3(2);
time_interval = [Rwave_t(idx)-0.5, Rwave_t(idx+3)-0.5];
subplot(2,1,1)
plot_time_sig(sig, 1, fs, time_interval, '3 normal pulses - lead I')
text(Rwave_t(idx),sig(1,round(Rwave_t(idx)*fs)),strcat(label_name_map(label(idx))));
text(Rwave_t(idx+1),sig(1,round(Rwave_t(idx+1)*fs)),strcat(label_name_map(label(idx+1))));
text(Rwave_t(idx+2),sig(1,round(Rwave_t(idx+2)*fs)),strcat(label_name_map(label(idx+2))));

subplot(2,1,2)
abber_pulse_3 = strfind(label', [5,4,4]);
idx = abber_pulse_3(1);
time_interval = [Rwave_t(idx)-0.5, Rwave_t(idx+3)-0.25];
plot_time_sig(sig, 1, fs, time_interval, '3 abnormal pulses - lead I')
text(Rwave_t(idx),sig(1,round(Rwave_t(idx)*fs)),strcat(label_name_map(label(idx))));
text(Rwave_t(idx+1),sig(1,round(Rwave_t(idx+1)*fs)),strcat(label_name_map(label(idx+1))));
text(Rwave_t(idx+2),sig(1,round(Rwave_t(idx+2)*fs)),strcat(label_name_map(label(idx+2))));


%% FFT

close all; clc;

normal_pulse_3 = strfind(label', [1,1,1]);
idx = normal_pulse_3(2);
time_interval = [Rwave_t(idx)-0.5, Rwave_t(idx+3)-0.5];
subplot(2,2,1)
N = (time_interval(2)- time_interval(1)) * fs;
plot_fft(sig, 1, fs, time_interval, '3 normal pulses - lead I', N)
ylim([0 180])
subplot(2,2,2)
plot_fft(sig, 2, fs, time_interval, '3 normal pulses - lead II', N)
ylim([0 180])

abber_pulse_3 = strfind(label', [5,4,4]);
idx = abber_pulse_3(1);
time_interval = [Rwave_t(idx)-0.5, Rwave_t(idx+3)-0.25];
subplot(2,2,3)
plot_fft(sig, 1, fs, time_interval, '3 abnormal pulses - lead I', N)
ylim([0 180])
subplot(2,2,4)
plot_fft(sig, 2, fs, time_interval, '3 abnormal pulses - lead II', N)
ylim([0 180])

%% Spectogram

close all; clc;

L = fs/2;
noverlap = fs/4;
nfft = L;

normal_pulse_3 = strfind(label', [1,1,1]);
idx = normal_pulse_3(2);
time_interval = [Rwave_t(idx)-0.5, Rwave_t(idx+3)-0.5];
subplot(2,2,1)
spectrogram(sig(1, time_interval(1)*fs:time_interval(2)*fs), ...
    hamming(L), noverlap, nfft, fs, 'yaxis')
title('3 normal pulses - lead I')
subplot(2,2,2)
spectrogram(sig(2, time_interval(1)*fs:time_interval(2)*fs), ...
    hamming(L), noverlap, nfft, fs, 'yaxis')
title('3 normal pulses - lead II')

abber_pulse_3 = strfind(label', [5,4,4]);
idx = abber_pulse_3(1);
time_interval = [Rwave_t(idx)-0.5, Rwave_t(idx+3)-0.25];
subplot(2,2,3)
spectrogram(sig(1, time_interval(1)*fs:time_interval(2)*fs), ...
    hamming(L), noverlap, nfft, fs, 'yaxis')
title('3 abnormal pulses - lead I')
subplot(2,2,4)
spectrogram(sig(2, time_interval(1)*fs:time_interval(2)*fs), ...
    hamming(L), noverlap, nfft, fs, 'yaxis')
title('3 abnormal pulses - lead II')

%% functions

function plot_fft(data, id, fs, time_range, title_txt, N, sig)

    if nargin == 6
        sig = data(id, time_range(1)*fs+1:time_range(2)*fs);
    end
    fft_sig=fftshift(fft(sig,N));
    f= linspace(-fs/2,fs/2,N);
    plot(f,abs(fft_sig), 'linewidth', 2)
    title(title_txt)
    xlabel('Freq (Hz)')
    ylabel('abs')

end

function plot_time_sig(data, id, fs, time_range, title_txt, sig)
    
    % time_range = [start, end] in seconds
    if nargin == 5
       sig = data(id, time_range(1)*fs+1:time_range(2)*fs); 
    end
%         t = time_range(1):1/fs:time_range(2) - 1/fs;

    t = linspace(time_range(1), time_range(2) - 1/fs, length(sig));
%     [length(t), length(sig)]
    plot(t, sig, 'linewidth', 2);
    title(title_txt);
    xlabel('time(s)');
    ylabel('amplitude');
    
end
