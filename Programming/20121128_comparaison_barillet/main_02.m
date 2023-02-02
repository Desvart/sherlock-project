close all;
clear all;
clc;

PROJECT_PATH  = '.\\Ongoing\ABP011_Sherlock_Holmes\';
DATABASE_RPATH = '.\Data\Videos\ViSo\ViSo_2_0\ML_Influence_du_barillet\';
DATABASE_PATH = [PROJECT_PATH, DATABASE_RPATH];

[fileFullNameArray, nFiles] = list_folder_inventory(DATABASE_PATH, 'ML01_R00_N01_B0[1-6]{1}.mat');

firstDegagementStartFrameArray = [2988, 1333, 2540, 1043, 1899, 2369];
fps = 8550/0.99471;

figure('color', 'white');
hold on;

color = 'bckgyr';

% for iFile = 1 : nFiles,
for iFile = [1, 6],
   
    fileFullName = fileFullNameArray{iFile};
    matObj = matfile([DATABASE_PATH, fileFullName]);
    
    fs     = matObj.fs;
    
    signalFirstIdx = round(firstDegagementStartFrameArray(iFile)/fps*fs) - fs/16;
    signalLastIdx  = signalFirstIdx + round(6870/fps*fs);
    
    signal     = matObj.signal(1, signalFirstIdx:signalLastIdx);
    signalAxis = (0:length(signal)-1)/fs;
    
    plot(signalAxis, signal-0.05+(iFile-1)*0.2, color(iFile));
    axis tight;
    
end
