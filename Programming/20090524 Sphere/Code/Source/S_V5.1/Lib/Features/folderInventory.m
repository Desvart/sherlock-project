% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% A folder cans contain sub-folders and files. This function counts the number of elements
% (sub-folders and files) that are contained in a folder and gives their names. If folders and files
% are simultaneously detected an error is generated.
%
% Input
%   - folderPath [string]   folder path to inspect
%
% output
%   - nbItem   [int 1x1]       number of non hidden items detected
%   - itemName [cell nx1, str] names of the non hidden items detected
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.02
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [nbItem,itemName] = folderInventory(folderPath)

    % Extract all items properties
    item = dir(folderPath);
    
    % Extract items names
    itemName = {item.name};
    
    % Located hidden files (on Mac and Linux OS hidden file begins with a dot character)
    hiddenItemId = strncmp(itemName, '.', 1);
    
    % Extract hidden files names from the previous names list
    itemName = itemName(~hiddenItemId);
    
    % Count the number of non hidden elements
    nbItem = length(itemName);
    
    % Check if only files or folders are detected. If both are detected, an error is generate.
    check(item, nbItem, hiddenItemId);
    
end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% Check if only files or folders are detected. If both are detected, an error is generate.
% ------------------------------------------------------------------------------------------------ %

function check(item, nbItem, hiddenItemId)

    % Extract isdir flag for each item
    isdirFlag = [item.isdir];
    
    % Keep only non hidden item flag
    isdirFlag = isdirFlag(~hiddenItemId);

    % If one of the non hidden item is a folder generate an error.
    if sum(isdirFlag) ~= 0 && sum(isdirFlag) ~= nbItem,
        error('Files and folders are simultaneously detected. This configuration should not appear in the database.')
    end
        
end


% EoF -------------------------------------------------------------------------------------------- %
