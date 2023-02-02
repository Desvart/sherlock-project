% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function generate model based raw features. Its output simulates an output from a real 
% database features extraction.
%
% Input
%   - featParam [struct] Parameters of the features models.
%                        .mu      [double dxc]  Classes centro�ds
%                        .nbFileC [int 1x1] Number of files per class (same number for each classes)
%                              OR [int 1xc] Number of files per class
%                        .nbFeatF [int 1x1] Number of features per file (same number for each files)
%                              OR [int 1xf] Number of features per file
%
% Output
%   - feat [struct] Contains data, label and somes data properties.
%                   .nbClass     [int 1x1] number of class in database
%                   .className   [cell 1xc, str] Name of each class
%                   .nbFile      [int 1x1] number of file in all database
%                   .fileLabel   [int 1xf] file labels
%                   .nbFileC     [int 1xc] number of file per class
%                   .dim         [int 1x1] dimension of features
%                   .classFiId   [int 1xc] classes indexes view from file indexes
%                   .classTrFeId [int 1xc] classes indexes view from training feature indexes
%                   .classTeFeId [int 1xc] classes indexes view from testing feature indexes
%                   .fileTrFeId  [int 1xf] files indexes view from training feature indexes
%                   .fileTeFeId  [int 1xf] files indexes view from testing feature indexes
%
%                   .trFeat      [featl dxn] training feature data
%                   .trLabel     [int 1xn] label for each training feature
%                   .nbTrFeat    [int 1x1] number of training feature in all database
%                   .nbTrFeatC   [int 1xc] number of training feature per class
%                   .nbTrFeatF   [int 1xf] number of training feature per file
%
%                   .teFeat      [featl dxn] testing feature data
%                   .teLabel     [int 1xn] label for each testing feature
%                   .nbTeFeat    [int 1x1] number of testing feature in all database
%                   .nbTeFeatC   [int 1xc] number of testing feature per class
%                   .nbTeFeatF   [int 1xf] number of testing feature per file
%
%                   .toc         [dbl 1x1] features generation time
%                   .type        [str 1x5] structure of the feature (typeA, typeM)
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.08
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function feat = generateFeat(featParam)
    
    % Launch chrono for features generation time
    tic;
    
    % Signal beginning of the feature generation
    fprintf('Ongoing process: generating features...\n');

    % -------------------------------------------------------------------------------------------- %
    % Split input structure in independent variables
    % -------------------------------------------------------------------------------------------- %
    
    mu      = featParam.mu;
    nbFileC = featParam.nbFileC;
    nbFeatF = featParam.nbFeatF;

    
    % -------------------------------------------------------------------------------------------- %
    % Define features properties
    % -------------------------------------------------------------------------------------------- %

    [dim, nbClass] = size(mu);
    
    %%% if needed put scalar nbFileC input in array shape
    if isscalar(nbFileC),
        nbFileC = nbFileC * ones(1, nbClass);
    elseif length(nbFileC) ~= nbClass,
        error('Incorrect input: nbFilec should have nbClass elements.');
    end
    
    % Compute total number of files
    nbFile = sum(nbFileC);
    
    %%% if needed put scalar nbFeatF input in array shape
    if isscalar(nbFeatF),
        nbFeatF = nbFeatF * ones(1, nbFile);
    elseif length(nbFeatF) ~= nbFile,
        error('Incorrect input: nbFilef should have nbClass elements.');
    end
    
    % Compute total number of features
    nbFeat = sum(nbFeatF);
    
    %%% Compute number of features per class
    nbFeatC = zeros(1, nbClass); % Preallocation
    stop = 0; % Initialization
    for cid = 1:nbClass,
        start = stop + 1;
        stop  = start + nbFileC(cid) - 1;
        nbFeatC(cid) = sum(nbFeatF(start:stop));
    end

    
    % -------------------------------------------------------------------------------------------- %
    % Generate class names
    % -------------------------------------------------------------------------------------------- %
    
    className = cell(1, nbClass); % Preallocation
    for cid = 1:nbClass,
        className{cid} = ['Class ',num2str(cid)];
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Create unitary covariance matrix
    % -------------------------------------------------------------------------------------------- %
    
    sigma = zeros(dim, dim, nbClass); % Preallocation
    for cid = 1:nbClass,
        sigma(:,:,cid) = speye(dim);
    end
    
    %%% Define manually covariance matrix
%     sigma(:,:,1) = [5];
%     sigma(:,:,1) = [5 0.9 ;0.9 5];
%     sigma(:,:,1) = [1 0 0;0 1 0;0 0 1];
%     sigma(:,:,2) = [1 0 0;0 1 0;0 0 1];
%     sigma(:,:,3) = [1 0 0;0 1 0;0 0 1];
   
    
    % -------------------------------------------------------------------------------------------- %
    % Generate features
    % -------------------------------------------------------------------------------------------- %
    
    %%% Preallocation
    trFeat      = zeros(nbFeat, dim);
    featLabel   = zeros(1, nbFeat);
    fileLabel   = zeros(1, nbFile);
    
    %%% Initialization
    stop  = 0;
    stop1 = 0;
    
    %%% Generate features for each class, store them in one big array and determine their labels.
    for cid = 1:nbClass,
        
        %%% Compute absolut feature positions
        start = stop + 1;
        stop = start + nbFeatC(cid) - 1;
        
        % Compute features for actual class and store them in trFeat array
        trFeat(start:stop,:) = mvnrnd(mu(:,cid)', sigma(:,:,cid), nbFeatC(cid));
        
        % Determine feature labels
        featLabel(start:stop)  = cid * ones(1, nbFeatC(cid));
        
        %%% Determine file labels
        start1 = stop1 + 1;
        stop1  = start1 + nbFileC(cid) - 1;
        fileLabel(start1:stop1) = cid * ones(1, nbFileC(cid));
         
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Determine classes et files indexes with files and features indexes refrences
    % -------------------------------------------------------------------------------------------- %
    
    %%% Preallocation
    classFiId = zeros(1, nbClass);
    classFeId = zeros(1, nbClass);
    fileFeId  = zeros(1, nbFile);
    
    %%% This are the classes indexes from the file indexes and the feature indexes point of view
    for cid = 1:nbClass,
        classFiId(cid) = sum(nbFileC(1:cid-1)) + 1;
        classFeId(cid) = sum(nbFeatC(1:cid-1)) + 1;
    end
    
    %%% This are the files indexes from the feature indexes point of view
    for fid = 1:nbFile,
        fileFeId(fid) = sum(nbFeatF(1:fid-1)) + 1;
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Build output structure
    % -------------------------------------------------------------------------------------------- %
    
    %%% Data relative to simulated database
    feat.nbClass     = nbClass;
    feat.className   = className;
    feat.nbFile      = nbFile;
    feat.fileLabel   = fileLabel;
    feat.nbFileC     = nbFileC;
    feat.dim         = dim;
    feat.classFiId   = classFiId;
    feat.classTrFeId = classFeId;
    feat.classTeFeId = classFeId;
    feat.fileTrFeId  = fileFeId;
    feat.fileTeFeId  = fileFeId;
    feat.type        = 'typeA';
    
    %%% Data relative to training features
    feat.trFeat      = trFeat';
    feat.trLabel     = featLabel;
    feat.nbTrFeat    = nbFeat;
    feat.nbTrFeatF   = nbFeatF;
    feat.nbTrFeatC   = nbFeatC;
    
    %%% Data relative to testing features
    feat.teFeat      = trFeat';
    feat.teLabel     = featLabel;
    feat.nbTeFeat    = nbFeat;
    feat.nbTeFeatF   = nbFeatF;
    feat.nbTeFeatC   = nbFeatC;
    
    %%% Data for logging
    feat.toc         = toc;
    feat.type        = 'typeA';
    
    % Signal end of the feature generation
    fprintf('Features generated.\n\n');
    
end


% EoF -------------------------------------------------------------------------------------------- %
