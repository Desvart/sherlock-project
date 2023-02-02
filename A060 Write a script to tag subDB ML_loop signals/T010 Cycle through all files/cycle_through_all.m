% This script cycle through all 'ML156-*' files present in a given folder

% Author : Pitch
% Date   : 2013.05.22 - 2013.05.22



%% Clean Matlab environment

close all;
clear all;
clc;



%% Script parameters

%%% Path
PROJECTROOTPATH     = '.\\Ongoing\Sherlock Holmes ABP011\';
DATABASEPATH        = [PROJECTROOTPATH, 'Data\Database\ML\subDB ML_loop\'];

STARTNAMESTR        = 'ML156-';



%% Extract signal file full names and full path

%%% Extract folder elements
dirStruct           = dir(DATABASEPATH);
dirElemNameArray    = {dirStruct(:).name}';
nDirElem            = length(dirElemNameArray);

%%% Filtered signal file names from other files
idx                 = cellfun(@(x)( ~isempty(x) ), regexp(dirElemNameArray, STARTNAMESTR));
fileFNamesArray     = dirElemNameArray(idx);
nFiles              = length(fileFNamesArray);

%%% Build signal file full path
databasePathCArray  = repmat({DATABASEPATH}, nFiles, 1);
fileFPathArray      = strcat(databasePathCArray(:), fileFNamesArray(:));



%% For loop to cycle through all signal files

for iFile = 1 : nFiles,

    str = '%d - File name : %s\n';
    fprintf(str, iFile, fileFNamesArray{iFile});
    
end

%% eof
