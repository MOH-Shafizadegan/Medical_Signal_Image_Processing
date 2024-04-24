clc; clear; close all;

addpath('../Data/Lab 5_data/')

%% Load data

data = load('normal.mat').normal;
fs = 250;
clean_data = data(1:4*60*fs, :);
noisy_data = data(4*60*fs:end, :);

%%

clean_slected_data = clean_data(1*fs:10*fs, :);
clean_slected_data = clean_data(1*fs:10*fs, :);