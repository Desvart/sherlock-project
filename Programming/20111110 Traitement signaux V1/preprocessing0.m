% This script extracts the data of interest from raw files and put them in 
% an easily exploitable format for Matlab and transform them to have an 
% uniform representation across all signals.

% Sherlock Holmes - 2011.11.22
% Pitch Corp.

%%% Init script
close all;
clear all;
clc;
if exist('./Lib', 'dir'), addpath(genpath('Lib')); end


%%% Define global parameters
fineTunningMode = false;

signalDuration = 1;

matFileName = {'omega', 'russisch'};
startFactorMat = [0, 1/20];

wavFileName = 'ETA2801-2_';
startFactorWav = [1/40, 1/40, 1/20, 1/10, 1/40];


%%% Init script
if fineTunningMode,
    figure('color', 'white');
end


%%% Mat signal
nMatFile = length(matFileName);
for iFile = 1 : nMatFile,
    save('workspace.mat');
    load(['Data/Original/', matFileName{iFile}, '.mat'], 'Data1_AI_7', 'Sample_rate', 'Start_time');
    save(['Data/Original/', matFileName{iFile}, '0.mat'], 'Data1_AI_7', 'Sample_rate', 'Start_time', '-v7.3');
    clear all;
    load('workspace.mat'); 
    delete('workspace.mat');
    
    matObj  = matfile(['Data/Original/', matFileName{iFile}, '0.mat']);
    fs = double(matObj.Sample_rate);
    startIdx = max(1, fs*startFactorMat(iFile));
    signal = double(matObj.Data1_AI_7(startIdx : startIdx + signalDuration*fs - 1, 1))';
    
    if fineTunningMode,
        tAxis = (0:length(signal)-1)/fs;
        plot(tAxis*1e3, signal);
        xlabel('Time [ms]');
        title(matFileName{iFile});
        pause;
    else
        save(['Data/', matFileName{iFile}, '1.mat'], 'signal', 'fs');
    end
end


%%% Wav signal
nWavFile = 5;
for iFile = 1 : nWavFile,
    [~, fs] = wavread(['Data/Original/', wavFileName, num2str(iFile), '.wav']);
    startIdx = max(1, fs*startFactorWav(iFile));
    signal = wavread(['Data/Original/', wavFileName, num2str(iFile), '.wav'], [startIdx, startIdx + signalDuration*fs - 1])';
    
    if fineTunningMode,
        tAxis = (0:length(signal)-1)/fs;
        plot(tAxis*1e3, signal);
        xlabel('Time [ms]');
        title([wavFileName, num2str(iFile)]);
        pause;
    else
        save(['Data/', wavFileName, '1_', num2str(iFile), '.mat'], 'signal', 'fs');
    end
end


%%% Close script
if fineTunningMode,
    close all;
end
if exist('./Lib', 'dir'), rmpath(genpath('Lib')); end