
close all;
clc;
clear all;

addpath('./Lib/');

folderPath = '../../Base_de_donnees/20111100_Witschi_DB1/P01/V1.2';
[filePathList, nFileTot] = load_file_path_list(folderPath);
for iFile = 2,
%     iFile = 1;
    
    
    matObj = matfile(filePathList{iFile});
    
    fs = matObj.fs;
    signal = matObj.signalPzt(1, 1:fs);
    
    
    N = 1024;
    [STFTpos, CIFpos, LGDpos, f, t, tremap] = Nelsonspec(signal, fs, N, N*10/16, N, 0, fs/2, -50);
    
    
    STFTmag = abs(STFTpos); % magnitude of STFT
    STFTmag = STFTmag ./ max(max(STFTmag)); % normalize so max magnitude will be 0 db
    STFTmag = 20*log10(STFTmag); % convert to log magnitude, decibel scale

    plot_these = find(STFTmag >= -50 & 0 <= CIFpos & CIFpos <= fs/2 );
    STFTplot = STFTmag(plot_these);
    CIFplot = CIFpos(plot_these);
    tremap = tremap(plot_these);
    plotpoints = [1000*tremap(:), CIFplot(:), STFTplot(:)];
    
    
    h = figure('color', 'white');
    scatter3(plotpoints(:, 1), plotpoints(:, 2)/1e3, plotpoints(:, 3), 4, plotpoints(:, 3), 'filled');
    view(0, 90);

    %axis xy;
    % colormap(flipud(gray(256)));
%     colormap(myjet);
    %colormap(flipud(autumn));

    % hold on;
    % end
    xlabel('Time [ms]');%,'FontName','times','FontSize',14)
    ylabel('Frequency [kHz]');%,'FontName','times','FontSize',14)
%     set(gca,'FontName','FixedWidth','FontSize',12)
    
    
    
   
    saveas(h, ['.\stdft_reass\stdft_reass__', filePathList{iFile}(end-27:end-4)]);
    
%     close(h);
    
end



rmpath('./Lib/');



