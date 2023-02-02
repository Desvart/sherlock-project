% function [startTocIdx] = toc_loc(signal)
% Toc localisation
%
clc;
clear all;
close all;

folderPath = '../../../Data/20111100_Witschi_DB1/P01/V1.2';
[filePathList, nFileTot] = load_file_path_list(folderPath);
for iFile = 1:nFileTot,
%     iFile = 1;
    
    
    matObj = matfile(filePathList{iFile});
    fs = matObj.fs;
    signal = matObj.signalPzt(1, 25679:2*fs);

    %%% D�tection grossi�re de la 3�me impulsion (M�thode 20120126-01)
    % Id�e de base: 
    %       1. seuil simple � -20 dB sur la puissance en db et normalis�e � max = 0 dB 
    %       2. D�tection des max dans les zones o� il y a un signal
    %           2.1 ?
    %       3. �limination des doubles pics proches avec une fen�tre d'analyse de 40 m (largeur 
    %          temporelle double de celle statistique d'un toc "normal")
    %%% Impl�mentation: 
    %       1. Seuil simple � 0.1 (= -20 dB) sur l'�nergie normalis�e � max = 1;
    
    
    energyThreshold = 0.05;
    sWindow = fs*40e-3;
    
    
    energy = signal.^2;
    maxEnergy = max(energy);
    energyNorm = energy ./ maxEnergy;
    
    energyThresholded = sparse(energyNorm >= energyThreshold);
    rawLocalisation = find(energyThresholded);
    findBloc = rawLocalisation(2:end) - rawLocalisation(1:end-1);
    blocSparseIdx = [1, find(findBloc > 1)+1];
    blocIdx = rawLocalisation(blocSparseIdx);
    
    % S�curit� pour �viter de prendre des �v�nements qui sont trop proches des bords du signal et
    % qui risquent d'�tre tronqu�s.
    blocIdx = blocIdx(blocIdx > sWindow  &  blocIdx < length(signal)-sWindow);
    
    
    maxDetected = 0; 
    maxLoc = 0;
    actualBlocFirstIdx = blocIdx(1);
    nMax = 1;
    nBloc = length(blocIdx);
    for iBloc = 2:nBloc,
        
        if blocIdx(iBloc) - blocIdx(iBloc-1) > sWindow || iBloc == nBloc,
            actualBlocIdx = actualBlocFirstIdx:actualBlocFirstIdx+sWindow;
            [maxDetected(nMax), maxLoc(nMax)] = max(energyNorm(actualBlocIdx));
            maxLoc(nMax) = actualBlocIdx(maxLoc(nMax));
            nMax = nMax + 1;
            actualBlocFirstIdx = blocIdx(iBloc);
        end
    end
    
    
    figure;
    hold on;
%     subplot(2,1,1);
    plot(energyNorm);
%     plot(blocIdx, energyThreshold*ones(1, length(blocIdx)), '*r');
    plot(maxLoc, maxDetected, '*r');
    
%     subplot(2,1,2);
%     plot(db(energyNorm));
    
%     line([0, length(energyNorm)], energyThreshold*ones(1, 2), 'color', 'r');
    pause;
    close all;

%     %%% Running power
%     power = running_mean(energy, 200);
%     
%     figure;
%     subplot(2,1,1);
%     plot(power);
%     subplot(2,1,2);
%     plot(db(power));
%     
%     
%     runningStd = zeros(1, length(power));
%     for i = 50:length(power),
%        runningStd(i) = std(db(power(i-50+1:i)));
%         
%     end
%     
%     figure;
%     subplot(2,1,1);
%     plot(runningStd);
%     subplot(2,1,2);
%     plot(db(runningStd));
% 
% 


end





    %%% D�tection grossi�re de la 3�me impulsion (M�thode 20120126-02)
    % Id�e de base: 
    %       1. Mesure du niveau de bruit du signal (en dB) normalis� � maxSignal = 0 dB
    %           1.1 Construction d'une enveloppe sup�rieure grossi�re du signal
    %           1.2 Calcul de la moyenne (m�diane?) de l'enveloppe 1.1 = niveau de bruit
    %           1.3 Calcul de la dynamique du signal (max - niveau de bruit)
    %       1. Seuil simple � x% de la dynamique sur l'�nergie en db et normalis�e � max = 0 dB 
    %       2. �limination des doubles pics proches avec une fen�tre d'analyse de 40 m (largeur 
    %          temporelle double de celle statistique d'un toc "normal")
    

% end
