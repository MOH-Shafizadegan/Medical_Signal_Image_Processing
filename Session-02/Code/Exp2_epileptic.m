clc; clear; close all;

addpath('../Data/Lab2_2')

%% Load data

data1 = load('NewData1.mat').EEG_Sig;
data2 = load('NewData3.mat').EEG_Sig;
electrodes = load('Electrodes.mat').Electrodes;
fs = 250;
elocsX = electrodes.X;
elocsY = electrodes.Y;
elabels = electrodes.labels;

%% Section 1
close all;

plotEEG(data1);
title('NewData 1');

plotEEG(data2);
title('NewData 2');

%% Section 2 data 1
clc; %close all;

[F1,W1,K1] = COM2R(data1, size(data1,2));
[F2,W2,K2] = COM2R(data2, size(data2,2));

ICs_1 = W1 * data1;
ICs_2 = W2 * data2;

for i=1:size(data1,1)
   
    figure;
    
    subplot(2,2,1)
    t = (1:length(ICs_1))/fs;
    plot(t, ICs_1(i,:))
    ylim([-100 100])
    
    subplot(2,2,3)
    [p, f] = pwelch(ICs_1(i, :), [], [], [], fs);
    plot(f,p);
    
    subplot(2,2,[2 4])
    plottopomap(elocsX,elocsY,elabels,F1(:,i))
    
    title(strcat('IC-', num2str(i)))
    
end

%% Topo data 1

figure;
for i=1:size(data1,1)
   subplot(5,5,i) 
   plottopomap(elocsX,elocsY,elabels,F1(:,i))
   title(strcat('IC-', num2str(i)))
end

%% Data 1 reconst

delsources = [1 10 4 18];
F1_new = F1;
F1_new(:, delsources) = 0;

data1_reconst = F1_new * ICs_1;
plotEEG(data1_reconst);
title('reconstructed NewData 1');


%% Section 2 data 1
clc; close all;

for i=1:size(data2,1)
   
    figure;
    
    subplot(2,2,1)
    t = (1:length(ICs_2))/fs;
    plot(t, ICs_2(i,:))
    ylim([-100 100])
    
    subplot(2,2,3)
    [p, f] = pwelch(ICs_2(i, :), [], [], [], fs);
    plot(f,p);
    
    subplot(2,2,[2 4])
    plottopomap(elocsX,elocsY,elabels,F2(:,i))
    
    title(strcat('IC-', num2str(i)))
    
end

%% Topo data 2

figure;
for i=1:size(data2,1)
   subplot(5,5,i) 
   plottopomap(elocsX,elocsY,elabels,F2(:,i))
   title(strcat('IC-', num2str(i)))
end

%% Data 1 reconst

delsources_2 = [1 7];
F2_new = F2;
F2_new(:, delsources_2) = 0;

data2_reconst = F2_new * ICs_2;
plotEEG(data2_reconst);
title('reconstructed NewData 2');


