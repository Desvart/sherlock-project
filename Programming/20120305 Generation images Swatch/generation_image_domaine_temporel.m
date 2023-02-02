% Affichage de signaux temporels
% 2012.03.05

close all;
clc;
clear all;


addpath('./Lib/');

dbPath  = '../../Base_de_donnees/20111100_Witschi_DB1/P09/V1.2/';
outPath = './Images_output/';
[filePathList, nFileTot, fileNameList] = load_file_path_list(dbPath);

titre = {'Sans défaut 1';...
         'Sans défaut 2';...
         'Sans défaut 3';...
         'Sans lubrification 1';...
         'Sans lubrification 2';...
         'Sans lubrification 3';...
         'Spiral décentré 1';...
         'Spiral décentré 2';...
         'Spiral décentré 3';...
         'Dent sur impulsion 1';...
         'Dent sur impulsion 2';...
         'Dent sur impulsion 3'};
     
nom = {'Sans_defaut_1';...
         'Sans_defaut_2';...
         'Sans_defaut_3';...
         'Sans_lubrification_1';...
         'Sans_lubrification_2';...
         'Sans_lubrification_3';...
         'Spiral_decentre_1';...
         'Spiral_decentre_2';...
         'Spiral_decentre_3';...
         'Dent_sur_impulsion_1';...
         'Dent_sur_impulsion_2';...
         'Dent_sur_impulsion_3'};  
     

for iFile = 1:nFileTot,
% for iFile = 1,
    
    matObj = matfile(filePathList{iFile});
    
    fs = matObj.fs;
    signal = matObj.signalPzt(1, 1:fs);
    signal = signal./max(signal);
    
    timeAxis = axis_(signal, fs);
    
    h = figure('color', 'white');
    
    subplot(3, 1, 1);
    plot(timeAxis*1e3, signal);
    axis tight;
    xlabel('Time [ms]');
    ylabel('Amplitude [-]');
    title(titre{iFile});
    
    subplot(3, 1, 2);
    plot(timeAxis*1e3, signal.^2);
    axis tight;
    xlabel('Time [ms]');
    ylabel('Energy [-]');
    
    subplot(3, 1, 3);
    plot(timeAxis*1e3, db(signal));
    axis tight;
    ylim([mean(db(signal(signal~=0))), 0]);
    xlabel('Time [ms]');
    ylabel('Energy [dB]');
    
    
%     fileName = fileNameList{iFile}(1:end-4);
    saveas(h, [outPath, 'time_', nom{iFile}, '.fig']);
    saveas(h, [outPath, 'time_', nom{iFile}, '.tiff'], 'tiffn');
    
    close(h);
    
end


rmpath('./Lib/');