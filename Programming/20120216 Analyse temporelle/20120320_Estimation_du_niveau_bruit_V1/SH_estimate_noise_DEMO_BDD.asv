% Test pour estimer le niveau de bruit signal
% 2012.03.20 - 2012.03.21

%%% Paramètre du test
close all; clear all; clc;

% Chemin de la base de données (au niveau de la racine)
bddPath = '../../../Base_de_donnees/20111100_Witschi_DB1/';

% Flag d'affichage
plotFlag = true;
saveFlag = false;

hWait = waitbar(0, 'Loading data...', 'Name', 'Processing. Please wait...');

%%% Chargement des noms des fichiers
hFig = zeros(1, 9);
for iPartner = 1 : 9,
    
    % Chemin de la base de données (au niveau du partenaire)
    partnerPath = [bddPath, 'P0', num2str(iPartner), '/V1.2/'];
    
    % Extraction du nombre de fichiers par partenaire et des noms de fichiers
    [nItem, itemName] = extract_folder_inventory(partnerPath);

    hFig(iPartner) = figure('color', 'white', 'visible', 'off');
    for iFile = 1 : min(nItem, 12),
        
        waitbar(((iPartner-1)*12+iFile)/(3*4*9), hWait, sprintf('Processing : partner %d /9  -  file %d /12', iPartner, iFile));

        %%% Chargement du signal
        % matObj  = matfile('P01_M01_E00_N01_T1800_V1.mat');
        matObj  = matfile([partnerPath, itemName{iFile}]);
        fs      = matObj.fs;
        signal  = matObj.signalPzt(1, 1:1*fs);
        timeAx  = axis_(signal, fs);


        %%% Normalisation du signal
        signal = signal ./ max(signal);


        %%% Calcul de l'énergie et réduction de la dynamique du bruit
        [noiseLevelDb, plotLevelDb] = SH_estimate_noise(signal);

        
        %%% Affichage du signal brut, de son énergie, du seuil de détection des
        %%% tocs et des tocs détectés
        if plotFlag,
            nSubplotRaw = 4;
            nsubplotCol = 3;

            % Subplot 1:1
            subplot(nSubplotRaw, nsubplotCol, iFile);
            hold on;

            plot(timeAx*1e3, 10*log10(signal.^2));
            line([0, max(timeAx*1e3)], noiseLevelDb([1, 1]), 'color', 'red');
            
            axis tight;
            ylim([plotLevelDb, 0]);
            xlabel('Time [ms]');
            switch iFile,
                case 1, txt = '\nSans défaut';
                case 4, txt = '\nNon lubrifié';
                case 7, txt = '\nDécentré';
                case 10,txt = '\nDent sur impulsion';
                otherwise, txt = ' ';
            end
            ylabel(sprintf(['Amplitude [-]', txt]));
            
            if iFile == 2,
                title(['Raw signal - P0', num2str(iPartner)]);
            end
        end
    end
end
close(hWait);

if saveFlag == true,
    for iPartner = 1 : 9,
       set(hFig(iPartner), 'visible', 'on');
       saveas(hFig(iPartner), ['.\Fig\P0', num2str(iPartner), '.fig'], 'fig');
       saveas(hFig(iPartner), ['.\Fig\P0', num2str(iPartner), '.tiff'], 'tiffn');
       set(hFig(iPartner), 'visible', 'off');
    end
end

if plotFlag == true,
    screenSize = get(0, 'ScreenSize');
    for iPartner = 1 : 9,
        set(hFig(iPartner), 'visible', 'on', 'position', [0, 0, screenSize(3), screenSize(4)]);
        pause();
        set(hFig(iPartner), 'visible', 'off');
    end
end