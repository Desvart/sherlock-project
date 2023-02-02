% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Create training and testing sets of files from previously created database. The selection strategy
% is to select one file for testing set and all the other for training set.
%
% Input
%   - db [struct]   Features database
%                   .nbClass    [int 1x1] number of class in database
%                   .className  [cell cx1, str] Name of each class
%                   .nbFile     [int 1x1] number of file in all database
%                   .nbFileC    [int 1xc] number of file per class
%                   .dim        [int 1x1] dimension of features
%
%                   .trFeat     [dbl dxn] training feature data
%                   .trLabel    [int 1xn] label for each training feature
%                   .nbTrFeat   [int 1x1] number of training feature in all database
%                   .nbTrFeatC  [int 1xc] number of training feature per class
%                   .nbTrFeatF  [int 1xf] number of training feature per file
%
%                   .teFeat     [dbl dxn] testing feature data
%                   .teLabel    [int 1xn] label for each testing feature
%                   .nbTeFeat   [int 1x1] number of testing feature in all database
%                   .nbTeFeatC  [int 1xc] number of testing feature per class
%                   .nbTeFeatF  [int 1xf] number of testing feature per file
%
%                   .realFeatFlag [bool 1x1] if true, features come from mathematical models,
%                                            else they come from real physical data.
%   - randomFlag [bool 1x1] If true, a random testing file is selected.
%
% Output
%   - trFile [struct] Training sets of files
%                       .id      [int 1xn] Absolut index of training files
%                       .nbFile  [int 1x1] Number of training file
%                       .nbFileC [int 1xc] Number of training file per class
%   - teFile [struct] Testing sets of files
%                       .id      [int 1x1] Absolut index of testing file
%                       .nbFile  [int 1x1] Number of testing file
%                       .nbFileC [int 1xc] Number of testing file per class
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.15
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [trFile,teFile] = generateFileList0(db, randomFlag)
    
    persistent teFileId teFileId_historic;
    
    %%% Selection of the single test file
    if randomFlag,
        
        teFileId = randi(db.nbFile); % Select a random integer value between 1 and nbFile
        % If this value has been previously already choosen, choose another one
        while any(teFileId_historic == teFileId),
            teFileId = randi(db.nbFile);
        end
        teFileId_historic = [teFileId_historic,teFileId]; % Stock old index in an array
        
    else
        
        % Initialization
        if isempty(teFileId),
            teFileId = 0;
        end
        % Increment index
        teFileId = teFileId + 1;
        
    end
    
    %%% Selection of the training files
    fileId    = 1:db.nbFile;
    trFile.id = fileId(fileId~=teFileId);
    teFile.id = teFileId;
    
    
    % -------------------------------------------------------------------------------------------- %
    % Statistics of file sets
    % -------------------------------------------------------------------------------------------- %
    
    %%% Compute number of file
    teFile.nbFile = 1;
    trFile.nbFile = db.nbFile - 1;
    
    %%% Compute number of files per class
    trFile.nbFileC = db.nbFileC;           % Preallocation
    teFile.nbFileC = zeros(1, db.nbClass); % Preallocation
    for cid = 1:db.nbClass,
        teFileRId = teFile.id - sum(db.nbFileC(1:cid-1));
        if teFileRId <= db.nbFileC(cid),
            classId = cid;
            trFile.nbFileC(cid) = db.nbFileC(cid) - 1;
            teFile.nbFileC(cid) = 1;
            break;
        end
    end
    
    trFile.classFId = zeros(1, db.nbClass); % Preallocation
    teFile.classFId = zeros(1, db.nbClass); % Preallocation
    for cid = 1:db.nbClass,
        trFile.classFId(cid) = sum(trFile.nbFileC(1:cid-1)) + 1;
        if cid == classId,
            teFile.classFId(cid) = teFile.id;
        end
    end

end


% EoF -------------------------------------------------------------------------------------------- %
