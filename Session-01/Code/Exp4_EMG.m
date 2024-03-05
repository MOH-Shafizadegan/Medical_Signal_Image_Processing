%% Load data
clc; clear; close all;

EMG_data = load('../Data/Lab1_data/EMG_sig.mat');
fs = EMG_data.fs;
emg_healthym = EMG_data.emg_healthym;
emg_myopathym = EMG_data.emg_myopathym;
emg_neuropathym = EMG_data.emg_neuropathym;

%% Part 1
clc; close all;

figure;
subplot(3,1,1)
time_range = [0 length(emg_healthym)/fs];
title_txt = "Healthy";
plot_time_sig(emg_healthym, fs, time_range, title_txt)

subplot(3,1,2)
time_range = [0 length(emg_healthym)/fs];
title_txt = "Myopathy";
plot_time_sig(emg_myopathym, fs, time_range, title_txt)

subplot(3,1,3)
time_range = [0 length(emg_healthym)/fs];
title_txt = "Neuropathy";
plot_time_sig(emg_neuropathym, fs, time_range, title_txt)

%% Part 2  FFT

figure;
subplot(3,1,1)
time_range = [0 length(emg_healthym)/fs];
title_txt = "Healthy";
N = length(emg_healthym);
plot_fft(emg_healthym, fs, time_range, title_txt, fs)

subplot(3,1,2)
time_range = [0 length(emg_healthym)/fs];
title_txt = "Myopathy";
N = length(emg_myopathym);
plot_fft(emg_myopathym, fs, time_range, title_txt, fs)

subplot(3,1,3)
time_range = [0 length(emg_healthym)/fs];
title_txt = "Neuropathy";
N = length(emg_neuropathym);
plot_fft(emg_neuropathym, fs, time_range, title_txt, fs)

%% Part 2 - Spectrogram

L = fs/2;
noverlap = fs/4;
nfft = L;

figure;
subplot(3,1,1)
sig = emg_healthym ./ max(emg_healthym);
spectrogram(sig, hamming(L), noverlap, nfft, fs, 'yaxis')
title('Healthy')

subplot(3,1,2)
spectrogram(zscore(emg_myopathym), hamming(L), noverlap, nfft, fs, 'yaxis')
title('Myopathy')

subplot(3,1,3)
spectrogram(zscore(emg_neuropathym), hamming(L), noverlap, nfft, fs, 'yaxis')
title('Neuropathy')

%% Functions

function plot_time_sig(data, fs, time_range, title_txt)
    
    sig = data(time_range(1)*fs+1:time_range(2)*fs);
    t = time_range(1):1/fs:time_range(2) - 1/fs;
    plot(t, sig, 'linewidth', 2);
    title(title_txt);
    xlabel('time(s)');
    ylabel('amplitude');
    
end

function plot_fft(data, fs, time_range, title_txt, N)

    sig = data(time_range(1)*fs+1:time_range(2)*fs);
    fft_sig=fftshift(fft(sig,N));
    f= linspace(-fs/2,fs/2,N);
    plot(f,abs(fft_sig), 'linewidth', 2)
    title(title_txt)
    xlabel('Freq (Hz)')
    ylabel('abs')

end
