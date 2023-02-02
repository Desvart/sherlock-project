%%% Main 01 : Analyse des fichiers exportés par le LEMA

clear all; close all; clc;

for iFile = 3 : 2 : 11,
    matObj = load(['Data/Default', num2str(iFile), '.mat'], ['SDefault_', num2str(iFile), '_SamplingFreq'], ['SDefault_', num2str(iFile)]);
    signal = double(eval(['matObj.SDefault_', num2str(iFile)]));
    fs = eval(['matObj.SDefault_', num2str(iFile), '_SamplingFreq']);

    save(['Data/signal', num2str((iFile-1)/2), '.mat'], 'signal', 'fs');
end
