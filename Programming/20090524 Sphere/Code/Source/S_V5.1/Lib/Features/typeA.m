% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Type A consists in sequence of feature vectors extracted threw time. This feature vectors belong
% to the same file but are processed as they were comming from other file of the same class. This
% strategy allows to take account of the time evolution of the features but in the other hand
% increase the intra-class dispersion of this class. This implies decreasing performance of a
% recognition process. A better way to take into account the time evolution of the features is to 
% use HMM models, but it is a lot more computationnal.
% Features are originally type A. They do not need any conversion to this type.
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


function feat = typeA(feat)

    feat.type = 'typeA';

end


% EoF -------------------------------------------------------------------------------------------- %
