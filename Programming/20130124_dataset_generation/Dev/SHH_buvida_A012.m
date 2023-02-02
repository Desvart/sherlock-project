function SHH_buvida
% SCRIPT - Build a Matlab ViSo dataset from splitted ViSo mat-file and metadata collected from
% various places.
%
% Script parameters :
% PROJECT_PATH                  Project path
% DATABASE_RPATH                Database relative path (relative to project path)
% FILE_NAME_STRUCT              Stucture of file name where xx is the place for movement index and
%                               yy the one for 'balancier' level.
%                               Default value : 'ML0156-xxc_R00_Byy_N01.mat'
% SAVE_FILE_NAME                Full name of output mat-file where dataset is stocked.
% TIME_BASE_CORRECTION_FACTOR   Factor to adapt tag time base. This allows to plot signal in a time
%                               base (the camera time base for example) and to save tags in another 
%                               time base (signal time base). 
%                               Default value : 0.99471
% N_MOVEMENTS                   Number of movement to analysis.
%                               Default value : 3
% N_BARILLET_LEVELS             Number of 'barillet' level
%                               Default value : 6
% POINTAGE                      Movement 'pointage'
%                               Default value : [15, 3.62, 4.95]
% BALANCIER_AMPLITUDE_ARRAY     Array of 'balancier' amplitude for each movement and at each
%                               'barillet' level.
% DATASET_METADATA              Various meta data store in a cell array. Each line of the cell array
%                               is associated at one sound signal.
% DATASET_DESCRIPTION           Generic description of the dataset.
% VERBOSE                       If true display additionnal informations on command windows durant
%                               script execution.
%                               Default value : true
%
% See also dataset, s2hms
% Subfunctions : BUVIDA_build_file_name

% Project   : Sherlock Holmes (ShH) - Build ViSo Dataset (BuViDa)
% � 2012-2015 Pitch
%   Author  : Pitch

% Log
% 2013.01.25	[B1.0][A0.1.2] Bugfixes and docs:
%               - Various bugfixes
%               - Write comments
% 2013.01.24	[A0.1.1] Add minor functionality:
%               - Display informations in Matlab command window to follow script execution.
% 2013.01.23	[A0.1.0] Modify existing functionality:
%               - Add new variables in dataset (mvtFreq, pointage, balancierAmplitude, 
%                 acquisitionConditions)
% 2013.01.22	[A0.0.0] File creation.


% To do (or could be done)
% - 

% To fix
% -


    %% Clean Matlab environment
    clear all;
    close all;
    clc;
    
    
    %% Script parameters

    PROJECT_PATH     = '.\\Ongoing\ABP011_Sherlock_Holmes\';
    DATABASE_RPATH   = 'Data\Videos\ViSo\ViSo_2_0\ML_Influence_du_barillet\';
    FILE_NAME_STRUCT = 'ML0156-xxc_R00_Byy_N01.mat';
    
    SAVE_FILE_NAME   = 'visoBarilletDataset.mat';
    
    TIME_BASE_CORRECTION_FACTOR  = 0.99471; % - (ratio)
    
    N_MOVEMENTS       = 3;
    N_BARILLET_LEVELS = 6;
    
    POINTAGE = [15, 3.62, 4.95]; % #tooth/mm/mm
    BALANCIER_AMPLITUDE_ARRAY = [258.75, 303.75, 315.00, 326.25, 326.25, 337.50, ...
                                 213.75, 258.75, 270.00, 292.50, 303.75, 315.00, ...
                                 258.75, 292.50, 281.25, 315.00, 315.00, 326.25]; % deg. �
    
    DATASET_METADATA = ...
        {'mvtId',               'Name of the movement.',                ''; ...
         'barilletLevel',       '''Barillet'' level',                   '#turns'; ...
         ...
         'mvtFreq',             'Movement frequency.',                  'Alternance/hour (alt/h)'; ...
         'pointage',            'Theoretical ''pointage'' of movement', '[dent/mm/mm]'; ...
         'balancierAmplitude',  'Maximum amplitude of ''balancier.''',  '�'; ...
         ...
         'timestamp',           'Acquisition timestamp',                'Second [s]'; ...
         'timeBaseCorrFactor',  'Correction factor between video time-base and sound time-base.', ...
                                                                        'ratio [-]'; ...
         'signal',              'Sound signal',                         'Amplitude [Pa]'; ...
         'fs',                  'Signal sampling rate',                 'Samples/second [S/s]'; ...
         'normFactor',          'Signal normalization factor',          'Second [s]'; ...
         'timeAxis',            'Signal time axis from MMC-DSH DAQ.',   'Second [s]'};
     
    DATASET_DESCRIPTION = ...
        ['Sound part of ViSo data acquired on movments ML156-0xc. This dataset is focused on', ...
         ' the barillet level variation. Each movement has been acquired at different barillet', ...
         ' level to see if this parameter change something detectable on the sound signal.'];
     
     VERBOSE = true;
     
     
	%% Init script
    
    dateStr = datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF');
    dispStr = '%s - Script takes control (T = 00:00:00.000).\n\n';
    dispv(dispStr, dateStr, VERBOSE); 
    startTic = tic();
    
    nFiles = N_MOVEMENTS * N_BARILLET_LEVELS;
    
    % Init dataset
    VisoBarilletDataset = '';
    
    
    %% Core function
    % Extract all data and metadata for each ViSo sound signal and store them in a dataset.
    
    for movementId = 1 : N_MOVEMENTS,
        for barilletLevel = 1 : N_BARILLET_LEVELS,
    
            iFile = (movementId-1)*N_BARILLET_LEVELS + barilletLevel;
            
            dispStr = 'Mvt%d B%d (%02d/%d) : Processing signal (Total time : %01.3f s).\n';
            dispv(dispStr, movementId, barilletLevel, iFile, nFiles, toc(startTic), VERBOSE);
            
            % Load signal sound
            fileName = BUVIDA_build_file_name(FILE_NAME_STRUCT, movementId, barilletLevel);
            fileFPath = [PROJECT_PATH, DATABASE_RPATH, fileName];
            load(fileFPath);

            % Save signal sound and metadata in a dataset
            fileId = {sprintf('ML156-%02dc', movementId)};
            acquisitionCondition = str2double(fileName(17:18));
            NewDataset = dataset(fileId, acquisitionCondition, ...
                                 18000, POINTAGE, BALANCIER_AMPLITUDE_ARRAY(iFile), ...
                                 timestamp, TIME_BASE_CORRECTION_FACTOR, ...
                                 signal, fs, normFactor, timeAxis, ... 
                                 'ObsNames', sprintf('%d%d', movementId, barilletLevel), ...
                                 'VarNames', DATASET_METADATA(:, 1));
            VisoBarilletDataset = [VisoBarilletDataset; NewDataset];
                
            % Set variables description
            varDescription = DATASET_METADATA(:, 2);
            VisoBarilletDataset = set(VisoBarilletDataset, 'VarDescription', varDescription);
            
            % Set variables units
            units = DATASET_METADATA(:, 3);
            VisoBarilletDataset = set(VisoBarilletDataset, 'Units', units);
            
            % Set dataset description
            VisoBarilletDataset = set(VisoBarilletDataset, 'Description', DATASET_DESCRIPTION);
            
        end
    end
    
    
    %% Save dataset in mat-file and then display closing string
    
    dispStr = '\n Save datascript to %s mat-file (Total time : %01.3f s).\n';
    dispv(dispStr, SAVE_FILE_NAME, s2hms(toc(startTic)), VERBOSE);
    
    save(SAVE_FILE_NAME, 'VisoBarilletDataset');

    dispStr = '\n%s - Script releases control (%s).\n';
    dateStr = datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF');
    dispv(dispStr, dateStr, s2hms(toc(startTic)), VERBOSE);
    
end % Main function - create_viso_dataset



function fileName = BUVIDA_build_file_name(fileNameStruct, movementId, barilletLevel)

    movementIdPos    = fileNameStruct == 'x';
    barilletLevelPos = fileNameStruct == 'y';
    
    fileName                   = fileNameStruct;
    fileName(movementIdPos)    = sprintf('%02d', movementId);
    fileName(barilletLevelPos) = sprintf('%02d', barilletLevel);

end % Sub-function - BUVIDA_build_file_name

% eof
