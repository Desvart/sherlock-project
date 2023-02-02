% 

% Author	: Pitch
% Dev. on   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64

% History
% [Major.Minor.Revision.Build]
% 1.0.b3.0418 - Correction of an index error on max6, again. :'-(
% 1.0.b2.0303 - Correction of an index error, again. :'-(
% 1.0.b1.0302 - Correction of an index error on e0Idx. :'-(
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
dist27  = zeros(150, 2);    % Dist. between unlocking start and drop start
% dist221 = zeros(120, 2);     % Dist. between unlocking start and next unlocking start
% dist222 = zeros(120, 2);     % Dist. between unlocking start and next unlocking of same toc
dist221 =   nan(150, 2);     % Dist. between unlocking start and next unlocking start
dist222 =   nan(150, 2);     % Dist. between unlocking start and next unlocking of same toc
dist25  = zeros(150, 2);    % Dist. between unlocking start and impulse start
dist78  = zeros(150, 2);    % Dist. between drop start and lost path start
dist56  = zeros(150, 2);    % Dist. between impulse start and impulse drop
dist24  = zeros(150, 2);    % Dist. between unlocking start and unlocking drop
dist45  = zeros(150, 2);    % Dist. between unlocking drop and impulse start
maxR27  = zeros(150, 2);    % Relative maximum between unlocking max and drop max
maxR57  = zeros(150, 2);    % Relative maximum between impulse max and drop max
max2    = zeros(150, 2);    % Absolute unlocking maximum
max5    = zeros(150, 2);    % Absolute impulse maximum
max7    = zeros(150, 2);    % Absolute drop maximum
maxR45  = zeros(150, 2);    % Relative maximum between unlocking drop max and impulse max
maxR65  = zeros(150, 2);    % Relative maximum between impulse drop max and impulse max
max4    = zeros(150, 2);    % Absolute unlocking drop maximum
max6    = zeros(150, 2);    % Absolute impulse drop maximum
std2    = zeros(150, 2);    % Standard deviation around 0 of unlocking
std4    = zeros(150, 2);    % Standard deviation around 0 of unlocking drop
std5    = zeros(150, 2);    % Standard deviation around 0 of impulse
std6    = zeros(150, 2);    % Standard deviation around 0 of impulse drop
std7    = zeros(150, 2);    % Standard deviation around 0 of drop
e0      = zeros(150, 2);    % Energy abs toc
e2      = zeros(150, 2);    % Energy abs unlocking
e4      = zeros(150, 2);    % Energy abs unlocking drop
e5      = zeros(150, 2);    % Energy abs impulse
e6      = zeros(150, 2);    % Energy abs impulse drop
e7      = zeros(150, 2);    % Energy abs drop
e8      = zeros(150, 2);    % Energy abs lost path
e78     = zeros(150, 2);    % Energy abs drop + lost path
eR20    = zeros(150, 2);    % Energy rel unlocking
eR40    = zeros(150, 2);    % Energy rel unlocking drop
eR50    = zeros(150, 2);    % Energy rel impulse
eR60    = zeros(150, 2);    % Energy rel impulse drop
eR70    = zeros(150, 2);    % Energy rel drop
eR80    = zeros(150, 2);    % Energy rel lost path
eR780   = zeros(150, 2);    % Energy rel drop + lost path
pit     = zeros(150, 2);    % Pulse inter toc
nBounces= zeros(150, 2);    % Number of bounces detected per toc
isTic   = zeros(150, 2);    % isTic

for iFile = 1 : N_FILES,
    
    fileNameXlsLine     = 1 + (iFile-1)*(N_TOCS_PER_FILE + 3);
    fileName            = raw{fileNameXlsLine, 1};
    fileFName           = [fileName, '.mat'];
    fileFPath           = [DATABASE_PATH, fileFName];
    
    matObj              = matfile(fileFPath);
    fs                  = matObj.fs;
    
    fileFirstTocLine    = 3 + (iFile-1)*(N_TOCS_PER_FILE + 3);
    
    
    
    %% Stat : distance between unlocking start step (2) and drop start step (7)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist27(distIdx, tocFlag)     = raw{tocLine, 7} - raw{tocLine, 2};   
    end
    
    
%     %% Stat : distance between unlocking start step (2) and next unlocking start (2)
%     
%     for iToc = 1 : N_TOCS_PER_FILE-2,
%        tocLine              = fileFirstTocLine - 1 + iToc;
%        distAbsIdx           = (iFile-1)*(N_TOCS_PER_FILE-2) + iToc - 1;
%        distIdx              = floor(distAbsIdx/2) + 1;
%        tocFlag              = mod( distAbsIdx, 2 ) + 1;
%        dist221(distIdx, tocFlag)     = raw{tocLine+1, 2} - raw{tocLine, 2};   
%     end
%     
%     
%     %% Stat : distance between unlocking start step (2) and next unlocking start of same toc (2)
%     
%     for iToc = 1 : N_TOCS_PER_FILE-2,
%        tocLine              = fileFirstTocLine - 1 + iToc;
%        distAbsIdx           = (iFile-1)*(N_TOCS_PER_FILE-2) + iToc - 1;
%        distIdx              = floor(distAbsIdx/2) + 1;
%        tocFlag              = mod( distAbsIdx, 2 ) + 1;
%        dist222(distIdx, tocFlag)     = raw{tocLine+2, 2} - raw{tocLine, 2};
%     end
    
    
        %% Stat : distance between unlocking start step (2) and next unlocking start (2)
    
    for iToc = 1 : N_TOCS_PER_FILE-2,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*(N_TOCS_PER_FILE) + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist221(distIdx, tocFlag)     = raw{tocLine+1, 2} - raw{tocLine, 2};   
    end
%     dist221 = [dist221; nan, nan];
    
    
    %% Stat : distance between unlocking start step (2) and next unlocking start of same toc (2)
    
    for iToc = 1 : N_TOCS_PER_FILE-2,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*(N_TOCS_PER_FILE) + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist222(distIdx, tocFlag)     = raw{tocLine+2, 2} - raw{tocLine, 2};
    end
%     dist222 = [dist222; nan, nan];
    
    
    %% Stat : distance between unlocking start step (2) and impulse start step (5)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist25(distIdx, tocFlag)     = raw{tocLine, 5} - raw{tocLine, 2};   
    end
    
    
    %% Stat : distance between drop start step (7) and lost path start step (8)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist78(distIdx, tocFlag)     = raw{tocLine, 8} - raw{tocLine, 7};
    end
    
    
    %% Stat : distance between impulse start step (5) and impulse drop step (6)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist56(distIdx, tocFlag)     = raw{tocLine, 6} - raw{tocLine, 5};
    end
    
    
    %% Stat : distance between unlocking start (2) and unlocking drop (4)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist24(distIdx, tocFlag)     = raw{tocLine, 4} - raw{tocLine, 2};
    end
    
    
    %% Stat : distance between unlocking drop (4) and impulse start(5)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       distIdx              = floor(distAbsIdx/2) + 1;
       tocFlag              = mod( distAbsIdx, 2 ) + 1;
       dist45(distIdx, tocFlag)     = raw{tocLine, 5} - raw{tocLine, 4};
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
    
    
%% Stat : relative unlockingDrop and impulseDrop max : unlockingDrop max (4-5) / impulse max (5-6) && 
% impulseDrop max (6-7) / drop max (5-6)
    
    for iToc = 1 : N_TOCS_PER_FILE,
       tocLine              = fileFirstTocLine - 1 + iToc;
       maxAbsIdx            = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
       maxIdx               = floor(maxAbsIdx/2) + 1;
       tocFlag              = mod( maxAbsIdx, 2 ) + 1;
       
       maxMes4Idx            = raw{tocLine, 4} : raw{tocLine, 5};
       if isnan(maxMes4Idx),
           maxMes4Idx = raw{tocLine, 4} : round(raw{tocLine, 4} + 0.48e-3*fs); % 0.48 is the mean of all distance 4-5
       end
       if isnan(maxMes4Idx),
           maxMes4Idx = round(raw{tocLine, 5} - 0.48e-3*fs : raw{tocLine, 5}); % 0.48 is the mean of all distance 4-5
       end
       maxMes4               = max(abs(matObj.signal(1, maxMes4Idx)));
       maxMes4Real           = maxMes4 * matObj.signalNormFactor;
       
       maxMes6Idx            = raw{tocLine, 6} : raw{tocLine, 7};
       if isnan(maxMes6Idx),
           maxMes6Idx = raw{tocLine, 6} : round(raw{tocLine, 6} + 2.71e-3*fs); % 2.71 is the mean of all distance 6-7
       end
       if isnan(maxMes6Idx),
           maxMes6Idx = round(raw{tocLine, 7} - 2.71e-3*fs : raw{tocLine, 7}); % 2.71 is the mean of all distance 6-7
       end
       maxMes6               = max(abs(matObj.signal(1, maxMes6Idx)));
       maxMes6Real           = maxMes6 * matObj.signalNormFactor;
       
       maxRefIdx            = raw{tocLine, 5} : raw{tocLine, 6};
       if isnan(maxRefIdx),
           maxRefIdx = raw{tocLine, 5} : round(raw{tocLine, 5} + 3.57e-3*fs); % 3.57 is the mean of all distance 5-6
       end
       maxRef               = max(abs(matObj.signal(1, maxRefIdx)));
       maxRefReal           = maxRef * matObj.signalNormFactor;
       
       maxR45(maxIdx, tocFlag)  = maxMes4 / maxRef * 100;
       maxR65(maxIdx, tocFlag)  = maxMes6 / maxRef * 100;
       max4(maxIdx, tocFlag)    = maxMes4Real;
       max6(maxIdx, tocFlag)    = maxMes6Real;
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
       
       std4Idx            = raw{tocLine, 4} : raw{tocLine, 5};
       if isnan(std4Idx),
           std4Idx = raw{tocLine, 4} : round(raw{tocLine, 4} + 0.48e-3*fs); % 0.48 is the mean of all distance 4-5
       end
       if isnan(std4Idx),
           std4Idx = round(raw{tocLine, 5} - 0.48e-3*fs : raw{tocLine, 5}); % 0.48 is the mean of all distance 4-5
       end
       std4(distIdx, tocFlag) = max(abs(matObj.signal(1, std4Idx)));
       
       std5Idx            = raw{tocLine, 5} : raw{tocLine, 6};
       if isnan(std5Idx),
           std5Idx = raw{tocLine, 5} : round(raw{tocLine, 5} + 3.57e-3*fs); % 3.57 is the mean of all distance 5-6
       end
       std5(distIdx, tocFlag) = std(matObj.signal(1, std5Idx));
       
       std6Idx            = raw{tocLine, 6} : raw{tocLine, 7};
       if isnan(std6Idx),
           std6Idx = raw{tocLine, 6} : round(raw{tocLine, 6} + 2.71e-3*fs); % 2.71 is the mean of all distance 6-7
       end
       if isnan(std6Idx),
           std6Idx = round(raw{tocLine, 7} - 2.71e-3*fs : raw{tocLine, 7}); % 2.71 is the mean of all distance 6-7
       end
       std6(distIdx, tocFlag) = max(abs(matObj.signal(1, std6Idx)));
       
       std7Idx            = raw{tocLine, 7} : raw{tocLine, 9};
       if isnan(std7Idx),
           std7Idx = raw{tocLine, 7} : round(raw{tocLine, 7} + 3.8e-3*fs); % 3.8 is the mean of all distance 7-9
       end
       std7(distIdx, tocFlag) = std(matObj.signal(1, std7Idx));
       
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
       
       e4Idx            = raw{tocLine, 4} : raw{tocLine, 5};
       if isnan(e4Idx),
           e4Idx = raw{tocLine, 4} : round(raw{tocLine, 4} + 0.48e-3*fs); % 0.48 is the mean of all distance 4-5
       end
       if isnan(e4Idx),
           e4Idx = round(raw{tocLine, 5} - 0.48e-3*fs : raw{tocLine, 5}); % 0.48 is the mean of all distance 4-5
       end
       e4(distIdx, tocFlag) = sum(abs(matObj.signal(1, e4Idx)));
       eR40(distIdx, tocFlag) = e4(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
       e5Idx            = raw{tocLine, 5} : raw{tocLine, 6};
       if isnan(e5Idx),
           e5Idx = raw{tocLine, 5} : round(raw{tocLine, 5} + 3.57e-3*fs); % 3.57 is the mean of all distance 5-6
       end
       e5(distIdx, tocFlag) = sum(abs(matObj.signal(1, e5Idx)));
       eR50(distIdx, tocFlag) = e5(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
       e6Idx            = raw{tocLine, 6} : raw{tocLine, 7};
       if isnan(e6Idx),
           e6Idx = raw{tocLine, 6} : round(raw{tocLine, 6} + 2.71e-3*fs); % 2.71 is the mean of all distance 6-7
       end
       if isnan(e6Idx),
           e6Idx = round(raw{tocLine, 7} - 2.71e-3*fs : raw{tocLine, 7}); % 2.71 is the mean of all distance 6-7
       end
       e6(distIdx, tocFlag) = sum(abs(matObj.signal(1, e6Idx)));
       eR60(distIdx, tocFlag) = e6(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
       e7Idx            = raw{tocLine, 7} : raw{tocLine, 8};
       if isnan(e7Idx),
           e7Idx = raw{tocLine, 7} : round(raw{tocLine, 7} + 1.425e-3*fs); % 1.425 is the mean of all distance 7-8
       end
       e7(distIdx, tocFlag) = sum(abs(matObj.signal(1, e7Idx)));
       eR70(distIdx, tocFlag) = e7(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
       e8Idx            = raw{tocLine, 8} : raw{tocLine, 9};
       if isnan(e8Idx),
           e8Idx = raw{tocLine, 8} : round(raw{tocLine, 8} + 3.35e-3*fs); % 3.35 is the mean of all distance 8-9
       end
       if isnan(e8Idx),
           e8Idx = round(raw{tocLine, 9} - 3.35e-3*fs) : raw{tocLine, 9}; % 3.35 is the mean of all distance 8-9
       end
       if isnan(e8Idx),
           e8(distIdx, tocFlag) = nan;
       else
            e8(distIdx, tocFlag) = sum(abs(matObj.signal(1, e8Idx)));
       end
       eR80(distIdx, tocFlag) = e8(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
       e78Idx            = raw{tocLine, 7} : raw{tocLine, 9};
       if isnan(e78Idx),
           e78Idx = raw{tocLine, 7} : round(raw{tocLine, 7} + 3.8e-3*fs); % 3.8 is the mean of all distance 7-9
       end
       e78(distIdx, tocFlag) = sum(abs(matObj.signal(1, e78Idx)));
       eR780(distIdx, tocFlag) = e78(distIdx, tocFlag) / e0(distIdx, tocFlag) * 100;
       
    end
    
    
    %% Stat : pulse inter toc and number of bounce per toc
    
    for iToc = 1 : N_TOCS_PER_FILE,
        tocLine              = fileFirstTocLine - 1 + iToc;
        distAbsIdx           = (iFile-1)*N_TOCS_PER_FILE + iToc - 1;
        distIdx              = floor(distAbsIdx/2) + 1;
        tocFlag              = mod( distAbsIdx, 2 ) + 1;
        
        pit(distIdx, tocFlag)       = raw{tocLine, 11};
        nBounces(distIdx, tocFlag)  = raw{tocLine, 3};            
        isTic(distIdx, tocFlag)     = raw{tocLine, 12};   
    end
    
    fprintf('Processing file %d.\n', iFile);
end



save('../data/datasetCorr4.mat',  'dist27',...
                            'dist221',...
                            'dist222',...
                            'dist25',...
                            'dist78',...
                            'dist56',...
                            'dist24',...
                            'dist45',...
                            'maxR27',...
                            'maxR57',...
                            'max2',...
                            'max5',...
                            'max7',...
                            'maxR45',...
                            'maxR65',...
                            'max4',...
                            'max6',...
                            'std2',...
                            'std4',...
                            'std5',...
                            'std6',...
                            'std7',...
                            'e0',...
                            'e2',...
                            'e4',...
                            'e5',...
                            'e6',...
                            'e7',...
                            'e8',...
                            'e78',...
                            'eR20',...
                            'eR40',...
                            'eR50',...
                            'eR60',...
                            'eR70',...
                            'eR80',...
                            'eR780',...
                            'pit',...
                            'nBounces',...
                            'isTic');


%% Clean Matlab environment

fprintf('\n\nSTOP STAT EXTRACTION\n\n');

rmpath('.\lib\');


%%% eof
