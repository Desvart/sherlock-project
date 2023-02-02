% This script creates a database subset based on ML_raw_database. This subset will be used to "loop"
% the Sherlock Holmes project.
% File keepen are the ones from the original acquisitions (sound purpose only) and the one from the 
% video and sound purpose with the barell winding level varying. File name and variable names are 
% changed to be more consistant. Only signal and fs are kept. Signal is the signal file between 
% idealStart and idealStop defined in the ML_raw_database_desc.xlsx file.

% Author : Pitch
% Date   : 2013.05.07 - 2013.05.16



%% Clean workspace

clc;
clear all;
close all;



%% User variables

%%% Path variables
projectRootPath     = '.\\Ongoing\Sherlock Holmes ABP011\';
databaseRootPath    = [projectRootPath, 'Database\ML\'];
rawDatabasePath     = [databaseRootPath, 'Raw\'];           % Input database
newDatabasePath     = [databaseRootPath, 'SubDB ML_loop\']; % Output database

%%% Database file description
xlsDescFileFName    = 'rawDB_desc.xlsx'; % Full name of excel file describing raw database
xlsSheetIdToExtract = 1;
% Headers of column of interest in excel file. First header should be the one that contains the
% data selection.
xlsColName          = {'ML_loop', 'folderName', 'fileName', 'barellLevel', 'Code', ...
                       'idealStart', 'mvtFreq', 'Caliber'}; 
xlsHeaderHeight     = 2; % Number of line of the xls header

%%% Variables name to extract of matfile in raw database
signalVarName       = 'Data1_AI_7'; 
fsVarName           = 'Sample_rate';

%%% Number of tocs to extract
nTocsToKeep         = 10;



%% Anonymous function definition

%%% Give the string version of a variable name. Eg.: 
% >> myVariable = 45;
% >> varName = var_name(myVariable);
% >> disp(varName);
% > myVariable
var_name = @(var) inputname(1); 



%% Extract xlsx data

xlsDescFPath                    = [rawDatabasePath, xlsDescFileFName];  % xlsx full path
[xlsNumExtract, xlsTxtExtract]  = xlsread(xlsDescFPath, xlsSheetIdToExtract);
% Since numbers only start after the header, there is a difference between line numbers in
% xlsNumExtract and xlsTxtExtract. This difference is the header height of the xlsx file. To avoid
% handling this gap, we add some 'nan' lines at the beggining of xlsNumExtract to compensate.
xlsNumExtract                   = [nan(xlsHeaderHeight, size(xlsNumExtract, 2)); ...
                                   xlsNumExtract];


                               
%% Extract usefull column idx

% Init
nColName        = length(xlsColName); % Number of columns to extract
% Prealloc
xlsColIdxArray  = zeros(1, nColName); % Ids of the columns to extract
for iColName = 1 : nColName,
    
    %%% In the xlsTxtExtract array we search (strcmp) for the cell containing the columon header we
    % are looking for. If something is found, we look for the coordinate of this cell (find).
    [~, xlsColIdxArray(iColName)] = find(strcmp(xlsTxtExtract, xlsColName{iColName}));
    
    %%% If nothing is found, stop script.
    if isempty(xlsColIdxArray(iColName)) == true,
        error('Column header ''%s'' not found in %s file.', xlsColName{iColName}, xlsDescFPath);
    end
    
end



%% Determine number of signals to keep and related xls index lines

xlsExtractFlagArray     = xlsNumExtract(:, xlsColIdxArray(1));  % Extract the file selection column 
xlsExtractLineIdxArray  = find(xlsExtractFlagArray==1);         % Extract the lines id of each selected files
nSignalToExtract        = length(xlsExtractLineIdxArray);



%% For each selected signal extract usefull data from xls file

%%% Prealloc
folderNameArray     = zeros(nSignalToExtract, 1);
fileFNameArray      = cell(nSignalToExtract,  1);
barellLevelArray    = cell(nSignalToExtract,  1);
defectsCodeArray    = cell(nSignalToExtract,  1);
idealStartIdxArray  = zeros(nSignalToExtract, 1);
mvtFreqArray        = zeros(nSignalToExtract, 1);
caliberNameArray    = cell(nSignalToExtract,  1);

for iSignal = 1 : nSignalToExtract,
   
    lineIdx                     = xlsExtractLineIdxArray(iSignal);
    folderNameArray(iSignal)    = xlsNumExtract(lineIdx, xlsColIdxArray(2));
    fileFNameArray{iSignal}     = xlsTxtExtract{lineIdx, xlsColIdxArray(3)};
    barellLevelArray{iSignal}   = xlsTxtExtract{lineIdx, xlsColIdxArray(4)};
    defectsCodeArray{iSignal}   = xlsTxtExtract{lineIdx, xlsColIdxArray(5)};
    idealStartIdxArray(iSignal) = xlsNumExtract(lineIdx, xlsColIdxArray(6));
    mvtFreqArray(iSignal)       = xlsNumExtract(lineIdx, xlsColIdxArray(7));
    caliberNameArray{iSignal}   = xlsTxtExtract{lineIdx, xlsColIdxArray(8)};
    
end



%% Extract each signal, trunc it, normalize it and save it

disp('Ongoing process.');

for iSignal = 1 : nSignalToExtract,
    
    %%% Some informations to "wait" while processing is beeing done.
    dispStr             = sprintf('Processing file %d/%d.', iSignal, nSignalToExtract);
    disp(dispStr); 
    
    
    %% Build matObj related to signal
    
    %%% Build file path
    thisSignalOldName   = fileFNameArray{iSignal};
    if strncmp(thisSignalOldName, 'P08', 3),
        signalFileFPath = sprintf('%s%d\\%s', rawDatabasePath, folderNameArray(iSignal), fileFNameArray{iSignal});    
    end
    if strncmp(thisSignalOldName, 'ML0', 3),
        signalFileFPath = sprintf('%s%d\\Exports\\%s', rawDatabasePath, folderNameArray(iSignal), fileFNameArray{iSignal});
    end
    
    %%% Build matObj
    matObj              = matfile(signalFileFPath);

    
    %% Extract datas
    
    %%% Extract fs
    fs                  = double(eval(['matObj.', fsVarName]));
    
    %%% Extract signal
    % Signal is extracted on its integrality because the original mat-file save is an old version of
    % it and does not allow partial data extraction.
    evalStr             = sprintf('matObj.%s', signalVarName);
    signalTot           = eval(evalStr);
    
    
    %% Cut signal
    
    %%% Determine cut index
    thisSignalStartIdx  = idealStartIdxArray(iSignal);
    thisSignalLength    = nTocsToKeep / mvtFreqArray(iSignal) * fs;
    thisSignalStopIdx   = thisSignalStartIdx + thisSignalLength - 1;
    
    %%% Cut signal
    signal              = double(signalTot(thisSignalStartIdx:thisSignalStopIdx, 1));
    
    %%% Delete original signal (those data can be quite memory consuming, so it's better to clear 
    % them as soon as possible)
    clear(var_name(signalTot));

    %%% Normalize signal and put it in row vector
    signalNormFactor    = max(abs(signal));
    signal              = signal(:)' / signalNormFactor;

    
    %% Save datas
    
    %%% Init
    thisSignalOldName        = fileFNameArray{iSignal};
    
    %%% Determine this signal movement identifier and file identifier.
    if strncmp(thisSignalOldName, 'P08', 3),
        thisSignalMvtId      = thisSignalOldName(15);
        thisSignalRId        = 'N01';
    end
    if strncmp(thisSignalOldName, 'ML0', 3),
        thisSignalMvtId      = thisSignalOldName(4);
        thisSignalRId        = thisSignalOldName(14:16);
    end
    
    %%% Determine this signal defect code
    thisSignalDefectCode     = defectsCodeArray{iSignal};
    
    %%% Determine this signal barell level
    thisSignalBarellLevel    = barellLevelArray{iSignal};
    if strcmp(thisSignalBarellLevel, 'T0000'),
        thisSignalBarellLevel = 'B65';
    end
    if strcmp(thisSignalBarellLevel, 'T1800'),
        thisSignalBarellLevel = 'B03';
    end
    
    %%% Save extracted datas
    % Build full file name
    saveFFileName             = [caliberNameArray{iSignal}, thisSignalMvtId, ...
                                '_', thisSignalDefectCode, ...
                                '_', thisSignalBarellLevel, ...
                                '_', thisSignalRId, '.mat'];
	% Build file full path
	saveFileFPath             = [newDatabasePath, saveFFileName];
    % Save datas (signal, fs and signalNormFactor)
	save(saveFileFPath, ...
         var_name(signal), var_name(fs), var_name(signalNormFactor), ...
         '-v7.3');
    
end

disp('Process finished.');

% eof
