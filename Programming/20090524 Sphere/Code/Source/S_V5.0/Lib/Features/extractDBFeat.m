% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function extracts features from all file of a database. This features are concatenate in a
% big array. An additional vector contains the labels related to this extracted features.
%
% Input
%   - dbProp       [struct] Database properties
%                           .path [str 1xp] Database path
%                           .snr  [int 1x2] Training and testing SNR
%   - extractParam [struct] Feature extraction parameters
%                           .h_extract [function_handle] Function to extract desired features
%                           .window  [dbl 1xw] window to apply the STDFT
%                           .shift   [dbl 1x1] STDFT shift
%                           .powThr  [int 1x1] Power threshold.
%                           .channel [dbl 1xn] Channel bands
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
%                   .toc         [dbl 1x1] features extraction time
%                   .type        [str 1x5] structure of the feature (typeA, typeM)
%
%
% Author    : Pitch Corp.
% Date      : 2011.01.08
% Version   : 0.5.0
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function feat = extractDBFeat(dbProp, featParam)

    % Launch chrono for features extraction time
    tic;
    
    % Signal beginning of the feature extraction
    fprintf('Ongoing process: extracting features...\n');
    
    % -------------------------------------------------------------------------------------------- %
    % Extract database statistics
    % -------------------------------------------------------------------------------------------- %
    
    % Extact the number of class and their names
    [nbClass,className] = folderInventory(dbProp.path);
    
    %%% Extract number of files per class
    nbFileC = zeros(1, nbClass); % Preallocation
    for i = 1:nbClass,
        nbFileC(i) = folderInventory([dbProp.path,className{i}]);
    end
    
    % Compute number of total file
    nbFile = sum(nbFileC);
    
    % Determine if SNR levels between training and testing are equal.
    snrFlag   = dbProp.snr(1) ~= dbProp.snr(2);
    
    
    % -------------------------------------------------------------------------------------------- %
    % Preallocations, Initialization
    % -------------------------------------------------------------------------------------------- %
    
    %%% Preallocation
    nbTrFeatC = zeros(1, nbClass);
    nbTeFeatC = zeros(1, nbClass);
    trFeat    = [];
    teFeat    = [];
    nbTrFeatF = [];
    nbTeFeatF = [];
    
    % Initialization
    h_extract = featParam.h_extract;
    
    
    % -------------------------------------------------------------------------------------------- %
    % Create waitbar
    % -------------------------------------------------------------------------------------------- %
    
    h = waitbar(0, ['File being processed: : 1/',int2str(nbFile)], ...
                    'Name', 'Feature extraction in progress...');
                
    
	% -------------------------------------------------------------------------------------------- %
    % Extraction loop
    % -------------------------------------------------------------------------------------------- %

    %%% for each class
    for cid = 1:nbClass,

        % Extract file names for this class
        [~,fileName] = folderInventory([dbProp.path,className{cid}]);
        
        %%% Preallocation
        nbTrFeat    = zeros(nbFileC(i), 1);
        nbTeFeat    = zeros(nbFileC(i), 1);
        classTrFeat = [];
        classTeFeat = [];
        
        % Initialization
        classPath   = [dbProp.path,className{cid},'/'];
        
        
        %%% For each file
        for fid = 1:nbFileC(cid),

            % Extract signal
            [signal,fs] = extractSignal([classPath,fileName{fid}]);
            
            
          	% ------------------------------------------------------------------------------------ %
            % Extract signal features for training feature set
            % ------------------------------------------------------------------------------------ %
            
            % Add noise to signal
            noisedSignal = addNoise(signal, dbProp.snr(1));
    
            % Extract feature vectors for this file
            [fileFeat,nbTrFeat(fid)] = h_extract(noisedSignal, fs, featParam);
            
            % Concatenate features
            classTrFeat = [classTrFeat,fileFeat]; %#ok<AGROW>
            
            
            % ------------------------------------------------------------------------------------ %
            % For testing feature set
            % ------------------------------------------------------------------------------------ %
            % If training and testing SNR are different, start again extraction but with a different
            % SNR level.
            
            if snrFlag,
                % Add noise to signal
                noisedSignal = addNoise(signal, dbProp.snr(2));

                % Extract feature vectors for this file
                [fileFeat,nbTeFeat(fid)] = h_extract(noisedSignal, fs, featParam);

                % Concatenate features
                classTeFeat = [classTeFeat,fileFeat]; %#ok<AGROW>
            end
            
            
            % ------------------------------------------------------------------------------------ %
            % Update waitbar
            % ------------------------------------------------------------------------------------ %
            
            incId = sum(nbFileC(1:cid-1)) + fid; % Compute absolute file index
            waitbarLabel = sprintf('File being processed : %d/%d', incId, nbFile);
            waitbar(incId/nbFile, h, waitbarLabel);

        end
        
        
        % ---------------------------------------------------------------------------------------- %
        % Concatenate all features
        % ---------------------------------------------------------------------------------------- %
        
        trFeat       = [trFeat,classTrFeat]; %#ok<AGROW>
        nbTrFeatC(i) = sum(nbTrFeat);
        nbTrFeatF    = [nbTrFeatF;nbTrFeat]; %#ok<AGROW>
               
        if snrFlag,
            teFeat       = [teFeat,classTeFeat]; %#ok<AGROW>
            nbTeFeatC(i) = sum(nbTeFeat);
            nbTeFeatF    = [nbTeFeatF;nbTeFeat]; %#ok<AGROW>
        end   
        
    end


    % -------------------------------------------------------------------------------------------- %
    % Determine label for each features vectors
    % -------------------------------------------------------------------------------------------- %
   
%     [trLabel,nbTrFeat] = determineFeatLabel(nbClass, nbTrFeatC);
    [featTrLabel,nbTrFeat, fileLabel] = determineFeatLabel(nbClass, nbTrFeatC, nbFileC);
    
    if snrFlag,
        [featTeLabel,nbTeFeat] = determineFeatLabel(nbClass, nbTeFeatC, nbFileC);
%         [teLabel,nbTeFeat] = determineFeatLabel(nbClass, nbTeFeatC);
    else
        featTeLabel  = featTrLabel;
        nbTeFeat = nbTrFeat;
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Determine classes and files indexes with files and features indexes refrences
    % -------------------------------------------------------------------------------------------- %    
    
    %%% Preallocation
    classFiId   = zeros(1, nbClass);
    classTrFeId = zeros(1, nbClass);
    classTeFeId = zeros(1, nbClass);
    fileTrFeId  = zeros(1, nbFile);
    fileTeFeId  = zeros(1, nbFile);
    
    %%% This are the classes indexes from the file indexes and the feature indexes point of view
    for cid = 1:nbClass,
        
        classFiId(cid) = sum(nbFileC(1:cid-1)) + 1;
        
        classTrFeId(cid) = sum(nbTrFeatC(1:cid-1)) + 1; 
        
        if snrFlag,
            classTeFeId(cid) = sum(nbTeFeatC(1:cid-1)) + 1;
        else
            classTeFeId(cid) = classTrFeId(cid);
        end
        
    end
    
    %%% This are the files indexes from the feature indexes point of view
    for fid = 1:nbFile,
        
        fileTrFeId(fid) = sum(nbTrFeatF(1:fid-1)) + 1;
        
        if snrFlag,
            fileTeFeId(fid) = sum(nbTeFeatF(1:fid-1)) + 1;
        else
            fileTeFeId(fid) = fileTrFeId(fid);
        end
        
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Delete waitbar
    % -------------------------------------------------------------------------------------------- %
    
    delete(h);
    
    
    % -------------------------------------------------------------------------------------------- %
    % Build output structure
    % -------------------------------------------------------------------------------------------- %

    %%% Data relative to database
    feat.nbClass     = nbClass;
    feat.className   = className;
    feat.nbFile      = nbFile;
    feat.fileLabel   = fileLabel;
    feat.nbFileC     = nbFileC;
    feat.dim         = size(trFeat, 1);
    feat.classFiId   = classFiId;
    feat.classTrFeId = classTrFeId;
    feat.classTeFeId = classTeFeId;
    feat.fileTrFeId  = fileTrFeId;
    feat.fileTeFeId  = fileTeFeId;
    
    %%% Data relative to training features
    feat.trFeat      = trFeat;
    feat.trLabel     = featTrLabel;
    feat.nbTrFeat    = nbTrFeat;
    feat.nbTrFeatF   = nbTrFeatF;
    feat.nbTrFeatC   = nbTrFeatC;
    
    %%% Data relative to testing features
    feat.teFeat      = teFeat;
    feat.teLabel     = featTeLabel;
    feat.nbTeFeat    = nbTeFeat;
    feat.nbTeFeatF   = nbTeFeatF;
    feat.nbTeFeatC   = nbTeFeatC;
    
    %%% Data for logging
    feat.toc         = toc;
    feat.type        = 'typeA';
    
    % Signal end of the feature extraction
    fprintf('Features extracted.\n\n');

end


% SUB FUNCTION ----------------------------------------------------------------------------------- %
% Generate the label vector associated with each feature.
% ------------------------------------------------------------------------------------------------ %

function [featLabel,nbFeat, fileLabel] = determineFeatLabel(nbClass, nbFeatC, nbFileC)
    
    %%% Compute total number of feature and files
    nbFeat = sum(nbFeatC);
    nbFile = sum(nbFileC);
    
    %%% Preallocation
    featLabel = zeros(1, nbFeat);
    fileLabel = zeros(1, nbFile);
    
    %%% Initialization
    stop  = 0; 
    stop1 = 0;
    
    %%% For each class
    for cid = 1:nbClass,
        
        %%% Determine feature labels
        start = stop + 1;
        stop  = start + nbFeatC(cid) - 1;
        featLabel(start:stop) = cid * ones(1, nbFeatC(cid));
        
        %%% Determine file labels
        start1 = stop1 + 1;
        stop1  = start1 + nbFileC(cid) - 1;
        fileLabel(start1:stop1) = cid * ones(1, nbFileC(cid));
    end
    
end


% EoF -------------------------------------------------------------------------------------------- %
