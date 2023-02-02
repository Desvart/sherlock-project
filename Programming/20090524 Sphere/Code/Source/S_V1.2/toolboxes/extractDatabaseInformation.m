function [className, nbClass, nbFilePerClass, fileRootPathPerClass] = ...
                             extractDatabaseInformation(database_Path, fileExtension_Size)
   
                   
    %%% Load class names
    [className, nbClass] = folderContents(database_Path);

    %%% Load file names for each class and compute the number of files available for each
    %%% class
    nbFilePerClass = zeros(nbClass, 1); % Preallocation
    fileRootPathPerClass   = cell(nbClass, 1);  % Preallocation
    for i = 1 : nbClass,
        [fileName, nbFilePerClass(i)] = folderContents([database_Path, className{i}]);
        fileCoreName                  = fileName{1}(1:end-fileExtension_Size);
        fileRootPathPerClass{i}       = [database_Path, className{i}, '/', fileCoreName]; % ./small_database/chiens/chien
    end
                   
end


% Function : folderContents.m
% 
% Purpose  : Extract the names of the folders and files contain in a folder.
%
% Inputs :  
%       folderPath  [string] Path of the folder to analyse
%
% Outputs : 
%       elementName [cell matrix] List of file or folder names found in the folder
%
%       nbElement   [scalar] Number of file or folder found in the folder
%       
%
%
% Author    : Pitch Corp.
% Date      : 6.06.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [elementName, nbElement] = folderContents(folderPath)

    elementName = dir(folderPath);
    elementName = {elementName.name}';
    
    % Next operation find hidden files by looking the first character of the file name. If
    % this is a dot, then this is a hidden file (on Mac and linux OS).
    elementName = elementName(~strncmp(elementName, '.', 1));
    
    nbElement   = length(elementName);
    
end %function


% --------------------------------- End of file ------------------------------------------
