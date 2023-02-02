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


function plotFeat(feat)

    if feat.dim < 4,
        
        %%% Extract usefull variable from input structure
        feature = feat.trFeat;
        label   = feat.trLabel;
        nbClass = feat.nbClass;
        dim     = feat.dim;

        %%% Create a figure
        figure('color', 'w');
        hold on;

        %%% Define color palette
        colorPalette = 'bkrgyc';
        nbColor = length(colorPalette);

        %%% Plot features for each class
        for cid = 1:nbClass,

            % Select plot color to attribute to actual class
            colorSel = colorPalette(mod(cid, nbColor));

            %%% Plot features to actual class
            switch dim,
                case 1, plot1DFeat(feature, label, cid, colorSel);
                case 2, plot2DFeat(feature, label, cid, colorSel);
                case 3, plot3DFeat(feature, label, cid, colorSel);
            end
            
        end
    
        %%% Plot parameters and labels
        grid on;
        legend(feat.className);
        title('Raw features')
        xlabel('Features value dim-1');
        ylabel('Features value dim-2');
        zlabel('Features value dim-3');
        if dim == 3,
            view(45, 45);
        end
        
    else % if features dimensions is greater than 3 generate a warning and plot nothing
        warning('SSRT:nop', ...
              'Features dimension is greater than 4 so plot function cannot be executed.');
    end
    
end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% Plot 1D features
% ------------------------------------------------------------------------------------------------ %

function plot1DFeat(feature, label, cid, colorSel)

    plot(feature(label==cid), zeros(1, sum(label==cid)), ['.',colorSel]);

end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% Plot 2D features
% ------------------------------------------------------------------------------------------------ %

function plot2DFeat(feature, label, cid, colorSel)

    plot(feature(1,label==cid), feature(2,label==cid), ['.',colorSel]);

end

 
% SUB FUNCTION ----------------------------------------------------------------------------------- %
% Plot 3D features
% ------------------------------------------------------------------------------------------------ %

function plot3DFeat(feature, label, cid, colorSel)

    plot3(feature(1,label==cid), feature(2,label==cid), feature(3,label==cid), ['.',colorSel]);

end


% EoF -------------------------------------------------------------------------------------------- %
