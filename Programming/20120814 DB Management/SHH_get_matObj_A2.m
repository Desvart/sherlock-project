function [extractedMatObjList, nFileSelected] = SHH_get_matObj(fileSelectionList, databasePath, verboseFlag)
% Function : SHH_get_matObj
%
% Description : 
% Kind of "get & set" function adapted for the Sherlock Holmes database (Vers. 4.2+). It allow user to
% get a matObj variable for each file one want to process.
%
% Inputs :
%   [fileSelectionList] contains a list of identificator to select the desired file to be loaded.
%                       The variable can accept two formats: a cell or array. 
%                   [cell 1xnFolder, array 1xm] The cell format contains one cell for each folder 
%                       of the database and in each cell there is an array containing the list of Id
%                       of each file one want to load. If the array is empty, no file will be 
%                       loaded.
%                   [array nFilex1] The array format contains the "coordinates" of each file to
%                       load. The first "coordinate" is the folder to wich below the file and the
%                       seconde one is the file Id, i.e.: [3, 11] means folder 3, file 11.
%                       If the array is empty, all files of all database will be loaded.
%                   Default value : [];
%   [databasePath]      [str 1xn] contains the path (absolute or relative) to the database one want
%                       to use. The folder pointed by this path should contained the database 
%                       header file"databaseHeader.mat".
%                   Default value : './';
%   [verboseFlag]       [bool 1x1] If this flag is true, some additional informations will be 
%                       displayed in the Matlab command window or will be ploted during the function
%                       execution. Usefull for debuging.
%                   Default value : false;
%
% Outputs :
%   extractedMatobjList [cell 1xnFile] contains the list of all extracted matObj.
%   [nFileSelected]     [int 1x1] is the number of files selected.
%
% Synopsis : 
%   matObjList = SHH_get_matObj();
%   matObjList = SHH_get_matObj(fileSelectionList);
%   matObjList = SHH_get_matObj(fileSelectionList, databasePath);
%   matObjList = SHH_get_matObj(fileSelectionList, databasePath, verboseFlag);
%   [matObjList, nFileSelected] = SHH_get_matObj();
%   [matObjList, nFileSelected] = SHH_get_matObj(fileSelectionList);
%   [matObjList, nFileSelected] = SHH_get_matObj(fileSelectionList, databasePath);
%   [matObjList, nFileSelected] = SHH_get_matObj(fileSelectionList, databasePath, verboseFlag);
%
%   fileSelectionList = [];
%   fileSelectionList = [1, 2];
%   fileSelectionList = [1, 2; 4, 5; 4, 8; 7, 12];
%   fileSelectionList = {[], [], [], [], [11, 12], [], [], [], [5]};       
%
% Example : 
%   fileSelectionList = {[], [], [], [], [11, 12], [], [], [], [5]};
%   [matObjList, nFileSelected] = SHH_get_matObj(fileSelectionList, '.\ARH_DB4_2\', false);
%
%
% Algorithm :
%   1. Load database header. If header last update was made too long ago (10 minutes) then an update
%   is automatically done before loading the header. If the header doesn't exist, creates one.
%   2. Depending on fileSelectionList, build the indexes to be reached for each wanted file by a 
%   double for-loop.
%   3. Extract the matObj of each file and store them in a cell structure.
%
%
% See also SHH_update_databaseHeader
%
% Project : Sherlock Holmes - GET&SET (Alpha 2)
% 2012.08.09 - 2012.08.14
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Note : 
% - Function successfully tested on database 4.2. Should work on database 4.2+.
% - To edit a matObj field after having load the file, set the "writable" properties of the matObj
%   to true, e.g.:  matObj = SHH_get_matObj([1,6], './');
%                   matObj{1}.Properties.Writable = true;
%                   matObj{1}.fs = newFs;

% Todo : 
% - Accepter comme input de fileSelectionList un table � deux colonnes et autant de ligne que
%   l'on souhaite pour s�lection plusieurs fichiers selon la structure #class, #fichier
%   fileSelectionList = [5, 4; 6, 3; 6, 4; 8, 11];
% - V�rifier qu'il y ait une certaine coh�rence d'input entre la taille de fileSelectionList et le
%   nombre de dossier de la BdD ainsi qu'entre les identifiants des fichiers et le nombre maximum de
%   fichiers dans le dossier en question.
% - Remplacer nFileToSelect = nFileToSelect + length(fileSelectionList{iPartner}); pour le comptage
%   de fichiers dans le cas nPartner par length([fileSelectionList{:}]);

% Log :
% A2 2012.08.14 - 2012.08.14
%   - Eliminate the output cell casting in an array to always have the same king of output
%   regardless of inputs.
%   - Deal the case when databaseHeader.mat file doesn't exist.
%   - Change the headerLastUpdate comparison using etime function instead of doing manual
%   comparison.
%   - Add full comments.
% A1 2012.08.09 - 2012.08.10
%   - Create function


    %% Init function
    
    %%% Manage missing optional inputs
    if nargin < 3,  
        verboseFlag = false;
    elseif verboseFlag == true,
        [st, ~] = dbstack;
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - Start "', st.name, '"']);
    end
    
    if nargin < 2,
        databasePath = './';
    end
    
    if nargin == 0,
        fileSelectionList = [];
    end
    
    %%% Load database header
    databaseHeaderPath = [databasePath, 'databaseHeader.mat'];
    
    if exist(databaseHeaderPath, 'file'),
        load(databaseHeaderPath, 'headerLastUpdate');
        if etime(clock(), headerLastUpdate) > 600, % if last update has been done more than 10 min ago
            SHH_update_databaseHeader(databasePath);
        end
        
    else
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
    
    
    %% Last operations
    
    nFileSelected = length(extractedMatObjList);
    if nFileSelected ~= nFileToSelect,
        error('nFileSelected ~= nFileToSelect');
    end
    
    if verboseFlag == true,
        disp([datestr(now, 'yyyy/mm/dd HH:MM:SS.FFF'), ' - End of "', st.name, '"']);
    end
    
end
% eof
