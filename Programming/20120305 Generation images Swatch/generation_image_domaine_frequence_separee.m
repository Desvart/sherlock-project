% Affichage de signaux spectraux séparés
% 2012.03.05

%% Init script
close all;
clear all;
clc;

% fullscreen = get(0,'ScreenSize');


%%% User inputs
lib = {'Lib'};
databasePath = '../../Base_de_donnees/20111100_Witschi_DB1/P09/V1.2/';
outPath = './Images_output/';
% spec = {'T:1800, P:E, N6=E2++', ...
%         ' ', ...
%         'T:1800, P:S, N10+N12:modif. pont ancre', ...
%         ' ', ...
%         'T:0090, P:E, N11: E3 démarrage difficile', ...
%         'T:0090, P:E+S, -', ...
%         ' ', ...
%         'T:1800, P:E+S, E5:complication', ...
%         };
signalDuration      = 2;

%config opt
stdftN              = 1024*4;
stdftWin            = sqrt(hann(stdftN, 'periodic'));
% stdftWin            = rectwin(stdftN);
stdftShift          = 8/128;

% config fast
% stdftN              = 512/4;
% stdftWin            = sqrt(hann(stdftN, 'periodic'));
% stdftShift          = 1/4;

th = 1.5;


shouldPrint = false;
printFlag = 'on';
if shouldPrint == true;
    printFlag = 'off';
end


%%% Load library
for iLib = 1 : length(lib),
    if exist(['./', lib{iLib}, '/'], 'dir'), 
        addpath(genpath(['./', lib{iLib}, '/'])); 
    end
end


%%% Load signal
[filePathList, nFile] = load_file_path_list(databasePath);

psdH = zeros(nFile, floor(stdftN/2 + 1));
psdA = zeros(nFile, floor(stdftN/2 + 1));

hWaitbar = waitbar(1/(nFile+1), sprintf('Please wait. Processing file 1/%d...', nFile));
for iFile = 1 : nFile,
    
    %%% Load signal
    matObj = matfile(filePathList{iFile});
    fs = double(matObj.fs);
    signal = double(matObj.signalPzt(1, 1:signalDuration*fs));

    %%% Compute spectrogram
    [stdft, stdftTAxis, stdftFAxis] = stdft_(signal, stdftWin, stdftShift, fs);
    normStdft = stdft/max(max(stdft));
    
    %%% Compute Power Spectrum Density (PSD)
    psd = sum(stdft, 2);
    
    %%% Compute Power Time Density (equivalent to PSD but in time)
    ptd = sum(stdft, 1);

    %%% Keep only harmonics from spectrogram
    threshold = db(median(ptd/max(ptd)));
    
    normStdftH = normStdft;
    noiseLevel = median(normStdft(ceil(end/2), :));
    AttackIdx = db(ptd/max(ptd))>threshold/th;
    normStdftH(:, AttackIdx) = noiseLevel*ones(length(psd), sum(AttackIdx));
    o = ones(size(normStdftH));
    noiseLoc = db(normStdftH)<db(mean(normStdftH(ceil(end/2), :)))*4/5;
    normStdftH(noiseLoc) = noiseLevel*o(noiseLoc);
    
    
    %%% Keep only attack from spectrogram
    normStdftA = normStdft;
    noiseLevel = median(normStdftA(ceil(end/2), :));
    normStdftA(:, db(ptd/max(ptd))<threshold/th) = noiseLevel*ones(length(psd), sum(db(ptd/max(ptd))<threshold/th));
    
    %%% Compute Power Spectrum Density (PSD)
    psdH(iFile, :) = sum(normStdftH, 2);
    psdA(iFile, :) = sum(normStdftA, 2);
    

    waitbar(iFile/(nFile+1), hWaitbar, sprintf('Please wait. Processing file %d/%d...', iFile, nFile));
end
close(hWaitbar);

%%% Normalise les spectres
normFactor = max(max([psdH, psdA]));
psdH = psdH ./ normFactor;
psdA = psdA ./ normFactor;


medianGrp = median(psdH, 2);
psdH = bsxfun(@minus, psdH, medianGrp);

% titre = {'Harmonics without known default', 'Attacks without known default',...
%     'Harmonics with "Echappement non lubrifié"', 'Attacks with "Echappement non lubrifié"',...
%     'Harmonics with "Spiral décentré"', 'Attacks with "Spiral décentré"',...
%     'Harmonics with "Palettes sur impulsion"', 'Attacks with "Palettes sur impulsion"', ...
%     'Harmonics with "Complication"', 'Attacks with "Complication"'};

titre = {'Sans défaut - Spectre modale moyen', 'Sans défaut - Spectre d''attaque moyen',...
    'Non lubrifié - Spectre modale moyen', 'Non lubrifié - Spectre d''attaque moyen',...
    'Spiral décentré - Spectre modale moyen', 'Spiral décentré - Spectre d''attaque moyen',...
    'Dents sur impulsion - Spectre modale moyen', 'Dents sur impulsion - Spectre d''attaque moyen'};

h = figure('color', 'white');
       
for i = 1 : nFile/3,
    
    subplot(4, 1, i);
    plot(stdftFAxis/1e3, (psdH((i-1)*3+1+(0:2), :)));
    
    axis tight;
    xlabel('Frequency [kHz]');
    ylabel('Energy magnitude [-]');
    title(titre{(i-1)*2 + 1}, 'FontWeight','bold');
    
    legend('Mouvement 1', 'Mouvement 2', 'Mouvement 3');
    
end

saveas(h, [outPath, 'freqency_split_mode.fig']);
saveas(h, [outPath, 'freqency_split_mode.tiff'], 'tiffn');
close(h);

h = figure('color', 'white');
for i = 1 : nFile/3,
    
    subplot(4, 1, i);
    plot(stdftFAxis/1e3, (psdA((i-1)*3+1+(0:2), :)));
    
    axis tight;
    xlabel('Frequency [kHz]');
    ylabel('Energy magnitude [-]');
    title(titre{(i-1)*2 + 2}, 'FontWeight','bold');
    
    legend('Mouvement 1', 'Mouvement 2', 'Mouvement 3');
end

saveas(h, [outPath, 'frequency_split_attack.fig']);
saveas(h, [outPath, 'frequency_split_attack.tiff'], 'tiffn');
close(h);



















