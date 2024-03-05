clc; clear; close all;

addpath('../Data/Lab1_data')

%% load data

data = load('EEG_sig.mat');
Z = data.Z;
des = data.des;
fs = des.samplingfreq;
ch_names = des.channelnames;

%% Section 1
close all;

% plot channel 5
t_end = length(Z)/fs;
figure;
plot_time_sig(Z, 5, fs, [0, t_end], 'Channel 5');


%% Section 2
close all;

figure;
t_starts = [0 18 45 50];
t_ends = [15 40 50 t_end];
for i=1:4
    subplot(2,2,i);
    plot_time_sig(Z, 5, fs, [t_starts(i), t_ends(i)], 'Channel 5');
end

%% Section 3 Other channel

close all;
t_end = length(Z)/fs;
figure;
ch_id = 7;
plot_time_sig(Z, ch_id, fs, [0, t_end], strcat('Channel-', num2str(ch_id)));

%% Section 4

offset = max(max(abs(Z)))/5;
feq = 256;
ElecName = des.channelnames;
disp_eeg(Z, offset, feq, ElecName);
title(strcat('EEG with offset=', num2str(offset)))
%% section 6
clc; close all;

% C3_id = find(ch_names == 'C3');
C3_id = 5;

t_starts = [2 30 42 50];
t_ends = [7 35 47 55];

for i=1:length(t_ends)   
   subplot(4,2,2*i-1)
   plot_time_sig(Z, C3_id, fs, [t_starts(i), t_ends(i)], ...
       strcat('Time domain - Channel C3:', num2str(t_starts(i)), '-', num2str(t_ends(i))));
   subplot(4,2,2*i)
   plot_fft(Z, C3_id, fs, [t_starts(i), t_ends(i)], ...
       strcat('Freq domain - Channel C3:', num2str(t_starts(i)), '-', num2str(t_ends(i))), 256);
end

figure()
for i=1:length(t_ends)   
   subplot(4,2,2*i-1)
   plot_time_sig(Z, C3_id, fs, [t_starts(i), t_ends(i)], ...
       strcat('Time domain - Channel C3:', num2str(t_starts(i)), '-', num2str(t_ends(i))));
   subplot(4,2,2*i)
   plot_fft(Z, C3_id, fs, [t_starts(i), t_ends(i)], ...
       strcat('Freq domain - Channel C3:', num2str(t_starts(i)), '-', num2str(t_ends(i))), 256);
   xlim([-50 50])
end

%% Section 7
close all;

C3_id = 5;

t_starts = [2 30 42 50];
t_ends = [7 35 47 55];

for i=1:length(t_ends)   
   subplot(2,2,i)
   sig = Z(C3_id, t_starts(i)*fs+1:t_ends(i)*fs);
   pwelch(sig)
   title(strcat('Freq domain - Channel C3:', num2str(t_starts(i)), '-', num2str(t_ends(i))))
end

%% Section 8
% close all;

C3_id = 5;

t_starts = [2 30 42 50];
t_ends = [7 35 47 55];
L = 128;
noverlap = 64;
nfft = L;

figure;
for i=1:length(t_ends)   
   subplot(2,2,i)
   sig = Z(C3_id, t_starts(i)*fs+1:t_ends(i)*fs);
   spectrogram(sig, hamming(L), noverlap, nfft, fs, 'yaxis')
   title(strcat('Spectrogram - Channel C3:', num2str(t_starts(i)),...
                '-', num2str(t_ends(i))))
end

%% Section 9
close all;

i = 2;
sig = Z(C3_id, t_starts(i)*fs+1:t_ends(i)*fs);
filt_sig = lowpass(sig, 40, fs);
fs_new = 128;
sig_dwnsmpl = downsample(filt_sig, fs/fs_new);

figure;
subplot(2,3,1);
plot_time_sig(Z, C3_id, fs_new, [t_starts(i), t_ends(i)], ...
       strcat('Time domain - Channel C3 (downsampled):', num2str(t_starts(2)), '-',...
       num2str(t_ends(2))), sig_dwnsmpl);
subplot(2,3,2);
plot_fft(Z, C3_id, fs_new, [t_starts(i), t_ends(i)], ...
       strcat('Freq domain - Channel C3 (downsampled):', num2str(t_starts(2)),...
       '-', num2str(t_ends(2))), 256, sig_dwnsmpl);
subplot(2,3,3);
spectrogram(sig_dwnsmpl, hamming(L), noverlap, nfft, fs_new, 'yaxis')
   title(strcat('Spectrogram - Channel C3 (downsampled):', num2str(t_starts(2)),...
                '-', num2str(t_ends(2))))

subplot(2,3,4);
plot_time_sig(Z, C3_id, fs, [t_starts(i), t_ends(i)], ...
       strcat('Time domain - Channel C3:', num2str(t_starts(2)), '-',...
       num2str(t_ends(2))), sig);
subplot(2,3,5);
plot_fft(Z, C3_id, fs, [t_starts(i), t_ends(i)], ...
       strcat('Freq domain - Channel C3:', num2str(t_starts(2)),...
       '-', num2str(t_ends(2))), 256, sig);
subplot(2,3,6);
spectrogram(sig, hamming(L), noverlap, nfft, fs, 'yaxis')
   title(strcat('Spectrogram - Channel C3:', num2str(t_starts(2)),...
                '-', num2str(t_ends(2))))

            
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
    t = time_range(1):1/fs:time_range(2) - 1/fs;
    plot(t, sig, 'linewidth', 2);
    title(title_txt);
    xlabel('time(s)');
    ylabel('amplitude');
    
end
