% ----------------------------------------------------------------------------------------
% Function : extractDatabaseInformation.m
% 
% Purpose  : This function extracts usefull informations about the database.
% 
% Input:
%   - databasePath      [string]
%                       Relativ path to database from start.m folder.
% 
% 
% Outputs:
%   - nbClass           [scalar]
%                       Number of classes that contains the database. This number is equal
%                       to the number of subfolders present in the database root.
% 
%   - className         [cell(nbClass x 1) : string]
%                       Contains classes names that are in the database. This are the
%                       names of the subfolder present in the database root.
% 
%   - nbFile            [scalar]
%                       Number of files present in the database.
% 
%   - nbFilePerClass    [array(nbClass x 1) : scalar]
%                       Number of files prensent in each class.
% 
%   - filePath          [cell(nbFile+1 x 1) : 1 x array(nbClass x 1) + nbFile x string]
%                       Each cell contains the path of one files of the database. Path are
%                       ordered by class and file index. First cell is a "header
%                       information". It contains the number of files stored in each
%                       class.
%
% 
% Author    : Pitch Corp.
% Date      : 14.07.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function [className, filePath] = extractDatabaseInformation(databasePath)
   
                   
    %%% Extact the number of class and their names from the database
    [nbClass, className] = folderContents(databasePath);
    
    
    %%% This loop extracts, for each class, the files names and build the related file 
    % path. At the end of the loop, all files path are built but they are stored in 
    % different cells, one per class.
    
    % Preallocations
    nbFilePerClass   = zeros(nbClass, 1);
    filePathPerClass = cell(nbClass, 1);
    
    for i = 1 : nbClass,
        
        % Extract the number of files for the i-th class and the names of those files.
        [nbFilePerClass(i), fileNamePerClass] = ...
                                             folderContents([databasePath, className{i}]);
        
        % Build the complete file path for each file of the i-th class.
        filePathPerClass{i} = cell(nbFilePerClass(i), 1); % Preallocation
        for j = 1:nbFilePerClass(i),
            filePathPerClass{i}{j} = [databasePath, className{i}, '/', fileNamePerClass{j}];
        end
        
    end
    
    %%% Compute the total number of files present in the database
    nbFile = sum(nbFilePerClass);
    
    %%% Currently files path are store in different cells (one per class). This loop 
    % regroups all files path in one big cell.
    
    filePath = cell(nbFile, 1); % Preallocation
    
    lastIndex = nbFilePerClass(1);
    filePath(1:lastIndex) = filePathPerClass{1};
    for i = 2 : nbClass,
        firstIndex = lastIndex + 1;
        lastIndex  = firstIndex + nbFilePerClass(i) - 1;
        filePath(firstIndex:lastIndex) = filePathPerClass{i};
    end

                   
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
%                                  NESTED FUNCTION                                       %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %



% ----------------------------------- FUNCTION ----------------------------------------- %
% A folder can contain sub-folders and files. This function counts the number of elements
% (sub-folders and files) that are contained in a folder and gives their names.
% -------------------------------------------------------------------------------------- %

function [nbElements, elementNames] = folderContents(folderPath)

    elementNames = dir(folderPath);
    elementNames = {elementNames.name}'; % Select elements names and put them into column
    
    % Next operation find hidden files by looking the first character of the file name. If
    % this is a dot, then this is a hidden file (on Mac and linux OS).
    elementNames = elementNames(~strncmp(elementNames, '.', 1));
    
    nbElements   = length(elementNames);
    
end


% --------------------------------- End of file ------------------------------------------
