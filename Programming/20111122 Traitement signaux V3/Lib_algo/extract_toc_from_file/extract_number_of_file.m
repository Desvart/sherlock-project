function nItem = extract_number_of_file(folderPath, fileExtension)

% Project TicLoc: Alpha 0.0.7
% Author: Pitch Corp.  -  2011.03.29  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


% folderPath = '../../Database3/Antima_22040_55040/';
% fileExtension = '.wav';

    % Extract all items properties
    item = dir(folderPath);
    
    % Extract items names
    itemName = {item.name}';
    
    % Located hidden files (on Mac and Linux OS hidden file begins with a dot character)
    hiddenItemId = strncmp(itemName, '.', 1);
    
    % Extract hidden files names from the previous names list
    itemName = itemName(~hiddenItemId);
    
    %
    whereIsExtension = strfind(itemName, fileExtension);
     
    % Count the number of non hidden elements
    nItem = length([whereIsExtension{:}]);
    
    
end

% EoF -------------------------------------------------------------------------------------------- %
