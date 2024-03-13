clc; clear; close all;

addpath('../Data/Lab3_data/data')
addpath('../Data/Lab3_data/matlab')

%% Load data

load('data\X.dat');
fs = 256;

%% Section 1

plot3ch(X,fs,'');

%% SVD

clc;

[U,S,V] = svd(X);

%% Section 2
clc;

plot3dv(V(:,1), S(1:3, 1:3))

%% Section 3

plot3ch(U(:,1:3), fs, 'U');
