clc; clear; close all;

addpath('../Data/Lab3_data/data')
addpath('../Data/Lab3_data/matlab')

%% Load data

load('data\X.dat');
fs = 256;

%% Section 1

plot3ch(X,fs,'Mixed ECG');

%% SVD

clc;

[U,S,V] = svd(X);

%% Section 2
clc;    
figure
for i = 1:3
    plot3dv(V(:,i), S(i, i))
end

%% Section 3

plot3ch(U(:,1:3), fs, 'U');

figure;
stem(S(1:3,:))
xlim([-1 4])

%% 

S_fetus = zeros(size(S));
S_fetus(2,2) = S(2,2);

X_fetus = U * S_fetus * V';
save('../Report/data/X_fetus_SVD.mat', 'X_fetus')

%%

plot3ch(X_fetus, fs, 'Fetus ECG');
