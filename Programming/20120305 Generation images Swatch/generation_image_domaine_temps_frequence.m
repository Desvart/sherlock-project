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
% for iFile = 1:1,
    
    matObj = matfile(filePathList{iFile});
    
    fs = matObj.fs;
    signal = matObj.signalPzt(1, 1:fs);
    signal = signal./max(signal);
    
    [stdft, tAxis, fAxis] = stdft_(signal, sqrt(hann(1024, 'periodic')), 1/16, fs) ;
    
    stdft = stdft ./ max(max(stdft));
    stdftDb = db(stdft);
    minThreshold = mean(mean(stdftDb));
    stdftDb(stdftDb < minThreshold) = minThreshold;
    
    
    
    h = figure('color', 'white');
    pcolor(tAxis*1e3, fAxis/1e3, stdftDb); shading('flat');
    axis tight;
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    zlabel('Energy [dB]');
    colorbar;
    title(titre{iFile});
    
%     fileName = fileNameList{iFile}(1:end-4);
    saveas(h, [outPath, 'time_frequency_2D_', nom{iFile}, '.fig']);
    saveas(h, [outPath, 'time_frequency_2D_', nom{iFile}, '.tiff'], 'tiffn');
    
    close(h);
    
    
    h = figure('color', 'white');
    mesh(tAxis*1e3, fAxis/1e3, stdftDb); shading('flat');
%     view([30,-90,180]); % Vue pour un spectrogramme non seuillé
    view([30,-100,600]); % Vue pour un spectrogramme seuillé
    axis tight;
    xlabel('Time [ms]');
    ylabel('Frequency [kHz]');
    zlabel('Energy [dB]');
    colorbar;
    title(titre{iFile});
    
    
%     fileName = fileNameList{iFile}(1:end-4);
    saveas(h, [outPath, 'time_frequency_3D_', nom{iFile}, '.fig']);
    saveas(h, [outPath, 'time_frequency_3D_', nom{iFile}, '.tiff'], 'tiffn');
    
    close(h);

    

    
end


rmpath('./Lib/');