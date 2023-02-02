
close all;
clc;
clear all;

addpath('./Lib/');

folderPath = '../../../Data/20111100_Witschi_DB1/P01/V1.2';
[filePathList, nFileTot] = load_file_path_list(folderPath);
for iFile = 1:nFileTot,
%     iFile = 1;
    
    
    matObj = matfile(filePathList{iFile});
    
    fs = matObj.fs;
    signal = matObj.signalPzt(1, 1:2*fs);
    
    
    figure('color', 'white');
    plot(signal);
    pause;
    close;
    
    t1 = cumsum([23040 33333*ones(1, 2*6-1)]);
    t2 = t1 + 8640*ones(1, 2*6);
    
    figure('color', 'white');
    hold on;
    plot(signal);
    plot(t1, zeros(1, length(t1)), '*r');
    plot(t2, zeros(1, length(t2 )), '*g');
    pause;
    close;
    
    
    signalGlob = 0;
    signalTic = 0;
    signalTac = 0;
    for i = 1:6,
       signalGlob = [signalGlob, signal(t1(i):t2(i))];
       signalTic = [signalTic, signal(t1(i*2):t2(i*2))];
       signalTac = [signalTac, signal(t1((i-1)*2+1):t2((i-1)*2+1))];
    end
    
    
    [dftGlob, axGlob] = dft_(signalGlob, fs);
    [dftTic, axTic] = dft_(signalTic, fs);
    [dftTac, axTac] = dft_(signalTac, fs);
    
    
    
    h = figure('color', 'white');
    plot(dftGlob);
    
    
    saveas(h, ['.\dft\dft_glob_', filePathList{iFile}(end-27:end-4)]);
    
    
    
    h = figure('color', 'white');
    plot(dftTic);
    
    
    saveas(h, ['.\dft\dft_tic_', filePathList{iFile}(end-27:end-4)]);
    
    
    
    h = figure('color', 'white');
    plot(dftTac);
    
    
    saveas(h, ['.\dft\dft_tac_', filePathList{iFile}(end-27:end-4)]);
    
    
    
   
    
    
    close(h);
    
end

rmpath('./Lib/');



