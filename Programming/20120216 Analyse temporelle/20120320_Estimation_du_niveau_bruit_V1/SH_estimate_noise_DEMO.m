% Test pour estimer le niveau de bruit signal
% 2012.03.20 - 

%%% Paramètre du test
close all; clear all; clc;

% Chemin de la base de données (au niveau de la racine)
bddPath = '../../../Base_de_donnees/20111100_Witschi_DB1/';

% Flag d'affichage
plotFlag = true;

%%% Chargement des noms des fichiers
for iPartner = 9,
    
    % Chemin de la base de données (au niveau du partenaire)
    partnerPath = [bddPath, 'P0', num2str(iPartner), '/V1.2/'];
    
    % Extraction du nombre de fichiers par partenaire et des noms de fichiers
    [nItem, itemName] = extract_folder_inventory(partnerPath);

    figure('color', 'white');
    for iFile = 1 : min(nItem, 1),

        %%% Chargement du signal
        % matObj  = matfile('P01_M01_E00_N01_T1800_V1.mat');
        matObj  = matfile([partnerPath, itemName{iFile}]);
        fs      = matObj.fs;
        signal  = matObj.signalPzt(1, 1:5*fs);
        timeAx  = axis_(signal, fs);


        %%% Normalisation du signal
        signal = signal ./ max(signal);


        [noiseLevelDb, plotLevelDb] = SH_estimate_noise(signal);
        


        %%% Affichage du signal brut, de son énergie, du seuil de détection des
        %%% tocs et des tocs détectés
        if plotFlag,
            nSubplotRaw = 1;
            nsubplotCol = 1;

            % Subplot 1:1
            subplot(nSubplotRaw, nsubplotCol, iFile);
            hold on;

            plot(timeAx*1e3, 10*log10(signal.^2));
%             plot(timeAx*1e3, a);
%             plot(energyDb);
%             plot(a, 'r');
%             plot(a+1.5*b, 'g')
            line([0, max(timeAx*1e3)], noiseLevelDb([1, 1]), 'color', 'red');
%             line([0, max(timeAx*1e3)], noiseThresholdDb([1, 1]), 'color', 'red');
            
            axis tight;
            ylim([plotLevelDb, 0]);
            xlabel('Time [ms]');
            ylabel('Amplitude [-]');
            title('Raw signal');
        end
    end
end
