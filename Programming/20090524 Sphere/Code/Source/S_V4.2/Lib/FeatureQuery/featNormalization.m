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
%
% Output
%   - trFeat [struct] Training sets of features
%                       .feat    [dbl dxn] Normalized training feature data 
%                       .nbFeat  [int 1x1] Number of training features
%                       .nbFeatF [int 1xf] Number of training features per file.
%                       .nbFeatC [int 1xc] Number of training features per class.
%   - teFeat [struct] Testing sets of features
%                       .feat    [dbl dxm] Normalized testing feature data
%                       .nbFeat  [int 1x1] Number of testing features
%                       .nbFeatF [int 1xf] Number of testing features per file.
%                       .nbFeatC [int 1xc] Number of testing features per class.
%   - normParam [struct] Feature normalization paramerters
%                           .normMean [dbl dx1] Mean training vector
%                           .normStd  [dbl dx1] Std training vector
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.15
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

function [trFeat,teFeat,normParam] = featNormalization(trFeat, teFeat, plotFlag)
    
    % Compute mean for each dimension of training feature
    normParam.normMean = sum(trFeat.feat, 2)/trFeat.nbFeat;
    
    % Normalize the mean (mean = 0)
    trFeature = bsxfun(@minus, trFeat.feat, normParam.normMean);
    teFeature = bsxfun(@minus, teFeat.feat, normParam.normMean);
    
    % Compute std for each dimension of training feature (this version of std is the one with the 
    % Bessel correction (N-1))
    normParam.normStd = sqrt(sum(trFeature.^2, 2)/(trFeat.nbFeat-1));
    
    % Normalize the std (std = 1)
    trFeat.feat = bsxfun(@rdivide, trFeature, normParam.normStd);
    teFeat.feat = bsxfun(@rdivide, teFeature, normParam.normStd);
    
    
    %%% Plot
    if iscell(plotFlag) || plotFlag == true,
        switch trFeat.dim,
            case 1, plot1DFeat(trFeat, teFeat);
            case 2, plot2DFeat(trFeat, teFeat);
            case 3, plot3DFeat(trFeat, teFeat);
        end
    end

end


% FUNCTION --------------------------------------------------------------------------------------- %
% Plot 1D features
% ------------------------------------------------------------------------------------------------ %

function plot1DFeat(feat, label)

    figure;
    hold on;
    plot(feat(1,label==1), zeros(1, sum(label==1)), '.b');
    plot(feat(1,label==2), zeros(1, sum(label==2)), '*k');
    plot(feat(1,label==3), zeros(1, sum(label==3)), '.r');
    grid on;
        
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Plot 2D features
% ------------------------------------------------------------------------------------------------ %

function plot2DFeat(feat, label)

    figure;
    hold on;
    plot(feat(1,label==1), feat(2,label==1), '.b');
    plot(feat(1,label==2), feat(2,label==2), '.k');
    plot(feat(1,label==3), feat(2,label==3), '.r');
    grid on;
        
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Plot 3D features
% ------------------------------------------------------------------------------------------------ %

function plot3DFeat(trFeat, teFeat)

    figure;
    hold on;
    plot3(trFeat.feat(1,:), trFeat.feat(2,:), trFeat.feat(3,:), '.b');
    plot3(teFeat.feat(1,:), teFeat.feat(2,:), teFeat.feat(3,:), '.r');
    grid on;
        
end


% EoF -------------------------------------------------------------------------------------------- %
