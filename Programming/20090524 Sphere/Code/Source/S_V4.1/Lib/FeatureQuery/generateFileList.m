% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Create training and testing sets of files from previously created database. The selection strategy
% is to select some files for testing set and all the other for training set.
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
%   - learningParam [bool 1x1] If true, a random testing file is selected.
%
% Output
%   - trFile [struct] Training sets of files
%                       .id      [int 1xn] Absolut index of training files
%                       .nbFile  [int 1x1] Number of training file
%                       .nbFileC [int 1xc] Number of training file per class
%   - teFile [struct] Testing sets of files
%                       .id      [int 1xm] Absolut index of testing files
%                       .nbFile  [int 1x1] Number of testing file
%                       .nbFileC [int 1xc] Number of testing file per class
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.15
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [trFile,teFile] = generateFileList(db, ratio, randomFlag)

    %%% Compute number of file per set
    nbTrFileC = ceil(db.nbFileC*ratio);
    nbTeFileC = db.nbFileC - nbTrFileC;
    
    %%% Loop initialization
    classTrFId = zeros(1, db.nbClass);
    classTeFId = zeros(1, db.nbClass);
    stop1 = 0;
    stop2 = 0;
    
    for cid = 1 : db.nbClass,
        
        %%% Compute random file absolute index for this class (randomFileAId)
        if randomFlag,
            fileId = db.classFId(cid) - 1 + randperm(db.nbFileC(cid));
        else
            fileId = db.classFId(cid) - 1 + (1:db.nbFileC(cid));
        end
        
        start1 = stop1 + 1;
        stop1  = start1 + nbTrFileC(cid) - 1;
        trFileId(start1:stop1) = fileId(1:nbTrFileC(cid));
                                   
        start2 = stop2 + 1;
        stop2  = start2 + nbTeFileC(cid) - 1;
        teFileId(start2:stop2) = fileId(nbTrFileC(cid)+1:end);
        
        classTrFId(cid) = sum(nbTrFileC(1:cid-1)) + 1;
        classTeFId(cid) = sum(nbTeFileC(1:cid-1)) + 1;
        
    end
                                                     

    % -------------------------------------------------------------------------------------------- %
    % Statistics of file sets
    % -------------------------------------------------------------------------------------------- %
    
    trFile.nbFileC = nbTrFileC;
    trFile.nbFile  = sum(nbTrFileC);
    trFile.id      = trFileId;
    trFile.classFId = classTrFId;
    
    teFile.nbFileC = nbTeFileC;
    teFile.nbFile  = sum(nbTeFileC);
    teFile.id      = teFileId;
    teFile.classFId = classTeFId;
    
end


% EoF -------------------------------------------------------------------------------------------- %
