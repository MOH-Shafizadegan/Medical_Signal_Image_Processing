clc; clear; close all;

addpath('../Data/Lab 5_data/')

%% Load data

data = load('normal.mat');
data = data.normal;

figure;
plot(data(:,1), data(:,2))
title('time domain of all data')
xlabel('time (s)')
ylabel('magnitude')

fs = 250;
clean_data = data(1:4*60*fs, :);
noisy_data = data(4*60*fs:end, :);

%% section 1
close all;

clean_slected_data = clean_data(0*fs + 1 : 10*fs, :);
noisy_slected_data = noisy_data(0*fs + 1 : 10*fs, :);

figure;
labels = ['Pz', 'Oz', 'P7', 'P8', 'O2', 'O1'];
subplot(2,1,1)

[p, f] = pwelch(clean_slected_data(:, 2), [], [], [], fs);
plot(f, 10 * log(p));
title('clean slected data')

subplot(2,1,2)
[p, f] = pwelch(noisy_slected_data(:, 2), [], [], [], fs);
plot(f, 10 * log(p));
title('noisy slected data')

%% section 2
clc;
close all;
total_power = sum(p(2:end));
niny_percent_of_power = 0.9 * total_power;

low_cut_freq = 2;
high_cut_freq = low_cut_freq + 1;
selected_power = 0;
while ((selected_power < niny_percent_of_power) && (high_cut_freq < length(p)))
    selected_power = sum(p(low_cut_freq : high_cut_freq));
    high_cut_freq = high_cut_freq + 5;
end

high_cut_freq = min(high_cut_freq, length(p));

display(strcat('low_cut_freq= ', num2str(f(low_cut_freq))))
display(strcat('high_cut_freq= ', num2str(f(high_cut_freq))))

[y,d] = bandpass(data(:,2), [low_cut_freq, high_cut_freq], 2*fs);
[h,f] = freqz(d,1024, 2*fs);
plot(f,mag2db(abs(h)))
grid on
title('frequency response of filter')
ylabel('db')
xlabel('Hz')

impusle_sig = zeros(1, length(y));
impusle_sig(1) = 1;
[h,d] = bandpass(impusle_sig,[low_cut_freq high_cut_freq], 2*fs);

figure;
stem(h)
title('impulse response')
ylabel('magnitude')
xlabel('time')

%% Section 3
clc;
close all;
figure;

t= (0*fs + 1 : 10*fs);

% clean
subplot(2,4,1)
plot(clean_data(t,1),clean_data(t,2))
title('Clean data before filtering')
ylabel('volt')
xlabel('t')
grid on

clean_data_filtered = bandpass(clean_data(:, 2), [low_cut_freq high_cut_freq], 2*fs);
subplot(2,4,5)
plot(clean_data(t, 1),clean_data_filtered(t))
title('Clean data after filtering')
ylabel('volt')
xlabel('t')
grid on

subplot(2,4,2)
[p, f] = pwelch(clean_data(t, 2));
plot(f, 10*log(p))
title('Clean data before filtering')
ylabel('db')
xlabel('Hz')

grid on

subplot(2,4,6)
[p, f] = pwelch(clean_data_filtered(t));
plot(f, 10*log(p))
title('Clean data after filtering')
ylabel('db')
xlabel('Hz')
grid on


% noisy
subplot(2,4,3)
plot(noisy_data(t,1),noisy_data(t,2))
title('Noisy data before filtering')
ylabel('volt')
xlabel('t')
grid on

noisy_data_filtered = bandpass(noisy_data(:, 2), [low_cut_freq high_cut_freq], 2*fs);
subplot(2,4,7)
plot(noisy_data(t,1), noisy_data_filtered(t))
title('Noisy data after filtering')
ylabel('volt')
xlabel('t')
grid on

subplot(2,4,4)
[p, f] = pwelch(noisy_data(t,1));
plot(f, 10*log(p))
title('Noisy data before filtering')
ylabel('db')
xlabel('Hz')
grid on

subplot(2,4,8)
[p, f] = pwelch(noisy_data_filtered(t));
plot(f, 10*log(p))
title('Noisy data after filtering')
ylabel('db')
xlabel('Hz')
grid on






