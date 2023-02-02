% Test pour d�tecter la position grossi�re de chaque toc
% 2012.03.27 - 2012.03.27

%%% Param�tre du test
close all; clear all; clc;

% Flag d'affichage
plotFlag = true;


%%% Chargement du signal
% matObj  = matfile('P01_M01_E00_N01_T1800_V1.mat');
matObj  = matfile('../../../Base_de_donnees/20111100_Witschi_DB1/P03/V1.2/P03_M01_E00_N01_T1800_V1.mat');
fs      = matObj.fs;
signal  = matObj.signalPzt(1, 1:5*fs);
timeAx  = axis_(signal, fs);


%%% Normalisation du signal
signal = signal ./ max(signal);


%%% Calcul de l'�nergie du signal
energy = signal.^2;
energyDb = 10*log10(energy);


%%% Calcul de l'�nergie et r�duction de la dynamique du bruit
[noiseLevelDb, plotLevelDb] = SH_estimate_noise(signal);
   

%%% D�tection des maximum de chaque toc.
[rawTocIdx] = SH_raw_toc_detection(signal, noiseLevelDb, fs);



%%% Affichage du signal brut, de son �nergie, du seuil de d�tection des
%%% tocs et des tocs d�tect�s
if plotFlag,
    figure('color', 'white');
    nSubplotRaw = 2;
    
    % Subplot 1:1 : Time domain
    subplot(nSubplotRaw, 1, 1);
    hold on;
    
    plot(timeAx*1e3, signal);
    plot(timeAx(rawTocIdx)*1e3, signal(rawTocIdx), 'r*');
    
    axis tight;
    
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    title('Raw signal');
    
    
    % Subplot 2:1 : energy domain (dB)
    subplot(nSubplotRaw, 1, 2);
    hold on;
    
    plot(timeAx*1e3, energyDb);
    plot(timeAx(rawTocIdx)*1e3, energyDb(rawTocIdx), 'r*');
    
    axis tight;
    ylim([plotLevelDb, 0]);
    
    xlabel('Time [ms]');
    ylabel('Energy [dB]');
    title('Raw energy signal and maximum energy detected');
    
end

