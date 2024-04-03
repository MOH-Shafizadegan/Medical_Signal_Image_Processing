clc; clear; close all;

%% Load data

X = load('data\X.dat');
fs = 256;
load('../Report/data/w_inv.mat');
load('../Report/data/Zhat.mat');
load('../Report/data/fecg_recuns_ICA.mat')
load('../Report/data/X_fetus_SVD.mat')

%% Section 1: comparing results
close all
[U,S,V] = svd(X);

plot3ch(X,fs,'X');
plot3ch(U(:,1:3),fs,'Data after SVD');
plot3ch(Zhat.',256,'Data after ICA')

figure()
for i = 1:3
    plot3dv(V(:,i).',S(i,i),'r')
    plot3dv(w_inv(:,i))
end

legend('SVD', 'ICA')

%% 
clc
w_inv_deg = zeros(1,3);
w_inv_norm = zeros(1,3);
for i = 1:3
    u = w_inv(:, i);
    v = w_inv(:, mod(i, 3)+1);
    w_inv_deg(i) = acosd(dot(u,v) / (norm(u)*norm(v)));
    w_inv_norm(i) = norm(u);
end
disp('angles between A = ');
disp(w_inv_deg);

V_deg = zeros(1,3);
V_norm = zeros(1,3);
for i = 1:3
    u = V(:, i);
    v = V(:, mod(i, 3)+1);
    V_deg(i) = acosd(dot(u,v) / (norm(u)*norm(v)));
    V_norm(i) = norm(u);
end
disp('angles between V = ');
disp([V_deg(1),V_deg(2),V_deg(3)]);

disp('norms A  = ');
disp(w_inv_norm);

disp('norms V = ');
disp(V_norm);

%% Section 2
% scale outputs
svd_out = X_fetus(:,1)/norm(X_fetus(:,1)); %output of SVD
ica_out = fecg_recuns(1,:)/norm(fecg_recuns(1,:)); %output of ica
figure()
t = 0:1/fs:((length(fecg_recuns)-1)/fs);
subplot(3,1,1);
plot(t,svd_out);
title('output of SVD(normalized)');
xlabel('time');
ylabel('Magnitude');
subplot(3,1,2);
plot(t,ica_out);
title('output of ICA(normalized)');
xlabel('time');
ylabel('Magnitude');
load('data/fecg2.dat')
subplot(3,1,3);
plot(t,fecg2/norm(fecg2));
title('real signal');
sgtitle('comparing results');
xlabel('time');
ylabel('Magnitude');

%% Section 3
score_SVD = corrcoef(fecg2,svd_out);
disp('corrcoef SVD ');
disp(score_SVD(1,2));

score_ICA = corrcoef(fecg2,ica_out);
disp('corrcoef ICA ');
disp(score_ICA(1,2));
