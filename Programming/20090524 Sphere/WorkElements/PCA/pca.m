% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Compute PCA mapping matrix
%
% Input
%   - data      [dbl dxn]   Data. Each column is an observation of d dimensions.
%   - nbDim     [int 1x1]   Number of dimension to keep after mapping
%   - normFlag  [bool 1x1]  True  : normalize data such as mean = 0 and std = 1
%                           False : do not normalize data
%
% Output
%   - pcaMapping [dbl dxd] PCA mapping matrix
%
%
% Author    : Pitch Corp.
% Date      : 2010.12.06
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function pcaMapping = pca(data, nbDim, normFlag)

    %%% Check inputs
    error(nargchk(1, 2, nargin));
    if nargin <= 2,
        normFlag = 1;
    end
    if nargin == 1,
        nbDim = inf;
    end
    
    % Evaluate number of data
    [dim,nbData] = size(data);

    %%% Normalize data
    if normFlag,
        %%% Normalize mean (=0)
        dataMean = sum(data, 2)/nbData; % Compute mean
        dataC = bsxfun(@minus, data, dataMean); % Substract mean from data
        %%% Normalize std (=1)
%         dataStd = sqrt(sum(dataC.^2, 2)/(nbData-1)); % Compute std
%         dataC = bsxfun(@rdivide, dataC, dataStd); % Divide std from data
    end

    % Compute covariance matrix
    covMatrix = (dataC*dataC')/nbData;

    % Perform eigen decomposition of covMatrix
    [eigVect,eigVal] = eig(covMatrix);

    %%% Sort eigen values and vectors in descending order
    [eigVal,id] = sort(diag(eigVal), 'descend');
    eigVect = eigVect(:,id);

    %%% Reduce dimension if needed
    if nbDim > dim,
        nbDim = dim;
        warning(['Target dimensionality reduced to ',num2str(nbDim),'.']); %#ok<WNTAG>
    end
    pcaMapping = eigVect(:,1:nbDim);
    eigVal     = eigVal(1:nbDim);

    % PCA normalization
    % What the hell is this normalization for ?
%     PCAmapping = diag(1./sqrt(eigVal))*PCAmapping;

end

% EoF -------------------------------------------------------------------------------------------- %
