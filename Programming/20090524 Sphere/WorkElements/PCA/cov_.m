% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Compute covariance matrix. This function does the same thing as "cov" Matlab function but is
% adapted to my needs.
%
% Input
%   - data      [dbl dxn]   Data. Each column is an observation of d dimensions.
%   - normFlag  [bool 1x1]  True  : normalize data such as mean = 0;
%                           False : do not normalize data
%
% Output
%   - covMatrix [dbl dxd] Covariance matrix.
%
%
% Author    : Pitch Corp.
% Date      : 2010.12.06
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function covMatrix = cov_(data, normFlag)

    %%% Check inputs
    error(nargchk(1, 2, nargin));
    if nargin == 1,
        normFlag = 1;
    end
    
    % Evaluate number of data
    [dim,nbData] = size(data);
    
    %%% Normalize mean (mean = 0)
    if normFlag,
        dataMean = sum(data, 2) / nbData; % Compute mean
        dataC = bsxfun(@minus, data, dataMean); % Substract mean
    end
    
    % Compute covariance matrix
    if nbData < dim,
        covMatrix = (dataC*dataC')/(nbData-1);
    else
        % if nbData > dim, we better use this matrix for the eigendecomposition (deal with numerical convergence)
        covMatrix = (dataC*dataC')/nbData;
    end
    
    %%% Dealing with special cases
    covMatrix(isnan(covMatrix)) = 0;
    covMatrix(isinf(covMatrix)) = 0;
    
end
 
% EoF -------------------------------------------------------------------------------------------- %
