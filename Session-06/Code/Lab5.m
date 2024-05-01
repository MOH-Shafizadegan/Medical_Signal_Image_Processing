clc; clear; close all;

addpath('../Data/')
%% Configs

load('ElecPosXYZ') ;

%%
%Forward Matrix
ModelParams.R = [8 8.5 9.2] ; % Radius of diffetent layers
ModelParams.Sigma = [3.3e-3 8.25e-5 3.3e-3]; 
ModelParams.Lambda = [.5979 .2037 .0237];
ModelParams.Mu = [.6342 .9364 1.0362];

Resolution = 1 ;
[LocMat,GainMat] = ForwardModel_3shell(Resolution, ModelParams) ;

%% Section 1, 2, and 3

clc;

f_all = figure;
scatter3(LocMat(1,:), LocMat(2,:), LocMat(3,:))

hold on;

Elec_loc = zeros(21, 3);
for i=1:21
    Elec_loc(i,:) = ElecPos{i}.XYZ .* ModelParams.R(3);
    text(Elec_loc(i,1), Elec_loc(i,2), Elec_loc(i,3), ElecPos{i}.Name)
end

scatter3(Elec_loc(:,1), Elec_loc(:,2), Elec_loc(:,3), 'filled')

title('Diopole and Electrodes locations')
xlabel('x')
ylabel('y')
zlabel('z')

rand_idx = randi(length(LocMat), 1);
vec_norm = norm(LocMat(:, rand_idx));
quiver3(LocMat(1, rand_idx), LocMat(2, rand_idx) ,LocMat(3, rand_idx), ...
        LocMat(1, rand_idx)/vec_norm, LocMat(2, rand_idx)/vec_norm ,LocMat(3, rand_idx)/vec_norm, ...
        'linewidth', 3);
    
scatter3(0, 0, 0, 'r*', 'linewidth', 3);

%% Section 4
clc; 

load('Interictal.mat');

ElecPot = GainMat(:, (rand_idx-1)*3+1:rand_idx*3) * (Interictal(1, :) .* (LocMat(:, rand_idx)/vec_norm));
Elec_labels = cell(21, 1);
for i=1:21
    Elec_labels{i} = ElecPos{i}.Name;
end
disp_eeg(ElecPot, 15, 256, Elec_labels)

%% Section 5
clc;

figure;
mean_Pot = zeros(21, 1);
for i=1:21
    [pks, locs] = findpeaks(ElecPot(i,:), 'MinPeakProminence', 0.9*max(ElecPot(i,:)));
    epochs = zeros(length(locs), 7);
    for j=1:length(locs)
       epochs(j, :) = ElecPot(i, locs(j)-3:locs(j)+3);
    end
    mean_Pot(i) = mean(epochs, 'all');
end

Display_Potential_3D(ModelParams.R(3), mean_Pot)

%% Section 6
clc;

alpha = 0.1;
G = GainMat;
M = ElecPot;
Q_hat = G' * inv(G*G' + alpha * eye(21)) * M;

q_norm = zeros(size(Q_hat,1)/3, 1);
for i=1:(size(Q_hat,1)/3)
   q_norm(i) = norm(Q_hat((i-1)*3+1:i*3, :)); 
end
[~, idx] = max(q_norm);
estimated_q = LocMat(:, idx);

error = rms(estimated_q - LocMat(:, rand_idx));
es_q_norm = norm(estimated_q);
fprintf("RMS = %f\n", error)
delta_angle = acosd((estimated_q' * LocMat(:, rand_idx)) / (es_q_norm * vec_norm));
fprintf("dipole angle error = %f\n", delta_angle)

figure(f_all)
quiver3(estimated_q(1), estimated_q(2), estimated_q(3), ...
        estimated_q(1)/es_q_norm, estimated_q(2)/es_q_norm ,estimated_q(3)/es_q_norm, ...
        'linewidth', 3);
