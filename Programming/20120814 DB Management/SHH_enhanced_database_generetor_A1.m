% Project : Sherlock Holmes - EDatabase generator (Alpha 1)
% 2012.08.15 - 2012.08.16
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Todo : 
% - Database version number is not the same for all file! 
%   Use SHH_set_database(dbPath, fileToEditList, fieldToEdit, newValue)

% Log :
% A1 2012.08.15 - 2012.08.16
%   - Create function

close all;
clear all;
clc; 

 % Step 1
 % View starts and stops of all files
 % Step 2
 % View starts and stops of all files
 % Step 2.1
 % View starts and stops of step 2.1 files
scriptIdToExecute = [1, 0, 1, 0, 0, 0];


%% Script parameters

%%% Parameters for step 1 : extract usefull files from unused ones, format data to a usefull format,
%   add mutliple informations with data (acquisition parameters, type of data, etc.)
SOURCE_DATABASE_PATH   = 'd:\Work\Projects\Ongoing\ABP011 2011-201x Sherlock Holmes\Database\Sounds\20111100_ARH\ARH_DB1\';
ENHANCED_DATABASE_PATH = 'd:\Work\Projects\Ongoing\ABP011 2011-201x Sherlock Holmes\Database\Sounds\20111100_ARH\ARH_DB5_1\';
ENHANCED_DATABASE_VERSION = 5.0;
N_PARTNERS = 9;

F_MVT_LIST          = [3, 4, 4, 5, 4, 4, 4, 2.5, 4];
LIFT_ANGLE_LIST     = [51, 51, 51, 52, 49, 47, 52, 44, 50];
MVT_STATUS_LIST     = {'Without default', 'Missing lubrification', 'Off center balance-spring', ...
                       'Drop on pallet stone'};
DEFAULT03_ID_LIST   = [1, 0, 2, 2, 1, 3, 2, 3, 2];
DEFAULT03_PALLET_NAME_LIST = {'In', '-', 'Out', 'Out', 'In', 'Both', 'Out', 'Both', 'Out'};
REG_QUERY1          = 'P[0-9]{2}+_M[0-9]{2}+_E[0-3]{2}+_N[0-9]{2}+_T(1800|0030)+.mat';
REG_QUERY2          = 'P[0-9]{2}+_M[0-9]{2}+_E[0-3]{2}+_N(00)+_T(1800|0030)+.mat';


%%% Parameters for step 2 : cut beginnings and/or endings of signals difficult to handle. Those 
%   parameters have been chosen by looking to all files with function SHH_view_files_start_and_stop.
FILE_TO_CUT_ID = {[5, 6, 8, 9, 12], ...
                  [1], ...
                  [1, 7, 8, 10], ...
                  [4, 6, 10, 11], ...
                  [3, 5, 9, 11, 12], ...
                  [4, 5], ...
                  [3, 6, 7, 10], ...
                  [2, 3, 5, 9], ...
                  [3, 5, 6, 7, 9]}; %#ok<NBRAK>

WHERE_TO_CUT =   {['L', 'L', 'L', 'F', 'L'], ...
                  ['L'], ...
                  ['L', 'L', 'B', 'F'], ...
                  ['B', 'L', 'L', 'L'], ...
                  ['F', 'L', 'F', 'L', 'B'], ...
                  ['L', 'B'], ...
                  ['L', 'L', 'B', 'L'], ...
                  ['L', 'B', 'L', 'B'], ...
                  ['F', 'F', 'L', 'F', 'L']}; %#ok<NBRAK>
              
              
%%% Parameters for step 2.1 : cut beginnings and/or endings of signals difficult to handle. Those 
%   parameters have been chosen by looking to the file. The semi-automatic way of doing it in step 2
%   is not enough to handle those case. The cuting parameters are given by hand, by looking to all
%   files start and stop with the function SHH_view_files_start_and_stop.
FILE_TO_CUT_ID_2 = {[], ...
                    [], ...
                    [], ...
                    [], ...
                    [11, 12], ...
                    [], ...
                    [], ...
                    [], ...
                    [5]}; %#ok<NBRAK>
                
WHERE_TO_CUT_2   = {[], ...
                    [], ...
                    [], ...
                    [], ...
                    ['L', 'L'], ...
                    [], ...
                    [], ...
                    [], ...
                    ['B']}; %#ok<NBRAK>
              
N_SAMPLE_TO_CUT = [0, 1426; 0, 1557; 6902, 16776037];

              

%% Globals
[st, ~] = dbstack;



%% SCRIPT : create enhanced database (step 1)
if scriptIdToExecute(1) == true,
    disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start  "', st(1).name, '" (Step 1)']);

    % Prepare additionnal data to be store with the signal
    databaseVersion = ENHANCED_DATABASE_VERSION;
    nCutSamples     = [0, 0];

    for iPartner = 1 : N_PARTNERS,

        %%% Create partener folder
        processedFolderName      = ['P0', num2str(iPartner)];
        sourceFolderPath         = [SOURCE_DATABASE_PATH, processedFolderName, '/'];
        destinationFolderPath    = [ENHANCED_DATABASE_PATH, processedFolderName, '/'];
        [processStatus, message] = mkdir(destinationFolderPath); 


        %%% Extract element names present in actual folder
        item     = dir(sourceFolderPath); % Extract all items properties
        itemName = {item.name}';          % Extract items names
        nItem    = length(itemName);    


        %%% Select only mat-file with "Ppp_Mmm_Eee_Nnn_Ttt.mat" structure with
        % pp = [00-09], mm = [0-9], ee = [0-3], nn = [1-12], tt = [1800, 0030]
        regAnswer1       = regexp(itemName, REG_QUERY1);
        regAnswer2       = regexp(itemName, REG_QUERY2);

        for iItem = 1 : nItem,
            if ~isempty(regAnswer2{iItem}),
                regAnswer1{iItem} = [];
            end
        end
        nFileToProcess  = length([regAnswer1{:}]);


        %%% Keep only file name with desired structure
        iFileToProcess       = 0;                       % init loop
        namesOfFileToProcess = cell(nFileToProcess, 1); % Prealloc

        for iItem = 1 : nItem, 
            if ~isempty(regAnswer1{iItem}),
                iFileToProcess = iFileToProcess + 1;
                namesOfFileToProcess{iFileToProcess} = itemName{iItem};
            end
        end

        % Prepare additionnal data to be store with the signal
        fMvt                = F_MVT_LIST(iPartner);
        liftAngle           = LIFT_ANGLE_LIST(iPartner);
        default03Id         = DEFAULT03_ID_LIST(iPartner);
        default03PalletName = DEFAULT03_PALLET_NAME_LIST{iPartner};
        partnerId           = iPartner;

        %%% Convert original data format to desired format and this new file into an up-to-date 
        % mat-file (vers. 7.3).
        hWaitbar = waitbar(1/(nFileToProcess+1), ...
                   sprintf('Please wait. Processing file 1/%d...', nFileToProcess));

        for iFileToProcess = 1 : nFileToProcess,

            % Load variable of interest
            load([sourceFolderPath, namesOfFileToProcess{iFileToProcess}], 'Data1_AI_7', 'Sample_rate'); 

            % Convert variable in usefull format
            fs                  = double(Sample_rate);    clear Sample_rate;
            signal              = double(Data1_AI_7(:))'; clear Data1_AI_7;

            % Normalize signal between -1 and 1
            normFactor          = max(abs(signal));
            signal              = signal ./ normFactor;

            % Prepare additionnal data to be store with the signal
            mvtStatusId         = str2double(namesOfFileToProcess{iFileToProcess}(10:11));
            mvtStatusName       = MVT_STATUS_LIST{mvtStatusId + 1};
            fileId              = iFileToProcess;

            % Save extracted data in correct format (.mat vers. 7.3)
            save([destinationFolderPath, namesOfFileToProcess{iFileToProcess}(1:end-4), '.mat'], ...
                 'signal', 'fs', 'fMvt', 'liftAngle', 'default03Id', 'default03PalletName', ...
                 'nCutSamples', 'mvtStatusId', 'mvtStatusName', 'partnerId', 'fileId', ...
                 'databaseVersion', ...
                 '-mat', '-v7.3');

            clear signal fs;

            waitbar(iFileToProcess/(nFileToProcess+1), hWaitbar, ...
                sprintf('Please wait. Processing file %d/%d...', iFileToProcess, nFileToProcess));

        end
        
        %%%
        close(hWaitbar);
        fprintf('Conversion ''%s'' finished.\n', processedFolderName);
    end
    
    %%%
    disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st(1).name, '" (Step 1)']);
end



%% Take a look to beginnings and endings of all signals
if scriptIdToExecute(2) == true,
    SHH_view_files_start_and_stop(DATABASEPATH);
end



%% SCRIPT : create enhanced database (step 2)
if scriptIdToExecute(3) == true,
    disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start  "', st(1).name, '" (Step 2)']);

    %%% load all matObj
    [matObj, nFileToCut] = SHH_get_matObj(FILE_TO_CUT_ID, ENHANCED_DATABASE_PATH);
    
    %%% Reformat WHERE_TO_CUT
    whereToCut = [WHERE_TO_CUT{:}];
    
    %%%
    hWaitbar = waitbar(0/nFileToCut, ...
                       sprintf('Please wait. Processing file 1/%d...', nFileToCut));
    
    for iFileToCut = 1 : nFileToCut,
        waitbar((iFileToCut-1)/nFileToCut, hWaitbar, ...
                sprintf('Please wait. Processing file %d/%d...', iFileToCut, nFileToCut));
        
        % Set matObj to read and write
        matObj{iFileToCut}.Properties.Writable = true;
            
        % Load variable of interest
        fs      = matObj{iFileToCut}.fs;
        fMvt    = matObj{iFileToCut}.fMvt;

        lSignal = size(matObj{iFileToCut}, 'signal', 2);
        shift = ceil(fs/(fMvt*4));
        switch whereToCut(iFileToCut), % F = first, L = last, B = both
            case 'F',  newSignalDelim = shift:lSignal;
                       matObj{iFileToCut}.nCutSamples = matObj{iFileToCut}.nCutSamples + [shift-1, 0];
            case 'L',  newSignalDelim = 1:lSignal-shift;
                       matObj{iFileToCut}.nCutSamples = matObj{iFileToCut}.nCutSamples + [0, shift];
            case 'B', newSignalDelim = shift:lSignal-shift;
                       matObj{iFileToCut}.nCutSamples = matObj{iFileToCut}.nCutSamples + [shift-1, shift];
            otherwise, error('');
        end
        matObj{iFileToCut}.signal           = matObj{iFileToCut}.signal(1, newSignalDelim);
        matObj{iFileToCut}.databaseVersion  = matObj{iFileToCut}.databaseVersion + 0.1;

        % Set matObj to read only
        matObj{iFileToCut}.Properties.Writable = false;
            
    end
    
    %%% 
    close(hWaitbar);
    disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st(1).name, '" (Step 2)']);
end




%% Take a look to beginnings and endings of all signals
if scriptIdToExecute(4) == true,
    SHH_view_files_start_and_stop(DATABASEPATH);
end




%% SCRIPT : create enhanced database (step 2.1)
if scriptIdToExecute(5) == true,
    disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start  "', st(1).name, '" (Step 2.1)']);

	%%% load all matObj
    [matObj, nFileToCut] = SHH_get_matObj(FILE_TO_CUT_ID_2, ENHANCED_DATABASE_PATH);
    
    %%%
    hWaitbar = waitbar(0/(nFileToCut), ...
                       sprintf('Please wait. Processing file 1/%d...', nFileToCut));
    
    for iFileToCut = 1 : nFileToCut,
        waitbar((iFileToCut-1)/nFileToCut, hWaitbar, ...
                sprintf('Please wait. Processing file %d/%d...', iFileToCut, nFileToCut));
        
        % Set matObj to read and write
        matObj{iFileToCut}.Properties.Writable = true;
            
        % Load variable of interest
        shiftF = N_SAMPLE_TO_CUT(iFileToCut, 1);
        shiftL = N_SAMPLE_TO_CUT(iFileToCut, 2);
        
        switch whereToCut(iFileToCut), % F = first, L = last, B = both
            case 'F',  newSignalDelim = shiftF:lSignal;
                       matObj{iFileToCut}.nCutSamples = matObj{iFileToCut}.nCutSamples + [shiftF-1, 0];
            case 'L',  newSignalDelim = 1:lSignal-shiftL;
                       matObj{iFileToCut}.nCutSamples = matObj{iFileToCut}.nCutSamples + [0, shiftL];
            case 'B', newSignalDelim = shiftF:lSignal-shiftL;
                       matObj{iFileToCut}.nCutSamples = matObj{iFileToCut}.nCutSamples + [shiftF-1, shiftL];
            otherwise, error('');
        end
        
        matObj{iFileToCut}.signal           = matObj{iFileToCut}.signal(1, newSignalDelim);
        matObj{iFileToCut}.databaseVersion  = matObj{iFileToCut}.databaseVersion + 0.1;

        % Set matObj to read only
        matObj{iFileToCut}.Properties.Writable = false;
            
    end
    
    %%% 
    close(hWaitbar);
    disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st(1).name, '" (Step 2.1)']);
end



%% Take a look to beginnings and endings of all signals
if scriptIdToExecute(6) == true,
    SHH_view_files_start_and_stop(DATABASEPATH, FILE_TO_CUT_ID_2);
end


% eof