% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Compute covariance matrix. This function does the same thing as "cov" Matlab function but is
% adapted to my needs.
%
% Input
%   - data      [dbl dxn] Data. Each column is an observation of d dimensions.
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

function covMatrix = cov_(data)

    % Evaluate number of data
    nbData = size(data, 2);
    
    %%% Normalize mean (mean = 0)
    dataMean = sum(data, 2) / nbData; % Compute mean
    dataC = bsxfun(@minus, data, dataMean); % Substract mean
    
    % Compute covariance matrix
    covMatrix = (dataC*dataC')/(nbData-1);
    
    %%% Dealing with special cases
    covMatrix(isnan(covMatrix)) = 0;
    covMatrix(isinf(covMatrix)) = 0;
    
end
 
% EoF -------------------------------------------------------------------------------------------- %
