clc; clear; close all;

addpath('../Data/Lab1_data')

%% load data

data = load('EOG_sig.mat');
sig = data.Sig;
fs = data.fs;
labels = data.Labels;

%% Section 1
figure;
subplot(2,1,1);
plot_time_sig(sig, 1, fs, [0 length(sig)/fs], labels(1))
subplot(2,1,2);
plot_time_sig(sig, 2, fs, [0 length(sig)/fs], labels(2))

%% Section 2
clc; close all;
L = 128;
noverlap = 64;
nfft = L;

for i=1:length(labels)   
   subplot(2,2,i)
   plot_fft(sig, i, fs, [0 length(sig)/fs], ...
       strcat('Freq domain-', labels(i), ' :'), nfft);
   subplot(2,2,i+2)
   SpectSignal = sig(i, :) / max(abs(sig(i, :)));
   spectrogram(SpectSignal, hamming(L), noverlap, nfft, fs, 'yaxis')
   title(strcat('Spectrogram -', labels(i), ':'))
end


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

    t = linspace(time_range(1), time_range(2) - 1/fs, length(sig));
    plot(t, sig, 'linewidth', 2);
    title(title_txt);
    xlabel('time(s)');
    ylabel('amplitude');
    
end
