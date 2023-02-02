function databasePath = SHH_get_dbPath(wantedVersionNumber, databaseRootPath, verboseFlag)
% SHH_get_dbPath - Kind of "get & set" function adapted for the Sherlock Holmes database 
% (Vers. 4.2+). It allow user to get a matObj variable for each file one want to process.
%
% Inputs :
%   [wantedVersionNumber] [dbl 1x1] database version number one want to know the root folder path.
%                       If this variable is empty, the last version (the one with the higher 
%                       value) will be loaded.
%                   Default value : [];
%   [databaseRootPath]  [str 1xn] contains the path (absolute or relative) to the database root 
%                       where all the databases are stored.
%                   Default value : various (constant to be manually selected in the script);
%   [verboseFlag]       [bool 1x1] If this flag is true, some additional informations will be 
%                       displayed in the Matlab command window or will be ploted during the function
%                       execution. Usefull for debuging.
%                   Default value : false;
%
% Outputs :
%   databasePath [str 1xn] contains the path to selected database.
%
% Synopsis : 
%   databasePath = SHH_get_dbPath();
%   databasePath = SHH_get_dbPath(wantedVersionNumber);
%   databasePath = SHH_get_dbPath([], databaseRootPath);
%   databasePath = SHH_get_dbPath(wantedVersionNumber, databaseRootPath);
%   databasePath = SHH_get_dbPath([], [], verboseFlag);
%   databasePath = SHH_get_dbPath(wantedVersionNumber, [], verboseFlag);
%   databasePath = SHH_get_dbPath([], databaseRootPath, verboseFlag);
%   databasePath = SHH_get_dbPath(wantedVersionNumber, databaseRootPath, verboseFlag);
%
% Example : 
%   databasePath = SHH_get_dbPath(4.2, './20111100_ARH/', true);

% Project   : Sherlock Holmes - DB Management
% File vers.: Beta 1.0 (2012.08.16)
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Log :
% B1.0 <- A1 (2012.08.16)


%% Init function
    
    %%% Define constant or external parameters
    DATABASE_ROOT_DEFAULT_PATH = 'D:\Work\Projects\Ongoing\ABP011 2011-201x Sherlock Holmes\Database\Sounds\20111100_ARH\';
%     DATABASE_ROOT_DEFAULT_PATH = 'D:\Work\Projects\Ongoing\ABP011 2011-201x Sherlock Holmes\Database\Sounds\20111100_ARH\';
    FOLDER_NAME_STRUCTURE = 'ARH_DB[0-9]{1}_[0-9]{1}';
    NAME_DESC_LENGTH      = 7; %ARH_DB

    
    %%% Manage missing optional inputs
    if nargin < 3,  
        verboseFlag = false;
    elseif verboseFlag == true,
        [st, ~] = dbstack;
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start "', st(1).name, '"']);
    end
    
    if nargin < 2 || isempty(databaseRootPath),
       databaseRootPath = DATABASE_ROOT_DEFAULT_PATH; 
    end
    
    if nargin == 0,
        wantedVersionNumber = [];
    end

    
    
%% Core function
    
    %%% Extract element names present in actual folder
    items     = dir(databaseRootPath); % Extract all items properties
    itemsName = {items.name}';     % Extract items names
    nItems    = length(itemsName);    

    %%% Select only item with desire name structure
    regQuery1       = FOLDER_NAME_STRUCTURE;
    regAnswer1      = regexp(itemsName, regQuery1);
    nSelectedItems  = length([regAnswer1{:}]);

    %%% Extract folders with desired name structure
    iItemToSelect       = 0;                       % init loop
    nameOfSelectedItems = cell(nSelectedItems, 1); % Prealloc

    for iItem = 1 : nItems, 
        if ~isempty(regAnswer1{iItem}),
            iItemToSelect = iItemToSelect + 1;
            nameOfSelectedItems{iItemToSelect} = itemsName{iItem};
        end
    end
    
    %%% Extract database version numbers
    versionNumberList = zeros(1, nSelectedItems); % Preallocation
    for iSelectedItems = 1 : nSelectedItems,
        versionStr = nameOfSelectedItems{iSelectedItems}(NAME_DESC_LENGTH+1:end);
        versionNumberList(iSelectedItems) = str2double(versionStr(1)) + str2double(versionStr(3))/10;
    end
    
    
    %%% Format output
    if isempty(wantedVersionNumber),
       wantedVersionNumber = versionNumberList(end);
    end
    
    if any(versionNumberList == wantedVersionNumber),
        databasePath = [databaseRootPath, nameOfSelectedItems{versionNumberList == wantedVersionNumber}, '\'];
    else
        error('Database version doesn''t exist.');
    end

    
    
%% Last operations

    if verboseFlag == true,
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st(1).name, '"']);
    end

end
%eof
