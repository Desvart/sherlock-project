% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Training structure
%
% Input
%   - trFeat     [struct]
%   - modelParam [struct]  Feature extraction parameters
%                          .pca   [int 1x1] Number of dimensions to keep in PCA reduction.
%                          .lda   [int 1x1] Number of dimensions to keep in LCA reduction.
%                          .nbGMM [int 1x1] Number of GMM to model the features.
%                          .emTol [dbl 1x1] Tolerance for EM convergence.
%   - [bool]     [bool 1x1] If true, the function give the model structure for preallocation. Else,
%                           do the normal training.
%
% Output
%   - model [struct] Training model
%                    .alpha   [dbl 1xc]   Weighting factor.
%                    .mu      [dbl dxn]   Class mean vectors.
%                    .cova    [dbl cxdxd] Class covariance matrix.
%                    .muNorm  [dbl dx1]   Features mean normalization.
%                    .stdNorm [dbl dx1]   Features standard deviation normalization.
%                    .redMat  [dbl dxD]   Features reduction matrix.
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.09
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function model = trainingGMM(trFeat, modelParam, bool)

    % -------------------------------------------------------------------------------------------- %
    % Given model structure
    % -------------------------------------------------------------------------------------------- %
    
    if nargin == 3 && bool == true,
        model = modelStructure(trFeat.nbClass, trFeat.dim, modelParam.pca, modelParam.lda);
        return;
    end

    
    % -------------------------------------------------------------------------------------------- %
    %
    % -------------------------------------------------------------------------------------------- %
    
    

end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% Preallocate model structure
% ------------------------------------------------------------------------------------------------ %

function model = modelStructure(nbClass, oldDim, pcaDim, ldaDim)
    
    dim = max(0, min([oldDim, pcaDim, ldaDim]));

    model.alpha   = zeros(1, nbClass);
    model.mu      = zeros(dim, nbClass);
    model.cova    = zeros(nbClass, dim, dim);
    model.muNorm  = zeros(dim, 1);
    model.stdNorm = zeros(dim, 1);
    model.redMat  = zeros(dim, oldDim);
     
end


% EoF -------------------------------------------------------------------------------------------- %
