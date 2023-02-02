

close all;
clc;
clear all;

addpath('./Lib/');

folderPath = '../../Data/20111100_Witschi_DB1/P08/V1.2';
[filePathList, nFileTot] = load_file_path_list(folderPath);
for iFile = 1:nFileTot,
    
    
    matObj = matfile(filePathList{iFile});
    
    fs = matObj.fs;
    signal = matObj.signalPzt(1, 1:fs);
    
    
    [stdft, tAxis, fAxis] = stdft_(signal, sqrt(hann(1024, 'periodic')), 1/16, fs) ;
    
    h = figure('color', 'white');
    pcolor(tAxis*1e3, fAxis/1e3, db(stdft));
    shading flat;
    
    saveas(h, ['.\stdft\stdft_', filePathList{iFile}(end-27:end-4)]);
    
    close(h);
    
end


rmpath('./Lib/');