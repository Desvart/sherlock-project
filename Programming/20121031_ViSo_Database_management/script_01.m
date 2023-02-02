% Script
clear all; clc;

% Regroup all files from raw_acquisition folder in one temporary folder. 
% All videos should be concatenate and correctly named and all signals should be also in this folder
% next to his video (i.e. with the same name).
% This folder is temporary since metadata haven't been added for now.



%% Script parameters declaration

PROJECT_PATH            = '.\\Ongoing\ABP011_Sherlock_Holmes\';
DATABASE_PATH           = [PROJECT_PATH, 'Data\'];
RAW_DATABASE_PATH       = [DATABASE_PATH, 'Videos\ViSo\Raw_acquistions\'];
% TMP_DATABASE_PATH       = '.\Temporary\Temp_database_2\';
% TMP_DATABASE_PATH       = '.\Temporary\Temp_database_3\';
TMP_DATABASE_PATH       = [DATABASE_PATH, 'Videos\ViSo\ViSo_2_0\AP_Influence_du_barillet\'];
% FOLDER_TO_PROCESS       = {'20120910'; '20120919'};
FOLDER_TO_PROCESS       = {'20130204'};
% ACQUISITION_STRUCTURE   = '[A-Z]{2}[0-9]{1}[0-9a-z]{1}_R[0-9]{2}_B[0-9]{2}_N[0-9]{2}';
ACQUISITION_STRUCTURE   = 'AP3120-01c_R[0-9]{2}_B[0-9]{2}_N[0-9]{2}';
SOUND_NAME_STRUCTURE    = [ACQUISITION_STRUCTURE, '\.mat'];
VIDEO_NAME_STRUCTURE    = 'video.[0-9]{2}.avi';
OUTPUT_VIDEO_FORMAT     = 'MPEG-4';
VERBOSE                 = true;



%% Create log file

if VERBOSE,
    if exist([TMP_DATABASE_PATH, 'log.txt'], 'file'),
        delete([TMP_DATABASE_PATH, 'log.txt']);
    end
    diary([TMP_DATABASE_PATH, 'log.txt']); 
    dispv('Recording log file : enable.\n', VERBOSE);
    diary on;        
end

clockStr = datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF');
dispv('%s - Script takes control (T = 00:00:00.000).\n\n', clockStr, VERBOSE); 
tic();



%% Create temporary folder

if exist(TMP_DATABASE_PATH, 'dir') == false,
    mkdir(TMP_DATABASE_PATH);
end



%% Compute number of acquisitions to process

% Initialization of the loop 
nTotAcquisitions = 0;
nSessions        = length(FOLDER_TO_PROCESS);

% For each acquisition session (i.e.: for each folder)
for iSession = 1 : nSessions,
    
    sessionPath         = [RAW_DATABASE_PATH, FOLDER_TO_PROCESS{iSession}, '\'];
    sessionSignalPath   = [sessionPath, 'Exports\'];
    [~, nAcquisitions]  = list_folder_inventory(sessionSignalPath, ACQUISITION_STRUCTURE);
    nTotAcquisitions    = nTotAcquisitions + nAcquisitions;
    
end
    
    

%% Start session loop

% Initialization of the loop
iTotAcquisition = 1;

% 
dispv('Start session loop [S].\n', VERBOSE);

% For each acquisition session (i.e.: for each folder)
for iSession = 1 : nSessions,
    
    
    
    %% Build usefull path
    
    sessionPath         = [RAW_DATABASE_PATH, FOLDER_TO_PROCESS{iSession}, '\'];
    sessionVideoPath    = [sessionPath, 'Acquisition\'];
    sessionSignalPath   = [sessionPath, 'Exports\'];
    
    
    
    %% Extract names of all acquisitions
    
    [acquisitionFullNameArray, nAcquisitions] = list_folder_inventory(sessionSignalPath, SOUND_NAME_STRUCTURE);
    splitAcquisitionFullNameArray = split_fullPath_array(acquisitionFullNameArray);
    acquisitionNameArray = splitAcquisitionFullNameArray(:, 2);
    
    
    
    %% Start acquisition loop
    
    dispv('S%d : Start acquisition loop [A].\n\n', iSession, VERBOSE);
    
    for iAcquisition = 1 : nAcquisitions,
%     for iAcquisition = 8 : nAcquisitions,



        %%
        
        dispv('S%d A%d (%d/%d) : Processing acquisition %s (Total time : %s).\n', ...
              iSession, iAcquisition, iTotAcquisition, nTotAcquisitions, ...
              acquisitionNameArray{iAcquisition}, s2hms(toc()), VERBOSE);
        iTotAcquisition = iTotAcquisition + 1;
       
        
        
        %% Process video
        
        toc1 = toc();
        dispv('S%d A%d %s : Processing video : ', ...
              iSession, iAcquisition, acquisitionNameArray{iAcquisition}, VERBOSE);
          
        % Verify if video is splitted
        vidInPath = [sessionVideoPath, acquisitionNameArray{iAcquisition}, '\'];
        vidoFullPath = [TMP_DATABASE_PATH, acquisitionNameArray{iAcquisition}, ''];
        [videoNames, nVideos] = list_folder_inventory(vidInPath, VIDEO_NAME_STRUCTURE);
        switch nVideos,
            case 0,
                error('%s acquisition has no video files (nVideos == 0).', acquisitionNameArray{iAcquisition});
            case 1,
%                 copyfile([vidInPath, videoNames{1}], vidoFullPath);
                vidInFullPath = [vidInPath, 'video.00.avi']; 
                transcode_video_file(vidInFullPath, vidoFullPath, OUTPUT_VIDEO_FORMAT, true, VERBOSE);
                dispv('Copying file... ', VERBOSE);
            case 2,
                vid1FullPath = [vidInPath, 'video.00.avi'];
                vid2FullPath = [vidInPath, 'video.01.avi'];
                concatenate_avi(vid1FullPath, vid2FullPath, vidoFullPath, OUTPUT_VIDEO_FORMAT, VERBOSE);
                dispv('Concatenating and copying file... ', VERBOSE);
            otherwise,
                warning('%s acquisition is too big to be concatenate (nVideos > 2).', acquisitionNameArray{iAcquisition});
        end

        dispv('Step time : %s\n', s2hms(toc() - toc1), VERBOSE);
        
        
        
        %% Process signal
        
        toc1 = toc();
        dispv('S%d A%d %s : Processing signal... ', ...
              iSession, iAcquisition, acquisitionNameArray{iAcquisition}, VERBOSE);
        
        signalFullPath = [sessionSignalPath, acquisitionNameArray{iAcquisition}, '.mat'];
        load(signalFullPath, 'Data1_AI_7', 'Data1_time_AI_7', 'Sample_rate', 'Start_time'); 
         
        % Convert loaded date into more appropriate format
        timestamp       = double(Start_time);           clear Start_time;
        fs              = double(Sample_rate);          clear Sample_rate;
        signal          = double(Data1_AI_7(:))';       clear Data1_AI_7;
        timeAxis        = double(Data1_time_AI_7(:))';  clear Data1_time_AI_7;
        
        matVarInfo = whos(matfile(signalFullPath));
        if strfind([matVarInfo.name], 'Data1_AI_6'),
            load(signalFullPath, 'Data1_AI_6', 'Data1_time_AI_6'); 
            syncOutSignal   = double(Data1_AI_6(:))';       clear Data1_AI_6;
            syncOutTimeAxis = double(Data1_time_AI_6(:))';  clear Data1_time_AI_6;
        else
            syncOutSignal   = zeros(1, length(signal));
            syncOutTimeAxis = zeros(1, length(signal));
        end

        % Normalize signal between -1 and 1
        normFactor  = max(abs(signal));
        signal   	= signal ./ normFactor;

        % Save usefull signal variables into a mat-file.
        save([TMP_DATABASE_PATH, acquisitionNameArray{iAcquisition}, '.mat'], ...
             'signal', 'fs', 'timestamp', 'timeAxis', 'syncOutSignal', 'syncOutTimeAxis', 'normFactor', ...
             '-mat', '-v7.3');
        
        % Delete saved data from workspace.
        clear signal fs timestamp timeAxis syncOutSignal syncOutTimeAxis normFactor; 
        
        dispv('Step time : %s\n\n', s2hms(toc() - toc1), VERBOSE);
        
        
        
    end % end of acquisition loop
    
    dispv('S%d : End of acquisition loop [A] (Total time : %s).\n', iSession, VERBOSE);
    
    
    
end % end of session loop

dispv('End of session loop [S] (Total time : %s).\n', s2hms(toc()), VERBOSE);



%% Last operations


dispv('\n%s - Script releases control (%s).\n', datestr(clock, 'yyyy.mm.dd HH:MM:SS.FFF'), s2hms(toc()), VERBOSE);
if VERBOSE, 
    diary off; 
    dispv('Recording log file : disable.\n', VERBOSE);
end
%eof


