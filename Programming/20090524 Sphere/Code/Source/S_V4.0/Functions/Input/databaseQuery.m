%
% database  .nbClass        scalar       [1x1]
%           .nbFile         scalar       [1x1]
%           .className      string cell  [nbClass x 1]
%           .nbFilePerClass scalar array [nbClass x 1]
%           .filePath       string cell  [nbFile x 1]

% ----------------------------------------------------------------------------------------
% Author    : Pitch Corp.
% Date      :
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function database = databaseQuery(databasePath)
   
                   
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
        [nbFilePerClass(i), fileNamePerClass] = folderContents([databasePath, className{i}]);
        
        % Build the complete file path for each file of the i-th class.
        filePathPerClass{i} = cell(nbFilePerClass(i), 1); % Preallocation
        for j = 1 : nbFilePerClass(i),
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

    %%% Build output
    database.nbClass        = nbClass;
    database.nbFile         = nbFile;
    database.className      = className;
    database.nbFilePerClass = nbFilePerClass;
    database.filePath       = filePath;
    
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
