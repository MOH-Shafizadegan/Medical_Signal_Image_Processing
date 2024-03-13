clc; clear; close all;

addpath('../Data/Lab3_data/data')
addpath('../Data/Lab3_data/matlab')

%% Load data

X = load('data\X.dat');
fs = 256;

%%  Section 1: ICA

[W Zhat]=ica(X');
w_inv = inv(W);
save('../Report/figures/w_inv.mat', 'w_inv')

%%  Section 2
plot3ch(Zhat')

figure()
for i = 1:3
    plot3dv(w_inv(:, i))
end
xlabel('x');
ylabel('y');
zlabel('z');
%% Section 3

t = (1:length(Zhat))/fs;

figure;
subplot(3,1,1)
plot(t,Zhat(1,:))
xlabel('time(sec)')
ylabel('amp(mV)')
title('1st source')

subplot(3,1,2)
plot(t,Zhat(2,:))
xlabel('time(sec)')
ylabel('amp(mV)')
title('2nd source')

subplot(3,1,3)
plot(t,Zhat(3,:))
xlabel('time(sec)')
ylabel('amp(mV)')
title('3rd source')

%%% Conclusion : The 3rd source is the fetus ECG

%% Section 4

clc;

Z_new = Zhat;
Z_new(1:2, :) = 0;

X_recunst=w_inv*Z_new;

fecg_recuns=X_recunst(3,:);

figure;
plot(t,fecg_recuns);
xlabel('time(sec)')
ylabel('amp(mV)')
title('recuntructed signal using ICA')
ylim([-10 10])
