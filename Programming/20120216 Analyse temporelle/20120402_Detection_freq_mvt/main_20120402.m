% Test pour d�tecter la position grossi�re de chaque toc
% 2012.04.02 - 2012.04.02

%%% Param�tre du test
close all; clear all; clc;
addpath('./Lib/');

% Flag d'affichage
plotFlag = true;
dispFlag = true;


%%% Chargement du signal
matObj  = matfile('../../../Base_de_donnees/20111100_Witschi_DB1/P09/V1.2/P09_M01_E00_N10_T0030_V1.mat');
fs      = matObj.fs;
[~, signalS] = size(matObj, 'signalPzt');
% signalS = 5*3.5*fs;



%% Extraction de la fr�quence du signal

%%% Chargement d'un �chantillon de 5 secondes du signal
signal  = matObj.signalPzt(1, 1:5*fs);
signal  = signal ./ max(signal); % Normalisation du signal


%%% Calcul de l'�nergie et r�duction de la dynamique du bruit
[noiseLevelDb, plotLevelDb] = SH_estimate_noise(signal);
   

%%% D�tection des maximum de chaque toc.
[rawTocIdx, nToc] = SH_raw_toc_detection(signal, noiseLevelDb, fs);


%%% Calcul de la p�riode des tocs
f1t = rawTocIdx(3:2:end) - rawTocIdx(1:2:end-2);
f2t = rawTocIdx(4:2:end) - rawTocIdx(2:2:end-2);
tm  =  floor(mean([mean(f1t), mean(f2t)])/2);
tv  = max([std(f1t), std(f2t)]);
if tv/tm*100 >= 0.2,
    error('First bloc contains an anomaly.');
end



%% Disp
if dispFlag == true,
    fprintf('Mvt @ %2.0f alt/s = %4.0f �ch. (sigma_max = %3.0f �ch.) \n', fs/tm, tm, tv);
end



%% Plot
if plotFlag,

    %%% Prepare signal for plot
    signal = signal(1:fs);
    timeAx = axis_(signal, fs);
    
    %%% Figure 1
    figure('color', 'white');
    
    plot(timeAx*1e3, signal);
    
    axis tight;
    
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    title(sprintf('Raw signal (f = %2.0f alt./s)', fs/tm));
    
end

rmpath('./Lib/');