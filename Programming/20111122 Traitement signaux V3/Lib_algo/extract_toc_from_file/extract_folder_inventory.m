function [nItem, itemName] = extract_folder_inventory(folderPath, shouldCheck)
% EXTRACT_FOLDER_INVENTORY  Extract the number of elements (folder, files and other) present in a 
%                           folder and their names.
%
% Synopsis: extract_folder_inventory(folderPath)
%           extract_folder_inventory(folderPath, shouldCheck)
%
% Inputs:   folderPath  [str 1xm] Path to folder ta analyse.
%           shouldCheck [bool 1x1] (optional) If true, check function is executed at the end of the 
%                       function. Check function verifies if there is only one type of item (files 
%                       or folders) in main folder. If there is a mix of both, it generates an error.
%
% Outputs:  nItem       [int 1x1] Number of non hidden items present in the main folder.
%           itemName    [cell nx1, str 1xm] Nams of non hidden items.

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.02.28  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % Extract all items properties
    item = dir(folderPath);
    
    % Extract items names
    itemName = {item.name}';
    
    % Located hidden files (on Mac and Linux OS hidden file begins with a dot character)
    hiddenItemId = strncmp(itemName, '.', 1);
    
    % Extract hidden files names from the previous names list
    itemName = itemName(~hiddenItemId);
    
    % Count the number of non hidden elements
    nItem = length(itemName);
    
    % Check if only files or folders are detected. If both are detected, an error is generate.
    if nargin == 1, 
        shouldCheck = false; 
    end
    if shouldCheck,
        check_folder_homogeneity(item, hiddenItemId);
    end
    
end



function check_folder_homogeneity(item, hiddenItemId)
% CHECK_FOLDER_HOMOGENEITY  Verifies if item structure contains both folder and files. If yes, an 
%                           error is generated.
%
% Synopsis: check_folder_homogeneity(item, hiddenItemId)
%
% Inputs:   folderPath  [str 1xm] Path to folder ta analyse.
%           shouldCheck [bool 1x1] If true, check function is executed at the end of the function.
%                       Check function verifies if there is only one type of item (files or folders)
%                       in main folder. If there is a mix of both, it generates an error.

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.02.25  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    % Extract isdir flag for each item
    isDir = [item.isdir];
    
    % Keep only non hidden item flag
    isDir = isDir(~hiddenItemId);

    % If one of the non hidden item is a folder generate an error.
    isThereDir  = any(isDir);
    isThereFile = ~all(isDir); % Anything that is not a folder is considered a file.
    if isThereDir && isThereFile,
        error('Files and folders are simultaneously detected. This configuration should not appear in the database.')
    end
        
end


% EoF -------------------------------------------------------------------------------------------- %
