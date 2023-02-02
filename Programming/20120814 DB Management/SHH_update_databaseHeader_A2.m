function SHH_update_databaseHeader(databasePath, verboseFlag)
% Function : SHH_update_databaseHeader
%
% Description : 
% Create or update the database header file ("databaseHeader.mat") of the spotted database 
% (Vers. 4.2+). This file contains general information about the database as :
%   - Partner name (P01, P02, etc.)
%   - Number of partner in the database
%   - Number of file for each partner
%   - The name (with extension) of all files in the database
%   - The number of file in the database
%   - The matObj (non writable) of each file
%   - The file name structure and the folder name structure
%   - The database version number
%   - The timestamp of the last database update
%
% Inputs :
%   [databasePath]      [str 1xn] contains the path (absolute or relative) to the database one want
%                       to update.
%                   Default value : './';
%   [verboseFlag]       [bool 1x1] If this flag is true, some additional informations will be 
%                       displayed in the Matlab command window or will be ploted during the function
%                       execution. Usefull for debuging.
%                   Default value : false;
%
% Outputs :
%   - No output
%
% Synopsis : 
%   SHH_update_database_header();
%   SHH_update_database_header(databasePath);
%   SHH_update_database_header(databasePath, verboseFlag);
%
% Example : 
%   SHH_update_database_header('../ARH_DB4/');
%
%
% Algorithm :
%   1. Extract number of partner and partner identificator.
%   2. Extract the number of files for each partner and file names.
%   3. Build matObj shortcut for all database.
%   4. Export data that describes the database in .mat file.
%
%
% See also SHH_update_database_header
%
% Project : Sherlock Holmes - GET&SET (Alpha 2)
% 2012.08.09 - 2012.08.15
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Note : 
% - Function successfully tested on database 4.2. Should work on database 4.2+.

% Todo : 
% - Nothing... currently.

% Log :
% A2 2012.08.15 - 2012.08.15
%   - Correct verbose text anomaly (st(1).name)
%   - Change name of some variables to enhanced code readability.
%   - Add full comments.
% A1 2012.08.09 - 2012.08.09
%   - Create function


    %% Init function
    
    %%% Manage missing optional inputs
    if nargin < 2,  
        verboseFlag = false;
    elseif verboseFlag == true,
        [st, ~] = dbstack;
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start "', st(1).name, '"']);
    end
    
    if nargin == 0,
        databasePath = './';
    end
    
    fileNameStructure = 'P[0-9]{2}+_M[0-9]{2}+_E[0-3]{2}+_N[0-9]{2}+_T(1800|0030)_V[1-9]{1}+.mat';
    folderNameStructure = fileNameStructure(1:9);
        
    
    %% Extract number of partner and partner identificator
    
    %%% Extract element names present in actual folder
    items     = dir(databasePath); % Extract all items properties
    itemsName = {items.name}';     % Extract items names
    nItems    = length(itemsName);    

    %%% Select only item with "Ppp" name structure
    regQuery1       = folderNameStructure;
    regAnswer1      = regexp(itemsName, regQuery1);
    nSelectedItems  = length([regAnswer1{:}]);

    %%% Extract folders name with desired structure
    iItemToSelect       = 0;                       % init loop
    nameOfSelectedItems = cell(nSelectedItems, 1); % Prealloc

    for iItem = 1 : nItems, 
        if ~isempty(regAnswer1{iItem}),
            iItemToSelect = iItemToSelect + 1;
            nameOfSelectedItems{iItemToSelect} = itemsName{iItem};
        end
    end
    
    nPartners    = nSelectedItems;
    partnersName = nameOfSelectedItems;
    
    
    %% Extract the number of files for each partner and file names
    
    nFilesPerPartner = zeros(1, nPartners);
    fileNamesList    = cell(nPartners, 1);
    
    for iPartner = 1 : nPartners,
        %%% Extract element names present in actual folder
        items     = dir([databasePath, partnersName{iPartner}]); % Extract all items properties
        itemsName = {items.name}';     % Extract items names
        nItems    = length(itemsName);    

        %%% Select only item with with "Ppp_Mmm_Eee_Nnn_Ttt.mat" name structure
        regQuery2       = fileNameStructure;
        regAnswer2      = regexp(itemsName, regQuery2);
        nSelectedItems  = length([regAnswer2{:}]);
        
        %%% Extract folders name with desired structure
        iItemToSelect       = 0;                       % init loop
        nameOfSelectedItems = cell(nSelectedItems, 1); % Prealloc

        for iItem = 1 : nItems, 
            if ~isempty(regAnswer2{iItem}),
                iItemToSelect = iItemToSelect + 1;
                nameOfSelectedItems{iItemToSelect} = itemsName{iItem};
            end
        end
        
        %%% Regroup information in one structure
        nFilesPerPartner(iPartner) = nSelectedItems;
        fileNamesList{iPartner}    = nameOfSelectedItems;
        
    end
    
    nFilesInDatabase = sum(nFilesPerPartner); %#ok<NASGU>
    

    %% Build matObj shortcut for all database

    matObjList = cell(nPartners, 1);
    
    for iPartner = 1 : nPartners,
        
        nFilesForThisPartner = nFilesPerPartner(iPartner);
        matObjList{iPartner} = cell(1, nFilesForThisPartner);
        
        for iFileForThisPartner = 1 : nFilesForThisPartner,

            % Load data of interest
            matObj = matfile([databasePath, partnersName{iPartner}, '/', fileNamesList{iPartner}{iFileForThisPartner}]);
            matObjList{iPartner}{iFileForThisPartner} = matObj;
        end 
        
    end

    
    %% Export data that describes the database in .mat file.
    
    databaseVersion = matObj.databaseVersion; %#ok<NASGU>
    headerLastUpdate = clock(); %#ok<NASGU>
    save([databasePath, 'databaseHeader.mat'], ...
         'partnersName', 'nPartners', 'nFilesPerPartner', 'fileNamesList', 'nFilesInDatabase', ...
         'matObjList', 'fileNameStructure', 'folderNameStructure', 'databaseVersion', ...
         'headerLastUpdate', ...
         '-mat', '-v7.3');
     
     
    %% Last operations
     
    if verboseFlag == true,
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st(1).name, '"']);
    end

end
%eof
