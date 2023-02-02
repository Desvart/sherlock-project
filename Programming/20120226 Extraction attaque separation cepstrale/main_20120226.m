% Extraction d'attaque par séparation cepstrale
% 2012.02.26

%%% Paramètre du test
% close all; clear all; clc;

% Flag d'affichage
plotFlag = true;


%%% Chargement du signal
matObj  = matfile('P01_M01_E00_N01_T1800_V1.mat');
fs      = matObj.fs;
signal  = matObj.signalPzt(1, 1:fs/2.3);
timeAx  = axis_(signal, fs);


%%% Normalisation du signal
signal = signal ./ max(signal);


%%% Calcul du spectrogramme en vue d'une reconstruction ultérieure
N = 1024;
S = 1/256;
win = sqrt(hann(N, 'periodic'));
[stdftUM, stdftUP, sStopPadding, tAxis, fAxis] = stdftA_(signal, win, S, fs);
[nBand, nBlock] = size(stdftUM);


%%% Calcul du spectrogramme reassigné
[STFTpos, CIFpos, LGDpos, f, t, tremap] = Nelsonspec(signal, fs, N, N*S, N, 0, fs/2, -50);
    
STFTmag = abs(STFTpos); % magnitude of STFT
STFTmag = STFTmag ./ max(max(STFTmag)); % normalize so max magnitude will be 0 db
STFTmag = 20*log10(STFTmag); % convert to log magnitude, decibel scale

plot_these = find(STFTmag >= -40 & 0 <= CIFpos & CIFpos <= fs/2 );
STFTplot = STFTmag(plot_these);
CIFplot = CIFpos(plot_these);
tremap = tremap(plot_these);
plotpoints = [1000*tremap(:), CIFplot(:), STFTplot(:)];


%%% Séparation cepstrale par filtrage du spectre (trop long)
% % Coefficients des filtres de séparation cepstrale
% [bh, ah] = butter(8, 1/16, 'high');
% [bl, al] = butter(8, 1/16, 'low');
% 
% nBand  = size(stdftU, 1);
% nBlock = size(stdftU, 2);
% fineStruct = zeros(nBand, nBlock); % Prealloc
% envelopp   = zeros(nBand, nBlock); % Prealloc
% hWaitbar = waitbar(1/(nBlock+1), sprintf('Please wait. Processing block 1/%d...', nBlock));
% for iBlock = 1 : nBlock,
%     
%     fineStruct(:, iBlock) = filtfilt(bh, ah, stdftU(:, iBlock));
%     envelopp(:, iBlock)   = filtfilt(bl, al, stdftU(:, iBlock));
%     
%     waitbar(iBlock/(nBlock+1), hWaitbar, sprintf('Please wait. Processing block %d/%d...', iBlock, nBlock));
% end
% close(hWaitbar);


%%% Separation cepstrale par analyse cepstrale

% Calcul du cepstrogramme
cepstrum = ifft(log(stdftUM)) / nBand;

% Séparation cepstrale (brutale, peut être fait de manière plus "douce")
cutingIdx = round((N/2)*5/100);

cepstralEnv  = cepstrum;
cepstralEnv(cutingIdx : end-cutingIdx, :) = min(min(cepstrum));

cepstralFineS = cepstrum;
cepstralFineS([1 : cutingIdx , end-cutingIdx : end], :) = min(min(cepstrum));

% Reconstruction cepstrale (cepstrogramme -> spectrogramme)
logEnvelopp = real( fft(cepstralEnv *nBand) );
envelopp   	= exp(logEnvelopp);

logFineS    = real( fft(cepstralFineS*nBand) );
fineStruct  = exp(logFineS);


%%% Reconstruction spectrale (spectrogramme -> signal temporel)
signalA = stdftI_(envelopp, stdftUP, win', S, sStopPadding);
signalM = stdftI_(fineStruct, stdftUP, win', S, sStopPadding);

signalA1 = stdftI_(stdftUM./fineStruct, stdftUP, win', S, sStopPadding);
signalM1 = stdftI_(stdftUM./envelopp, stdftUP, win', S, sStopPadding);

%%% Affichage du signal brut, de son énergie, du seuil de détection des
%%% tocs et des tocs détectés
% if plotFlag,
%     figure('color', 'white');
%     
%     
%     subplot(3, 1, 1);
%     plot(timeAx*1e3, db(signal));
%     axis tight;
%     xlabel('Time [ms]');
%     ylabel('Amplitude [-]');
%     title('Raw signal');
%     
%     
%     subplot(3, 1, 2);
%     hold on;
%     
%     plot(timeAx*1e3, db(signalA));
%     
%     axis tight;
%     xlabel('Time [ms]');
%     ylabel('Energy [-]');
%     title('Signal energy');
%     
%     subplot(3, 1, 3);
%     hold on;
%     
%     plot(timeAx*1e3, db(signalM));
%     
%     axis tight;
%     xlabel('Time [ms]');
%     ylabel('Energy [-]');
%     title('Signal energy');
%     
% end

% 
% %%% Affichage du spectrogramme, de l'enveloppe et de la structure fine
if plotFlag,
%     figure('color', 'white');
%     tAxis = 1:nBlock;
%     fAxis = 1 : nBand;
%     
%     pcolor(tAxis*1e3, fAxis/1e3, db(stdftUM)); shading flat;
%     
%     xlabel('Time [ms]');
%     ylabel('Frequency [kHz]');
%     title('Signal spectrogram');
    
    figure('color', 'white');
    
    %
     subplot(2, 2, 1);
    pcolor(tAxis*1e3, fAxis/1e3, db(stdftUM)); shading flat;
    
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title('Signal spectrogram');
    
    %
    subplot(2, 2, 3);
    
    scatter3(plotpoints(:, 1), plotpoints(:, 2), plotpoints(:, 3), 4, plotpoints(:, 3), 'filled');
    axis tight;
    view(0, 90);
    colormap('jet');
    
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title('Signal reassigned spectrogram');
    
	%
    subplot(2, 2, 2);
    
    th = mean(fineStruct(~isnan(fineStruct))); 
    fineStruct(fineStruct <= th*2.5) = 0.1;
    pcolor(tAxis*1e3, fAxis/1e3, db(fineStruct)); shading flat;
       
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title('Signal fine strucutre spectrogram');
    
    %
    subplot(2, 2, 4);
    
    pcolor(tAxis*1e3, fAxis/1e3, db(envelopp)); shading flat;
    
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    title('Signal envelopp spectrogram');
end
