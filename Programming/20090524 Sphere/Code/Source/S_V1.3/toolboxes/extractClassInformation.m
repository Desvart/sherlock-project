function class = extractClassInformation(database)

    %%% Load inputs
    database_Path = database.path;
    extension_Size = database.fileExtension_Size; 
                   
    %%% Load class names
    [className, nbClass] = folderContent(database_Path);

    %%% Load file names for each class and compute the number of files available for each
    %%% class
    nbFilePerClass = zeros(nbClass, 1);        % Preallocation
    genericPathPerClass   = cell(nbClass, 1);  % Preallocation
    for i = 1 : nbClass,
        [fileName, nbFilePerClass(i)] = folderContent([database_Path, className{i}]);
        fileCoreName                  = fileName{1}(1:end-extension_Size);
        genericPathPerClass{i}        = [database_Path, className{i}, '/', fileCoreName]; % ./small_database/chiens/chien
    end
    
    %%% Build outputs structure
    class.name                = className;
    class.nbClass             = nbClass;
    class.nbFilePerClass      = nbFilePerClass;
    class.nbFile              = sum(nbFilePerClass);
    class.genericPathPerClass = genericPathPerClass;
                   
end


% Function : folderContent.m
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


function [elementName, nbElement] = folderContent(folderPath)

    elementName = dir(folderPath);
    elementName = {elementName.name}';
    
    % Next operation find hidden files by looking the first character of the file name. If
    % this is a dot, then this is a hidden file (on Mac and linux OS).
    elementName = elementName(~strncmp(elementName, '.', 1));
    
    nbElement   = length(elementName);
    
end %function


% --------------------------------- End of file ------------------------------------------
