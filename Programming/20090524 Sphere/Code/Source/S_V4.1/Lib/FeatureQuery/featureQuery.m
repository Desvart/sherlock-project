% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Create training and testing sets of data from previously created database. This selection is based
% on user defined learning strategy.
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
%   - learningParam  [dbl 1xn]
%   - reductionParam [int 1x2]
%
% Output
%   - trFeat [struct] Training sets of features
%   - teFeat [struct] Testing sets of features
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.15
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [trFeat,teFeat] = featureQuery(db, learningParam, reductionParam, plotFlag)
    
    %%% Select file indices to build training and testing data sets
    if learningParam(1) == 0, % If we are in mode "one left and do all crossvalidation"
        [trFile,teFile] = generateFileList0(db, false);
	
    elseif learningParam(1) == 1, % If we are in mode "one left"
        [trFile,teFile] = generateFileList0(db, learningParam(2));
        
    elseif learningParam(1) > 0 && learningParam(1) < 1, % If we are in mode "normal"
        [trFile,teFile] = generateFileList(db, learningParam(1), learningParam(2));
    end
    
    % Extract training and testing features linked to selected training and testing files
    [trFeat,teFeat] = featSelection(db, trFile, teFile);
    
    % Normalize features (mean = 0; std = 1)
    [trFeat,teFeat] = featNormalization(trFeat, teFeat, plotFlag);
    
    % Map features in a better space representation and reduce feature dimension
    [trFeat,teFeat] = featReduction(trFeat, teFeat, reductionParam);
    
end


% EoF -------------------------------------------------------------------------------------------- %
