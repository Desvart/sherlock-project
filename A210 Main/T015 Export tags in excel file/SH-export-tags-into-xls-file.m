% This script cycle through all 'ML156-*' files present in a given folder, extracts starting index
% of the unlocking event of each toc and plot each toc in a zoom. Once a toc is displayed, user can
% tag it with multiple data cursors. Those tags will then be saved with some other toc description
% variables for further use and analysis.

% Dev. on   : Matlab R2012b (8.0.0.783) x64 - Windows 7 x64

% History
% [Major.Minor.Revision.Build]
% 1.0.b0.0010 - First operationnal version
% 0.0.a0.0000 - 2013.06.06



%% Clean Matlab environment

close all;
clear all;
clc;

addpath('.\lib\');



%% Script parameters

%%% Path
PROJECT_ROOT_PATH   = '.\Sherlock Holmes PF11\';
ACTIVITY_PATH       = [PROJECT_ROOT_PATH, 'Activities\A210 Cleaning code\'];
TASK_PATH           = [ACTIVITY_PATH, 'T015 Export tags in excel file\'];
DATA_PATH           = [TASK_PATH, 'data\'];

%%% Input and output file names
TAG_FILE_FNAME      = 'tags.mat';
XLS_FILE_FNAME      = 'ML_loop_DB_desc.xlsx';

%%% XLS file structure
XLS_TAG_SHEET_READ  = 4;
XLS_TAG_SHEET_WRITE = 5;
XLS_RANGE           = 'A1:K389';
RANGE_ARRAY         = [2, 4:10]; % Location in x of data

%%% Data structure
N_FILES             = 30;
N_TOCS_PER_FILE     = 10;



%% Init script

%%% Start text
fprintf('START SAVING SCRIPT\n\n');

%%% Extract data from tag.mat
tagFileFPath        = [DATA_PATH, TAG_FILE_FNAME];
load(tagFileFPath);

%%% Extract data from excel file
xlsFileFPath        = [DATA_PATH, XLS_FILE_FNAME];
[~, ~, raw]         = xlsread(xlsFileFPath, XLS_TAG_SHEET_READ, XLS_RANGE);



%% Copy each elements of tag.mat in xls file

%%% Init and prealloc loop
raw2    = raw; % Make a copy for security
log     = [];  % If there is an incoherency between xls data and tag.mat data

for iFile = 1 : N_FILES,

    %%% File first line number in xls file, taking in account the header of each file
    fileFirstLine = 3 + (iFile-1)*(N_TOCS_PER_FILE + 3);

    for iToc = 1 : N_TOCS_PER_FILE,
        
        %%% Toc absolute line number in xls file
        tocAbsLine = fileFirstLine - 1 + iToc;

        %%% Count number of NaN per toc
        nNaN = 0;
        for iVar = RANGE_ARRAY,
            if isnan(raw{tocAbsLine, iVar}),
                nNaN = nNaN + 1;
            end
        end
        
        %%% If nNaN is different from the number of tag, generate a log warning and go to next toc
        tocAbsId = (iFile-1)*N_TOCS_PER_FILE + iToc; % toc absolute position in mat file
        if nNaN ~= length(tagArray{tocAbsId}),
            log = [log; iFile, iToc, tocAbsId, tocAbsLine]; %#ok<AGROW>
        end
        
        %%% If there is no incoherency, proceed to data transfert
        if nNaN == length(tagArray{tocAbsId}),
            iVar2 = 0; % This index go through tag.mat vector in each cell
            for iVar = RANGE_ARRAY,
                if isnan(raw{tocAbsLine, iVar}),
                    
                    iVar2               = iVar2 + 1;
                    
                    %%% Display actual processing
                    strTxt              = 'Process file %d toc %d (toc %d) - iVar2 %d file line %d';
                    str                 = sprintf(strTxt, iFile, iToc, tocAbsId, iVar2, tocAbsLine);
                    disp(str);
                    
                    %%% Data transfert
                    raw2{tocAbsLine, iVar} = num2str(tagArray{tocAbsId}(iVar2));
                    
                end
            end
        end
        
    end % for iToc = 1 : N_TOCS_PER_FILE,
end % iFile = 1 : N_FILES,



%% Replace all 'n' values by NaN values
% Probably this could be done by a vectorialized operation, but since I didn't found out how to do
% that with cells, after some minutes I implemented it with nested for loop. Ugly but it does the 
% job.

for iFile = 1 : N_FILES,
    
    fileFirstLine = 3 + (iFile-1)*(N_TOCS_PER_FILE + 3);
    
    for iToc = 1 : N_TOCS_PER_FILE,
        
        tocAbsLine = fileFirstLine - 1 + iToc;
        
        for iVar = RANGE_ARRAY,
            if strcmp(raw{tocAbsLine, iVar}, 'n'),
                raw2{tocAbsLine, iVar} = nan;
            end
        end
        
    end
end



%% Save exported tags in an excel file

xlswrite(xlsFileFPath, raw2, XLS_TAG_SHEET_WRITE, XLS_RANGE);



%% If error are detected

if isempty(log) == false,
    fprintf('\nWARNING : LOG VARIABLE IS NOT EMPTY !');
end



%% Clean Matlab environment

fprintf('\n\nSTOP SAVING SCRIPT\n\n');

rmpath('.\lib\');


%%% eof
