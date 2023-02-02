% Test pour détecter la position grossière de chaque toc
% 2012.03.27 - 2012.03.27

%%% Paramètre du test
close all; clear all; clc;
addpath('./Lib/');

% Flag d'affichage
plotFlag = true;


%%% Chargement du signal
% matObj  = matfile('P01_M01_E00_N01_T1800_V1.mat');
matObj  = matfile('../../../Base_de_donnees/20111100_Witschi_DB1/P09/V1.2/P09_M01_E00_N10_T0030_V1.mat');
fs      = matObj.fs;
signal  = matObj.signalPzt(1, 1:5*fs);
timeAx  = axis_(signal, fs);


%%% Normalisation du signal
signal = signal ./ max(signal);


%%% Calcul de l'énergie du signal
energy = signal.^2;
energyDb = 10*log10(energy);


%%% Calcul de l'énergie et réduction de la dynamique du bruit
[noiseLevelDb, plotLevelDb] = SH_estimate_noise(signal);
   

%%% Détection des maximum de chaque toc.
[rawTocIdx, nToc] = SH_raw_toc_detection(signal, noiseLevelDb, fs);


%%% Calcul de la période des tocs
f1t = rawTocIdx(3:2:end) - rawTocIdx(1:2:end-2);
f2t = rawTocIdx(4:2:end) - rawTocIdx(2:2:end-2);
t   =  floor(mean([mean(f1t)/2, mean(f2t)/2]) / 2);


%%% Extraction des limites de chaque blocs
tocStartIdx = rawTocIdx - floor(t/2);
tocStartIdx(1) = max(1, tocStartIdx(1));
tocStopIdx  = rawTocIdx + t;
tocStopIdx(end) = min(length(signal), tocStopIdx(end));


%%% 
for iToc = 1 : 1,
   
    tocSignal = signal(tocStartIdx(iToc):tocStopIdx(iToc));
    tocSignal(tocSignal == 0) = tocSignal(1);
    N = .25e-3*fs;
    N = 5;
    
    m1 = running_mean(tocSignal, N, true);
    m11 = running_mean(abs(tocSignal), N, true);
    m2 = running_mean(tocSignal.^2, N, true);
    m3 = running_mean(10*log10(tocSignal.^2), N, true);
    
    M = 5*2;
    m4 = [zeros(1, M), m3(M:end)-m3(1:end-(M-1))];
    
    
    e1 = running_std(tocSignal, N, true);
    e11 = running_std(abs(tocSignal), N, true);
    e2 = running_std(tocSignal.^2, N, true);
    e3 = running_std(10*log10(tocSignal.^2), N, true);
    
    figure('color', 'white');
    subplot(4, 1, 1); hold on;
    plot(tocSignal);
    plot(e1, 'r');
    
    subplot(4, 1, 2); hold on;
    plot(abs(tocSignal));
    plot(m11, 'r');
    
    subplot(4, 1, 3); hold on;
    plot(tocSignal.^2);
    plot(m2, 'r');
    
    subplot(4, 1, 4); hold on;
    plot(10*log10(tocSignal.^2));
    plot(m3, 'r');
    plot(m4, 'g');
    
end



a = energyDb - noiseLevelDb;
a(a<0) = 0;

d = running_mean(a, 70);
figure; hold on;
% plot(a);
plot(d, 'r');

n = 70;
b = [zeros(1, n), abs(d(n:end)-d(1:end-(n-1)))];
% c = running_mean(b, 50);

% figure; hold on;
% plot(b, 'r');
% plot(c, 'r');



% figure; hold on;
% plot(1:2:2*length(f1t), f1t, 'b');
% plot(1:2:2*length(f2t), f2t, 'r');
% plot(mean(f) + f, 'k--')



%%% Affichage du signal brut, de son énergie, du seuil de détection des
%%% tocs et des tocs détectés
if plotFlag,
    figure('color', 'white');
    nSubplotRaw = 2;
    
    % Subplot 1:1 : Time domain
    subplot(nSubplotRaw, 1, 1);
    hold on;
    
    plot(timeAx*1e3, signal);
    plot(timeAx(rawTocIdx)*1e3, signal(rawTocIdx), 'r*');
    plot(timeAx(tocStartIdx)*1e3, signal(tocStartIdx), 'g*');
    plot(timeAx(tocStopIdx)*1e3, signal(tocStopIdx), 'g+');
    
    axis tight;
    
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    title('Raw signal');
    
    
    % Subplot 2:1 : energy domain (dB)
    subplot(nSubplotRaw, 1, 2);
    hold on;
    
    plot(timeAx*1e3, energyDb);
    plot(timeAx(rawTocIdx)*1e3, energyDb(rawTocIdx), 'r*');
    plot(timeAx(tocStartIdx)*1e3, energyDb(tocStartIdx), 'g*');
    plot(timeAx(tocStopIdx)*1e3, energyDb(tocStopIdx), 'g+');
    
    axis tight;
    ylim([plotLevelDb, 0]);
    
    xlabel('Time [ms]');
    ylabel('Energy [dB]');
    title('Raw energy signal and maximum energy detected');
    
end

rmpath('./Lib/');