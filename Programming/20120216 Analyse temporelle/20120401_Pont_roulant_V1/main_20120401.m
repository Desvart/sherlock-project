% Test pour détecter la position grossière de chaque toc
% 2012.04.01 - 2012.04.??

%%% Paramètre du test
close all; clear all; clc;
addpath('./Lib/');

% Flag d'affichage
plotFlag = false;
dispFlag = true;


%%% Chargement du signal
matObj  = matfile('../../../Base_de_donnees/20111100_Witschi_DB1/P09/V1.2/P09_M01_E00_N10_T0030_V1.mat');
fs      = matObj.fs;
[~, signalS] = size(matObj, 'signalPzt');
% signalS = 5*3.5*fs;



%% Extraction de la fréquence du signal

%%% Chargement d'un échantillon de 5 secondes du signal
signal  = matObj.signalPzt(1, 1:5*fs);
signal  = signal ./ max(signal); % Normalisation du signal
timeAx  = axis_(signal, fs);


%%% Calcul de l'énergie et réduction de la dynamique du bruit
[noiseLevelDb, plotLevelDb] = SH_estimate_noise(signal);
   

%%% Détection des maximum de chaque toc.
[rawTocIdx, nToc] = SH_raw_toc_detection(signal, noiseLevelDb, fs);


%%% Calcul de la période des tocs
f1t = rawTocIdx(3:2:end) - rawTocIdx(1:2:end-2);
f2t = rawTocIdx(4:2:end) - rawTocIdx(2:2:end-2);
tm  =  floor(mean([mean(f1t), mean(f2t)])/2);
tv  = max([std(f1t), std(f2t)]);
if tv/tm*100 >= 0.2,
    error('First bloc contains an anomaly.');
end


%% Extraction des max pour tout le signal

%%% Calcul du nombre de blocs traités 
blocD = 5;
blocS = blocD * fs;
startIdx = rawTocIdx(2) - floor(tm/2);
nBloc = floor((signalS - startIdx) / (blocS - tm));

%%% Calcul des index de début et de fins des blocs
blocStartIdx = startIdx(ones(1, nBloc)) + cumsum([0, (blocS - tm)*ones(1, nBloc-1)]);
blocStopIdx = blocStartIdx + blocS;

%%% Loop for each bloc
nTocPerBloc = round(fs/tm)*blocD - 1;
rawTocAbsIdx = zeros(1, nBloc*nTocPerBloc);

hWaitbar = waitbar(1/(nBloc+1), sprintf('Please wait. Processing bloc 1/%d...', nBloc));
a = 0;
% figure; 
for iBloc = 1 : nBloc,

    %%% Load bloc signal
    signal  = matObj.signalPzt(1, blocStartIdx(iBloc):blocStopIdx(iBloc));
   
    %%% Détection des maximum de chaque toc.
    [rawTocIdx, nToc] = SH_raw_toc_detection(signal, SH_estimate_noise(signal), fs);
    a = a + nToc;
    fprintf('iBloc = %d, nToc = %d, totalToc = %d\n', iBloc, nToc, a);
    idx = 1 : length(signal);
%     hold on; plot(idx, abs(signal)); plot(idx(rawTocIdx), abs(signal(rawTocIdx)), '*r');
%     pause();
%     clf;
    
    %%% Compute absolute position
    rawTocAbsIdx((iBloc-1)*nTocPerBloc + 1 : iBloc*nTocPerBloc) = blocStartIdx(iBloc) + rawTocIdx(1:end-1) - 1;
    
    %%%
    waitbar(iBloc/(nBloc+1), hWaitbar, sprintf('Please wait. Processing bloc %d/%d...', iBloc, nBloc));
end
close(hWaitbar);




signal = abs(matObj.signalPzt(1, 1:signalS)); figure; idx = 1:signalS; plot(idx, signal); hold on; plot(idx(rawTocAbsIdx), signal(rawTocAbsIdx), '*r');





%% Disp
if dispFlag == true,
    fprintf('Mvt @ %2.0f alt/s = %4.0f éch. (sigma_max = %3.0f éch.) \n', fs/tm, tm, tv);
end



%% Plot
if plotFlag,
    
    %%% Calcul de l'énergie du signal
    energy = signal.^2;
    energyDb = 10*log10(energy);

    
    %%% Figure 1
    figure('color', 'white');
    nSubplotRaw = 2;
    
    % Subplot 1:1 : Time domain
    subplot(nSubplotRaw, 1, 1);
    hold on;
    
    plot(timeAx*1e3, signal);
    plot(timeAx(rawTocIdx)*1e3,   signal(rawTocIdx),   'r*');
    plot(timeAx(tocStartIdx)*1e3, signal(tocStartIdx), 'g*');
    plot(timeAx(tocStopIdx)*1e3,  signal(tocStopIdx),  'g+');
    
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