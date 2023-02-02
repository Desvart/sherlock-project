function [extractedMatObjList, nFileSelected] = SHH_get_matObj(fileSelectionList, databasePath, verboseFlag)
% Project : Sherlock Holmes - GET&SET (Beta 1.0)
% 2012.08.09 - 2012.08.10
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Log :
% B1.0 <- A1 (2012.08.10)


    %% Init function
    
    %%% Manage missing optional inputs
    if nargin < 3,  
        verboseFlag = false;
    elseif verboseFlag == true,
        [st, ~] = dbstack;
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start "', st(1).name, '"']);
    end
    
    if nargin < 2,
        databasePath = './';
    end
    
    if nargin == 0,
        fileSelectionList = [];
    end
    
    %%% Load database header
    databaseHeaderPath = [databasePath, 'databaseHeader.mat'];
    
    load(databaseHeaderPath, 'headerLastUpdate');
    actualTime = clock();
    if any(headerLastUpdate(1:4)~=actualTime(1:4)) || actualTime(5) - headerLastUpdate(5) > 10,
        SHH_update_databaseHeader(databasePath);
    end
    load(databaseHeaderPath, 'matObjList', 'nFilesPerPartner', 'nPartners', 'partnersName', ...
                             'fileStructure', 'nFilesInDatabase');
                                           
                                           
    %%% Analyse fileSelectionList size
    partnerIdList = [];
    nFileToSelect = 0;
    switch length(fileSelectionList),
        case 0,         
            partnerIdList      = 1 : nPartners;
            nFileToSelect      = nFilesInDatabase;
            
        case 2,         
            partnerIdList      = fileSelectionList(1);
            fileToSelectIdListForThisPartner = fileSelectionList(2);
            nFileToSelect      = 1;
            
        case nPartners,
            for iPartner = 1 : nPartners, 
                if ~isempty(fileSelectionList{iPartner})
                    partnerIdList = [partnerIdList, iPartner]; %#ok<AGROW>
                    nFileToSelect = nFileToSelect + length(fileSelectionList{iPartner});
                end
            end
            
        otherwise, error('');
    end
    
    
    %% Core function
    
    extractedMatObjList = cell(nFileToSelect, 1);
    iExtractedMatObj = 0;
        
    for iPartner = partnerIdList,
        
        switch length(fileSelectionList),
            case 0,         fileToSelectIdListForThisPartner = 1 : nFilesPerPartner(iPartner);
            case nPartners, fileToSelectIdListForThisPartner = fileSelectionList{iPartner};
        end
        
        for iFileToSelect = fileToSelectIdListForThisPartner,
            
            iExtractedMatObj = iExtractedMatObj + 1;
            extractedMatObjList{iExtractedMatObj} = matObjList{iPartner}{iFileToSelect}; %#ok<USENS>
            
        end

    end
    
    %% For output format
    if length(fileSelectionList) == 1,
        extractedMatObjList = extractedMatObjList{1};
    end
    
    
    %% Last operations
    
    nFileSelected = length(extractedMatObjList);
    if nFileSelected ~= nFileToSelect,
        error('nFileSelected ~= nFileToSelect');
    end
    
    if verboseFlag == true,
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st(1).name, '"']);
    end
    
end
% eof
