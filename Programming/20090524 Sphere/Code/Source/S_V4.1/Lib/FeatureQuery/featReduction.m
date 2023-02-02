% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Create training and testing sets of data from previously created database. This selection is based
% on user defined learning strategy.
%
% Input
%   - trFeat [struct] Training sets of features
%                       .feat    [dbl dxn] Raw training feature data
%                       .nbFeat  [int 1x1] Number of training features
%                       .nbFeatF [int 1xf] Number of training features per file.
%                       .nbFeatC [int 1xc] Number of training features per class.
%   - teFeat [struct] Testing sets of features
%                       .feat    [dbl dxm] Raw testing feature data
%                       .nbFeat  [int 1x1] Number of testing features
%                       .nbFeatF [int 1xf] Number of testing features per file.
%                       .nbFeatC [int 1xc] Number of testing features per class.
%   - mapping [struct] Reduction mapping 
%                       .pca     [dbl dxa]
%                       .lda     [dbl axb]
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
%   - reductionParam [int 1x2] 
%
%
% Author    : Pitch Corp.
% Date      : 2010.12.06
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [trFeat,teFeat,mapping] = featReduction(trFeat, teFeat, reductionParam)
    
    %%% PCA
    mapping.pca = pca(trFeat.feat, reductionParam(1)); % Compute PCA mapping
    trFeat.feat = mapping.pca * trFeat.feat; % Apply PCA mapping on training set
    teFeat.feat = mapping.pca * teFeat.feat; % Apply PCA mapping on testing set
    
    %%% LDA
    mapping.lda = lda(trFeat.feat, trFeat.label, reductionParam(2)); % Compute LDA mapping
    trFeat.feat = mapping.lda * trFeat.feat; % Apply PCA mapping on training set
    teFeat.feat = mapping.lda * teFeat.feat; % Apply LDA mapping on testing set
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% PCA 
% Warning : As features have been previously normalized, no normalization is applied in this PCA
%
% Author        : Pitch Corp.
% Inspired from : Laurens van der Maaten, 2010
% ------------------------------------------------------------------------------------------------ %

function PCAmapping = pca(feat, nbDim)

	% Compute covariance matrix
    covMatrix = cov_(feat);
	
	% Perform eigendecomposition of covMatrix
    [eigVect,eigVal] = eig(covMatrix);
    
    %%% Sort eigenvectors in descending order
    [eigVal, id] = sort(diag(eigVal), 'descend');
    eigVect = eigVect(:,id);
    
    %%% Reduce dimension if needed
    maxDim = size(eigVect, 2);
    if nbDim > maxDim,
        nbDim = maxDim;
        warning(['Target dimensionality reduced to ',num2str(nbDim),'.']); %#ok<WNTAG>
    end
	eigVect = eigVect(:,1:nbDim);
    eigVal  = eigVal(1:nbDim);
	
    % Normalize PCAmapping
    PCAmapping = diag(1./sqrt(eigVal))*eigVect;

end


% FUNCTION --------------------------------------------------------------------------------------- %
% LDA 
% Warning : As features have been previously normalized, no normalization is applied in this LDA
% Ref.: "LINEAR DISCRIMINANT ANALYSIS FOR SIGNAL PROCESSING PROBLEMS", S. Bahkrishnama
%
% Original author : Laurens van der Maaten, 2010
% Modification    : Pitch Corp.
% ------------------------------------------------------------------------------------------------ %

function LDAmapping = lda(feat, label, nbDim)
    
    [dim,nbFeat] = size(feat);
    nbClass = max(label);
    
    % Preallocation (Within-class scatter matrix)
    Sw = zeros(dim, dim);
    
    % Compute mixture scatter matrix
    Sm = feat*feat'/(nbFeat-1);
    
    % Sum over classes
    for i = 1:nbClass,
        curFeat = feat(:,label==i);
        p = size(curFeat, 2)/(nbFeat-1);
        Sw = Sw + p*cov(curFeat');
    end
    
    % Compute between class scatter matrix
    Sb = Sm - Sw;
    Sb(isnan(Sb)) = 0;
    Sb(isinf(Sb)) = 0;
    Sw(isnan(Sw)) = 0;
    Sw(isinf(Sw)) = 0;
    
    % make sure not to embed in too high dimension
    if nbClass <= nbDim,
        nbDim = nbClass - 1;
        warning(['Target dimensionality reduced to ',num2str(nbDim),'.']); %#ok<WNTAG>
    end
    
    % Perform eigen decomposition of inv(Sw)*Sb
    [eigVect,eigVal] = eig(Sb, Sw);
    eigVal(isnan(eigVal)) = 0;
    
    % Sort eigenvalues and eigenvectors in descending order
    [~,id] = sort(diag(eigVal), 'descend');
    LDAmapping = eigVect(:,id(1:min(nbDim, size(eigVect, 2))));
    
end


% EoF -------------------------------------------------------------------------------------------- %































