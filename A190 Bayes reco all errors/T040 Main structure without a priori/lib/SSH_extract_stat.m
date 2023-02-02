% 

% Author	: Pitch
% Dev. on   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64

% History
% [Major.Minor.Revision.Build]
% 1.0.b0.0103
% 0.0.a0.0000 - 2013.06.17



%% Clean Matlab environment

close all;
clear all;
clc;

addpath('.\lib\');



%% Script parameters

%%% Path
PROJECT_ROOT_PATH   = '.\\Sherlock Holmes PF11\';
DATABASE_PATH       = [PROJECT_ROOT_PATH, 'Data\Database\ML\subDB ML_loop\'];
ACTIVITY_PATH       = [PROJECT_ROOT_PATH, 'Activities\A080 Build statistical graphs of ML_loop\'];
TASK_PATH           = [ACTIVITY_PATH, 'T020 Script to extract useful stat\'];
DATA_PATH           = [TASK_PATH, 'data\'];

%%% Input and output file names
XLS_FILE_FNAME      = 'ML_loop_DB_desc_2.xlsx';

%%% XLS file structure
XLS_TAG_SHEET       = 5;
XLS_RANGE           = 'A1:L389';
XLS_HEADER          = {'tocId', 'unlockStartIdx', 'nUnlockBounces', 'unlockDropIdx',    ...
                       'impStartIdx', 'impDropIdx', 'dropStartIdx', 'lostPathIdx',      ...
                       'dropBounce1Idx', 'dropBounce2Idx', 'pulseInterToc', 'isTic'};

%%% Data structure
N_FILES             = 30;
N_MVTS              = 4;
N_BARREL_LEVELS     = 2;
N_ERRORS            = 3;
N_TOCS_PER_FILE     = 10;



%% Init script

%%% Start text
fprintf('START STAT EXTRACTION\n\n');

%%% Extract data from excel file
xlsFileFPath        = [DATABASE_PATH, XLS_FILE_FNAME];
[~, ~, raw]         = xlsread(xlsFileFPath, XLS_TAG_SHEET, XLS_RANGE);



%%

%%% Prealloc.
dist24  = zeros(150, 2);    % Dist. between unlocking start and unlocking drop
dist27  = zeros(150, 2);    % Dist. between unlocking start and drop start
dist221 =   nan(150, 2);     % Dist. between unlocking start and next unlocking start
dist222 =   nan(150, 2);     % Dist. between unlocking start and next unlocking of same toc

maxR27  = zeros(150, 2);    % Relative maximum between unlocking max and drop max
maxR57  = zeros(150, 2);    % Relative maximum between impulse max and drop max
max2    = zeros(150, 2);    % Absolute unlocking maximum
max5    = zeros(150, 2);    % Absolute impulse maximum
max7    = zeros(150, 2);    % Absolute drop maximum

std2    = zeros(150, 2);    % Standard deviation around 0 of unlocking
std456  = zeros(150, 2);    % Standard deviation around 0 of unlocking drop
std78   = zeros(150, 2);    % Standard deviation around 0 of drop

e0      = zeros(150, 2);    % Energy abs toc
e2      = zeros(150, 2);    % Energy abs unlocking
e456    = zeros(150, 2);    % Energy abs unlocking drop
e78     = zeros(150, 2);   % Energy abs drop

eR20    = zeros(150, 2);    % Energy rel unlocking
eR4560  = zeros(150, 2);    % Energy rel unlocking drop
eR780   = zeros(150, 2);    % Energy rel drop



for iFile = 1 : N_FILES,
    
    fileNameXlsLine     = 1 + (iFile-1)*(N_TOCS_PER_FILE + 3);
    fileName            = raw{fileNameXlsLine, 1};
    fileFName           = [fileName, '.mat'];
    fileFPath           = [DATABASE_PATH, fileFName];
    
    matObj              = matfile(fileFPath);
    fs                  = matObj.fs;
    
    fileFirstTocLine    = 3 + (iFile-1)*(N_TOCS_PER_FILE + 3);
    
    
    %% Stat : distance between unlocking start (2) and unlocking drop (4)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist24(distIdx, tocFlag)     = raw{tocLine, 4} - raw{tocLine, 2};
    end
    
    
    %% Stat : distance between unlocking start step (2) and drop start step (7)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist27(distIdx, tocFlag)     = raw{tocLine, 7} - raw{tocLine, 2};   
    end
    
    
        %% Stat : distance between unlocking start step (2) and next unlocking start (2)
    
    for iToc = 1 : N_TOCS_PER_FILE-2,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*(N_TOCS_PER_FILE) + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist221(distIdx, tocFlag)     = raw{tocLine+1, 2} - raw{tocLine, 2};   
    end
    
    
    %% Stat : distance between unlocking start step (2) and next unlocking start of same toc (2)
    
    for iToc = 1 : N_TOCS_PER_FILE-2,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*(N_TOCS_PER_FILE) + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist222(distIdx, tocFlag)     = raw{tocLine+2, 2} - raw{tocLine, 2};
    end
    
    
    %% Stat : relative unlocking and impulse max : unlocking max (2-4) / drop max (7-8) && impulse max (5-6) / drop max (7-8)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       maxAbsIdx            = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       maxIdx               = floor(maxAbsIdx/2) + 1;
       tocFlag              = mod( maxAbsIdx, 2 ) + 1;
       
       maxMes2Idx            = raw{tocLine, 2} : raw{tocLine, 4};
       if isnan(maxMes2Idx),
           maxMes2Idx = raw{tocLine, 2} : round(raw{tocLine, 2} + 3.25e-3*fs); % 3.25 is the mean of all distance 2-4
       end
       maxMes2               = max(abs(matObj.signal(1, maxMes2Idx)));
       maxMes2Real           = maxMes2 * matObj.signalNormFactor;
       
       maxMes5Idx            = raw{tocLine, 5} : raw{tocLine, 6};
       if isnan(maxMes5Idx),
           maxMes5Idx = raw{tocLine, 5} : round(raw{tocLine, 5} + 3.57e-3*fs); % 3.57 is the mean of all distance 5-6
       end
       maxMes5               = max(abs(matObj.signal(1, maxMes5Idx)));
       maxMes5Real           = maxMes5 * matObj.signalNormFactor;
       
       maxRefIdx            = raw{tocLine, 7} : raw{tocLine, 8};
       if isnan(maxRefIdx),
           maxRefIdx = raw{tocLine, 7} : round(raw{tocLine, 7} + 1.425e-3*fs); % 1.425 is the mean of all distance 7-8
       end
       maxRef               = max(abs(matObj.signal(1, maxRefIdx)));
       maxRefReal           = maxRef * matObj.signalNormFactor;
       
       maxR27(maxIdx, tocFlag)  = maxMes2 / maxRef * 100;
       maxR57(maxIdx, tocFlag)  = maxMes5 / maxRef * 100;
       max2(maxIdx, tocFlag)    = maxMes2Real;
       max5(maxIdx, tocFlag)    = maxMes5Real;
       max7(maxIdx, tocFlag)    = maxRefReal;
    end
    
    
    %% Stat : variability of each toc, each unlocking, each impulse and each droping

    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       
       std2Idx            = raw{tocLine, 2} : raw{tocLine, 4};
       if isnan(std2Idx),
           std2Idx = raw{tocLine, 2} : round(raw{tocLine, 2} + 3.25e-3*fs); % 3.25 is the mean of all distance 2-4
       end
       std2(distIdx, tocFlag) = std(matObj.signal(1, std2Idx));
       
       std4Idx            = raw{tocLine, 4} : raw{tocLine, 7};
       if isnan(std4Idx),
           std4Idx = raw{tocLine, 4} : round(raw{tocLine, 4} + 1331); % 1331 is the mean of all distance 4-7
       end
       if isnan(std4Idx),
           std4Idx = round(raw{tocLine, 7} - 1331 : raw{tocLine, 7}); % 1331 is the mean of all distance 4-7
       end
       std456(distIdx, tocFlag) = max(abs(matObj.signal(1, std4Idx)));
       
       std7Idx            = raw{tocLine, 7} : raw{tocLine, 9};
       if isnan(std7Idx),
           std7Idx = raw{tocLine, 7} : round(raw{tocLine, 7} + 3.8e-3*fs); % 3.8 is the mean of all distance 7-9
       end
       std78(distIdx, tocFlag) = std(matObj.signal(1, std7Idx));
       
    end
    
    
    %% Stat : energy of element
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       
       e0Idx            = raw{tocLine, 2} : raw{tocLine, 9};
       if isnan(e0Idx),
           e0Idx = raw{tocLine, 2} : round(raw{tocLine, 7} + 3.8e-3*fs); % 3.8 is the mean of all distance 7-9
       end
       e0(distIdx, tocFlag) = sum(abs(matObj.signal(1, e0Idx)));
       
       e2Idx            = raw{tocLine, 2} : raw{tocLine, 4};
       if isnan(e2Idx),
           e2Idx = raw{tocLine, 2} : round(raw{tocLine, 2} + 3.25e-3*fs); % 3.25 is the mean of all distance 2-4
       end
       e2(distIdx, tocFlag) = sum(abs(matObj.signal(1, e2Idx)));
       eR20(distIdx, tocFlag) = e2(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
       e4Idx            = raw{tocLine, 4} : raw{tocLine, 7};
       if isnan(e4Idx),
           e4Idx = raw{tocLine, 4} : round(raw{tocLine, 4} + 1331); % 1331 is the mean of all distance 4-7
       end
       if isnan(e4Idx),
           e4Idx = round(raw{tocLine, 7} - 1331 : raw{tocLine, 7}); % 1331 is the mean of all distance 4-7
       end
       e456(distIdx, tocFlag) = sum(abs(matObj.signal(1, e4Idx)));
       eR4560(distIdx, tocFlag) = e456(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
       e78Idx            = raw{tocLine, 7} : raw{tocLine, 9};
       if isnan(e78Idx),
           e78Idx = raw{tocLine, 7} : round(raw{tocLine, 7} + 3.8e-3*fs); % 3.8 is the mean of all distance 7-9
       end
       e78(distIdx, tocFlag) = sum(abs(matObj.signal(1, e78Idx)));
       eR780(distIdx, tocFlag) = e78(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
    end
    
    
    fprintf('Processing file %d.\n', iFile);
end



save('../data/datasetWAP2_PHM.mat',   'dist24',...
                                'dist27',...
                                'dist221',...
                                'dist222',...
                                'maxR27',...
                                'maxR57',...
                                'max2',...
                                'max5',...
                                'max7',...
                                'std2',...
                                'std456',...
                                'std78',...
                                'e0',...
                                'e2',...
                                'e456',...
                                'e78',...
                                'eR20',...
                                'eR4560',...
                                'eR780');


%% Clean Matlab environment

fprintf('\n\nSTOP STAT EXTRACTION\n\n');

rmpath('.\lib\');


%%% eof
