% Test pour détecter la position grossière de chaque toc
% 2012.02.16 - 2012.03.19

%%% Paramètre du test
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


%%% Calcul de l'énergie et réduction de la dynamique du bruit
energy = signal.^2;
energyDb = 10*log10(energy);
meanEnergyDb = mean(energyDb(energyDb ~= -Inf)); % -66 dB (-65 dB pour la médiane)
% energyDb(energyDb < meanEnergyDb) = meanEnergyDb;
noiseThresholdDb = mean(energyDb(energyDb > meanEnergyDb));
% energyDb(energyDb < noiseThresholdDb) = noiseThresholdDb;


%%% Evaluation d'un seuil pour détecter grossièrement la localisation des
%%% tocs
rawTocThresholdDb   = noiseThresholdDb / 3; % -20 dB
rawTocThreshold     = 10^(rawTocThresholdDb/10); % 0.012


%%% Rassemblement des tocs au dessus du seuil de localisation par bloc.
% Cette partie peut aussi être appliquée directement à l'énergie simple du signal. Les résultats
% sont les mêmes. Par soucis de représentation graphique, j'ai préféré appliquer la détection sur
% l'énergie en déibel.

% % Seuillage V1
% energyDbTh = energyDb;
% energyDbTh(energyDb < rawTocThresholdDb) = rawTocThresholdDb;

% Seuillage V2
energyDbTh = energyDb - rawTocThresholdDb;
energyDbTh(energyDbTh <= 0) = 0;

% Création des blocs par une moyenne mobile (10 ms) et binarisation des blocs
nRMeanPad = 10e-3 * fs;
energyDbBloc = running_mean(energyDbTh, nRMeanPad, true);

energyDbBlocBin = energyDbBloc;
energyDbBlocBin(energyDbBloc >  min(energyDbBloc)) = 1;
energyDbBlocBin(energyDbBloc <= min(energyDbBloc)) = 0;

% Détection du début et de la fin des blocs
blocBorderSignal = energyDbBlocBin(2:end) - energyDbBlocBin(1:end-1);
idx = 1:length(blocBorderSignal);
startIdx = idx(blocBorderSignal == +1);
stopIdx  = idx(blocBorderSignal == -1);
if stopIdx(1) < startIdx(1),
    stopIdx = stopIdx(2:end);
end
if stopIdx(end) < startIdx(end),
    startIdx = startIdx(1:end-1);
end

% Extraction du max de chaque bloc
blockPos        = startIdx;
N               = max(stopIdx-startIdx);
bandPos         = 1:N;
signalMatrix    = energyDbTh(ones(N, 1)*(blockPos-1) + bandPos'*ones(1, length(blockPos)));
[~, maxIdxRel]  = max(signalMatrix);
maxIdx          = startIdx + maxIdxRel -1 ;



%%% Affichage du signal brut, de son énergie, du seuil de détection des
%%% tocs et des tocs détectés
if plotFlag,
    figure('color', 'white');
    nSubplotRaw = 4;
    
    % Subplot 1:1
    subplot(nSubplotRaw, 1, 1);
    
    plot(timeAx*1e3, signal);
    axis tight;
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    title('Raw signal');
    
    % Subplot 2:1
    subplot(nSubplotRaw, 1, 2);
    hold on;
    
    plot(timeAx*1e3, energy);
    line([0, max(timeAx*1e3)], rawTocThreshold([1, 1]), 'color', 'red');
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    title(sprintf('Signal energy (threshold = %2.3f)', rawTocThreshold));
    
    % Subplot 3:1
    subplot(nSubplotRaw, 1, 3);
    hold on;
    
    energyDbNoiseClipped = energyDb;
    energyDbNoiseClipped(energyDb < noiseThresholdDb) = noiseThresholdDb;
    
    plot(timeAx*1e3, energyDbNoiseClipped);
    line([0, max(timeAx*1e3)], rawTocThresholdDb([1, 1]), 'color', 'red');
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [dB]');
    title(sprintf('Signal energy (noise clipped < %2.0f dB, threshold = 1/3 noiselevel = %2.0f dB)', noiseThresholdDb, rawTocThresholdDb));
    
    % Subplot 4:1
    subplot(nSubplotRaw, 1, 4);
    hold on;
    
    plot(timeAx*1e3, energyDbTh);
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [dB]');
    title(sprintf('Toc raw detection (threshold = %2.0f dB)', rawTocThresholdDb));
    
    
end


%%% Affichage de ce qui est au dessus du seuil brut

if plotFlag,
    figure('color', 'white');
    nSubplotRaw = 4;
    nSubplotCol = 1;
    
    % Subplot 1:1
    subplot(nSubplotRaw, nSubplotCol, 1);
    
    plot(timeAx*1e3, energyDbTh);
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    title(sprintf('Toc raw detection (threshold = %2.3f)', rawTocThreshold));
    
    % Subplot 2:1
    subplot(nSubplotRaw, nSubplotCol, 2);
    
    plot(timeAx*1e3, energyDbBloc);
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    title(sprintf('Toc raw detection (threshold = %2.3f)', rawTocThreshold));
    
    % Subplot 3:1
    subplot(nSubplotRaw, nSubplotCol, 3);
    
    plot(timeAx*1e3, energyDbBlocBin);
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    title(sprintf('Toc raw detection (threshold = %2.3f)', rawTocThreshold));
    
    % Subplot 4:1
    subplot(nSubplotRaw, nSubplotCol, 4);
    
    plot(timeAx*1e3, [0, blocBorderSignal]);
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    title(sprintf('Toc raw detection (threshold = %2.3f)', rawTocThreshold));
    
end


if plotFlag,
    figure('color', 'white');
    nSubplotRaw = 2;
    nSubplotCol = 1;
    
    % Subplot 1:1
    subplot(nSubplotRaw, nSubplotCol, 1);
    hold on;
    
    plot(signalMatrix);
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    title(sprintf('Bloc matrix'));
    
    % Subplot 2:1
    subplot(nSubplotRaw, nSubplotCol, 2);
    hold on;
    
    plot(timeAx*1e3, energyDbTh);
    plot(timeAx(maxIdx)*1e3, energyDbTh(maxIdx), 'r*');
    
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    title(sprintf('Toc - Max detection results'));
    
    
end

