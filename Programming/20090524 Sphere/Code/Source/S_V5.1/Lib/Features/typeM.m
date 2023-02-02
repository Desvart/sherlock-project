% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Type M consists in the statistical mean and standard deviation of sequence of feature vectors 
% extracted threw time. The first part of this feature vector is the mean of all the previous 
% feature vectors. The second part is the elements of the standard deviation of thos feature 
% vectors. This strategy allows to work with smaller quantity of datas but destroys some 
% informations linked to the time evolution of the features. Perhaps some of this information 
% remains in the standard deviation part of the feature vectors.
%
% Inputs
%   - feat [struct] Contains data, label and somes data properties.
%                   .nbClass     [int 1x1] number of class in database
%                   .className   [cell 1xc, str] Name of each class
%                   .nbFile      [int 1x1] number of file in all database
%                   .fileLabel   [int 1xf] file labels
%                   .nbFileC     [int 1xc] number of file per class
%                   .dim         [int 1x1] dimension of features
%                   .classFiId   [int 1xc] classes indexes view from file indexes
%                   .classTrFeId [int 1xc] classes indexes view from training feature indexes
%                   .classTeFeId [int 1xc] classes indexes view from testing feature indexes
%                   .fileTrFeId  [int 1xf] files indexes view from training feature indexes
%                   .fileTeFeId  [int 1xf] files indexes view from testing feature indexes
%
%                   .trFeat      [featl dxn] training feature data
%                   .trLabel     [int 1xn] label for each training feature
%                   .nbTrFeat    [int 1x1] number of training feature in all database
%                   .nbTrFeatC   [int 1xc] number of training feature per class
%                   .nbTrFeatF   [int 1xf] number of training feature per file
%
%                   .teFeat      [featl dxn] testing feature data
%                   .teLabel     [int 1xn] label for each testing feature
%                   .nbTeFeat    [int 1x1] number of testing feature in all database
%                   .nbTeFeatC   [int 1xc] number of testing feature per class
%                   .nbTeFeatF   [int 1xf] number of testing feature per file
%
%                   .toc         [dbl 1x1] features extraction time
%                   .type        [str 1x5] structure of the feature (typeA, typeM)
%
% Output
%   - same as input
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.08
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function feat = typeM(feat)
    
    % -------------------------------------------------------------------------------------------- %
    % Split input structure into independant variables
    % -------------------------------------------------------------------------------------------- %    

    dim        = feat.dim;
    nbFile     = feat.nbFile;
    
    trFeat     = feat.trFeat;
    fileTrFeId = feat.fileTrFeId;
    nbTrFeatF  = feat.nbTrFeatF;
    
    teFeat     = feat.teFeat;
    fileTeFeId = feat.fileTeFeId;
    nbTeFeatF  = feat.nbTeFeatF;
    
    
    % -------------------------------------------------------------------------------------------- %
    % Compute new feature matrix
    % -------------------------------------------------------------------------------------------- %    
    
    newDim = 2*dim;
    
    %%% Preallocation
    newTrFeat = zeros(newDim, nbFile);
    newTeFeat = zeros(newDim, nbFile);
    
    %%% For each file
    for fid = 1:nbFile,
        
        %%% Extract features for actual file
        trFileFeat = trFeat(:,fileTrFeId(fid):fileTrFeId(fid)+nbTrFeatF(fid)-1);
        teFileFeat = teFeat(:,fileTeFeId(fid):fileTeFeId(fid)+nbTeFeatF(fid)-1);
        
        %%% Compute mean feature of the exctract features
        meanTrFeat = mean(trFileFeat, 2);
        meanTeFeat = mean(teFileFeat, 2);
        
        %%% Compute std feaure of the extract features
        stdTrFeat = std(trFileFeat, 0, 2);
        stdTeFeat = std(teFileFeat, 0, 2);
        
        %%% Build new feature matrix
        newTrFeat(:,fid) = [meanTrFeat;stdTrFeat];
        newTeFeat(:,fid) = [meanTeFeat;stdTeFeat];
        
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Update struture fields
    % -------------------------------------------------------------------------------------------- % 

    feat.dim         = newDim;
    feat.classTrFeId = feat.classFiId;
    feat.classTeFeId = feat.classFiId;
    feat.fileTrFeId  = 1:feat.nbFile;
    feat.fileTeFeId  = 1:feat.nbFile;

    feat.trFeat      = newTrFeat;
    feat.trLabel     = feat.fileLabel;
    feat.nbTrFeat    = feat.nbFile;
    feat.nbTrFeatC   = feat.nbFileC;
    feat.nbTrFeatF   = ones(1, feat.nbFile);

    feat.teLabel     = feat.fileLabel;
    feat.nbTeFeat    = feat.nbFile;
    feat.nbTeFeatC   = feat.nbFileC;
    feat.nbTeFeatF   = ones(1, feat.nbFile);
    
    feat.type        = 'typeM';
    
end


% EoF -------------------------------------------------------------------------------------------- %
