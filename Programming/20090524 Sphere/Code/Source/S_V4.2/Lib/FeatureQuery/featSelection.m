% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Select features training and testing sets from feature database based on previously selected
% files.
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
%   - trFile [struct] Training sets of files
%                       .id      [int 1xn] Absolut index of training files
%                       .nbFile  [int 1x1] Number of training file
%                       .nbFileC [int 1xc] Number of training file per class
%   - teFile [struct] Testing sets of files
%                       .id      [int 1xm] Absolut index of testing files
%                       .nbFile  [int 1x1] Number of testing file
%                       .nbFileC [int 1xc] Number of testing file per class
%
% Output
%   - trFeat [struct] Training sets of features
%                       .feat    [dbl dxn] Training feature data
%                       .label   [int 1xn] Training feature label
%                       .nbFeat  [int 1x1] Number of training features
%                       .nbFeatF [int 1xf] Number of training features per file.
%                       .nbFeatC [int 1xc] Number of training features per class.
%                       .dim     [int 1x1] Feature dimension
%   - teFeat [struct] Testing sets of features
%                       .feat    [dbl dxm] Testing feature data
%                       .label   [int 1xm] Testing feature label
%                       .nbFeat  [int 1x1] Number of testing features
%                       .nbFeatF [int 1xf] Number of testing features per file.
%                       .nbFeatC [int 1xc] Number of testing features per class.
%                       .dim     [int 1x1] Feature dimension
%
%
% Author    : Pitch Corp.
% Date      : 2010.12.06
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [trFeat,teFeat] = featSelection(db, trFile, teFile)

    %%% Preallocation
    nbTrFeatC = zeros(1, db.nbClass);
    nbTeFeatC = zeros(1, db.nbClass);
    trFeature = [];
    trLabel = [];
    teFeature = [];
    teLabel = [];

    for fid = 1:trFile.nbFile,
        start     = sum(db.nbTrFeatF(1:trFile.id(fid)-1)) + 1;
        stop      = start + db.nbTrFeatF(trFile.id(fid)) - 1 ;
        trFeature = [trFeature,db.trFeat(:,start:stop)]; %#ok<AGROW>
        trLabel   = [trLabel,db.trLabel(:,start:stop)];  %#ok<AGROW>
    end
    
    for i = 1:teFile.nbFile,
        start = sum(db.nbTrFeatF(1:teFile.id(i)-1)) + 1;
        stop  = start + db.nbTrFeatF(teFile.id(i)) - 1;
        teFeature = [teFeature,db.teFeat(:,start:stop)]; %#ok<AGROW>
        teLabel   = [teLabel,db.teLabel(:,start:stop)];  %#ok<AGROW>
    end
    
    for cid = 1:db.nbClass,
        nbTrFeatC(cid) = sum(trLabel == cid);
        nbTeFeatC(cid) = sum(teLabel == cid);
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Statistics of file sets
    % -------------------------------------------------------------------------------------------- %
    
    trFeat.feat    = trFeature;
    trFeat.label   = trLabel;
    trFeat.nbFeat  = size(trFeature, 2);
    trFeat.nbFeatF = db.nbTrFeatF(trFile.id);
    trFeat.nbFeatC = nbTrFeatC;
    trFeat.dim     = db.dim;
    
    teFeat.feat    = teFeature;
    teFeat.label   = teLabel;
    teFeat.nbFeat  = size(teFeature, 2);
    teFeat.nbFeatF = db.nbTeFeatF(teFile.id);
    trFeat.nbFeatC = nbTeFeatC;
    teFeat.dim     = db.dim;
    
end


% EoF -------------------------------------------------------------------------------------------- %
