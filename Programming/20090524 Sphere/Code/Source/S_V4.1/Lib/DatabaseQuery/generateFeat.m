% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function substitute a real database by generating 1, 2 or 3D features based on mathematical 
% models. Training and testing feature are exactly the same.
%
% Input
%   - dim      [int 1x1]  Dimension of the features
%   - plotFlag [bool 1x1] (OPT) If true, plots data. Default : false.
%
% Output
%   - db [struct]   Contains data, label and somes data properties.
%                   .nbClass    [int 1x1] number of class in database
%                   .className  [cell cx1, str] Name of each class
%                   .nbFile     [int 1x1] number of file in all database
%                   .nbFileC    [int 1xc] number of file per class
%                   .dim        [int 1x1] dimension of features
%
%                   .trFeat       [dbl dxn] training feature data
%                   .trLabel      [int 1xn] label for each training feature
%                   .nbTrFeat     [int 1x1] number of training feature in all database
%                   .nbTrFeatC    [int 1xc] number of training feature per class
%                   .nbTrFeatF    [int 1xf] number of training feature per file
%
%                   .teFeat       [dbl dxn] testing feature data
%                   .teLabel      [int 1xn] label for each testing feature
%                   .nbTeFeat     [int 1x1] number of testing feature in all database
%                   .nbTeFeatC    [int 1xc] number of testing feature per class
%                   .nbTeFeatF    [int 1xf] number of testing feature per file
%
%                   .realFeatFlag [bool 1x1] if true, features come from mathematical models,
%                                            else they come from real physical data.
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.09
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

% TODO ------------------------------------------------------------------------------------------- %
% - AGROW
% ------------------------------------------------------------------------------------------------ %

function db = generateFeat(dim, plotFlag)
    
    %%% Check inputs
    error(nargchk(1, 2, nargin));
    if nargin == 1,
        plotFlag = false;
    end

    %%% Define database properties
    nbClass      = 3;
    nbFilec      = 20;
    nbFeatf      = 30;

    nbFileC   = nbFilec * ones(1, nbClass);
    nbFile    = sum(nbFileC);
    
    nbTrFeatF = nbFeatf * ones(1, nbFile);
    nbTrFeatC = nbTrFeatF(1) * nbFileC(1) * ones(1, nbClass);
    nbTrFeat  = sum(nbTrFeatF);

    className    = cell(nbClass, 1);
    for cid = 1:nbClass,
        className{cid} = ['Class',num2str(cid)];
    end
    
    %%% Define mathematical model parameters for feature generation
%     alpha           = ones(1, nbClass) / nbClass;
    switch dim,
        case 1,
            mu              = [0 5 10];
            sigma(:,:,1)    = 1;
            sigma(:,:,2)    = 1;
            sigma(:,:,3)    = 1;
            
        case 2,
            mu              = [[0 0]' [9 0]' [0 9]'];
            sigma(:,:,1)    = [1 0;0 1];
            sigma(:,:,2)    = [1 0;0 1];
            sigma(:,:,3)    = [1 0;0 1];
            
        case 3,
            mu              = [[0 0 0]' [9 0 0]' [0 0 9]'];
            sigma(:,:,1)    = [1 0 0;0 1 0;0 0 1];
            sigma(:,:,2)    = [1 0 0;0 1 0;0 0 1];
            sigma(:,:,3)    = [1 0 0;0 1 0;0 0 1];
            
        otherwise
            error('This function can generate only 1, 2 or 3D features, nothing else.');
    end
 
    %%% Generate features
    feat  = [];
    label = [];
    classFId = zeros(1, nbClass);
    for cid = 1:nbClass,
        feat  = [feat,mvnrnd(mu(:,cid), sigma(:,:,cid), nbTrFeatC(cid))'];  %#ok<AGROW>
        label = [label,cid*ones(1, nbTrFeatC(cid))];                        %#ok<AGROW>
        classFId(cid) = sum(nbFileC(1:cid-1)) + 1;
    end
    
%     feat = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 1 71 81 920 21 22 23;...
%             0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 1 71 81 920 21 22 23];
%     feat = bsxfun(@plus, feat, [100;200]);
%     label = [ones(1, 12),2*ones(1, 12)];
    
    
    %%% Build output structure
    db.nbClass      = nbClass;
    db.classFId     = classFId;
    db.className    = className;
    db.nbFile      	= nbFile;
    db.nbFileC      = nbFileC;
    db.dim          = dim;
    db.realFeatFlag = false;  
    
    db.trFeat       = feat;
    db.trLabel      = label;
    db.nbTrFeat     = nbTrFeat;
    db.nbTrFeatF    = nbTrFeatF;
    db.nbTrFeatC    = nbTrFeatC;
    
    db.teFeat       = feat;
    db.teLabel      = label;
    db.nbTeFeat     = nbTrFeat;
    db.nbTeFeatF    = nbTrFeatF;
    db.nbTeFeatC    = nbTrFeatC;
    

    %%% Plot
    if iscell(plotFlag) || plotFlag == true,
        switch dim,
            case 1, plot1DFeat(feat, label);
            case 2, plot2DFeat(feat, label);
            case 3, plot3DFeat(feat, label);
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

function plot3DFeat(feat, label)

    figure;
    hold on;
    plot3(feat(1,label==1), feat(2,label==1), feat(3,label==1), '.b');
    plot3(feat(1,label==2), feat(2,label==2), feat(3,label==2), '.k');
    plot3(feat(1,label==3), feat(2,label==3), feat(3,label==3), '.r');
    grid on;
        
end


% EoF -------------------------------------------------------------------------------------------- %
