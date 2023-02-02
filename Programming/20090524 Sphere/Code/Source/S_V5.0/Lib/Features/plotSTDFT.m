% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% Plot features if their dimensions are lower than 4.
%
% Input
%   - feat [struct] Contains data, label and somes data properties.
%                   .nbClass    [int 1x1] number of class in database
%                   .className  [cell cx1, str] Name of each class
%                   .dim        [int 1x1] dimension of features
%                   .trFeat     [featl dxn] training feature data
%                   .trLabel    [int 1xn] label for each training feature
%
% Output
%   - 
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.04
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function plotSTDFT(feat)

    %%% Extract usefull variable from input structure
    feature = feat.trFeat;

    %%% Create a figure
    figure('color', 'w');
    
%     pcolor(feature);
    mesh(feature);
    shading flat;
    
end


% EoF -------------------------------------------------------------------------------------------- %
