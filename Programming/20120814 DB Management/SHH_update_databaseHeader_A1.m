function SHH_update_databaseHeader(databasePath, verboseFlag)
% Project : Sherlock Holmes - GET&SET (Alpha 1)
% 2012.08.09 - 2012.08.09
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Todo : 
% - Ajouter une option permettant de charger les fichiers en mode �criture (force la mise � jour du
% header)
% - Corriger l'anomalie d'affichage sur le verboseFlag disp en rempla�ant st.name par st(1).name

% Log :
% A1 2012.08.09 - 2012.08.09
%   - Create function


    %% Init function
    
    %%% Manage missing optional inputs
    if nargin < 2,  
        verboseFlag = false;
    elseif verboseFlag == true,
        [st, ~] = dbstack;
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start "', st.name, '"']);
    end
    
    if nargin == 0,
        databasePath = './';
    end
    
    fileStructure = 'P[0-9]{2}+_M[0-9]{2}+_E[0-3]{2}+_N[0-9]{2}+_T(1800|0030)_V[1-9]{1}+.mat';
    folderStructure = fileStructure(1:9);
        
    
    %% Extract number of partner and partner identificator
    
    %%% Extract element names present in actual folder
    items     = dir(databasePath); % Extract all items properties
    itemsName = {items.name}';     % Extract items names
    nItems    = length(itemsName);    

    %%% Select only item with "Ppp" name structure
    regQuery1       = folderStructure;
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
        regQuery1       = fileStructure;
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
         'matObjList', 'fileStructure', 'folderStructure', 'databaseVersion', 'headerLastUpdate', ...
         '-mat', '-v7.3');

     
    if verboseFlag == true,
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st.name, '"']);
    end

end
%eof