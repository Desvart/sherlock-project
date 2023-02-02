% FILE DESCRIPTION ------------------------------------------------------------------------------- %
%
% This function extracts features from all file of a database. This features are concatenate in a
% big array. An additional vector contains the labels related to this extracted features.
%
% Input
%   - dbPath [str]      Database path
%   - snr    [int 1x2]  SNR for training and testing sounds
%   - featExtractParam [dbl 1xn] Feature extraction parameters
%
% Output
%   - db [struct]   Contains data, label and somes data properties.
%                   .nbClass    [int 1x1] number of class in database
%                   .classFId   [int 1xc] class index in "file space"
%                   .className  [cell cx1, str] Name of each class
%                   .nbFile     [int 1x1] number of file in all database
%                   .nbFileC    [int 1xc] number of file per class
%                   .dim        [int 1x1] dimension of features
%
%                   .trFeat     [dbl dxn] training feature data
%                   .trLabel    [int 1xn] label for each training feature
%                   .nbTrFeat   [int 1x1] number of training feature in all database
%                   .nbTrFeatC  [int 1xc] number of training feature per class
%                   .nbTrFeatF  [int 1xf] number of training feature per file
%
%                   .teFeat     [dbl dxm] testing feature data
%                   .teLabel    [int 1xm] label for each testing feature
%                   .nbTeFeat   [int 1x1] number of testing feature in all database
%                   .nbTeFeatC  [int 1xc] number of testing feature per class
%                   .nbTeFeatF  [int 1xf] number of testing feature per file
%
%                   .realFeatFlag [bool 1x1] if true, features come from mathematical models,
%                                            else they come from real physical data.
%
%
% Author    : Pitch Corp.
% Date      : 2010.11.10
% Version   : 0.4.1
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

% TODO ------------------------------------------------------------------------------------------- %
% - AGROW
% ------------------------------------------------------------------------------------------------ %

function db = extractDatabaseFeat(dbPath, snr, featExtractParam)

    %%% Check inputs
    error(nargchk(3, 3, nargin));
    
    % Extact the number of class and their names
    [nbClass,className] = folderInventory(dbPath);
    
    %%% Extract number of file per class
    nbFileC = zeros(1, nbClass);
    for i = 1:nbClass,
        nbFileC(i) = folderInventory([dbPath,className{i}]);
    end
    
    % Compute number of total file
    nbFile = sum(nbFileC);
    
    %%% Preallocation
    nbTrFeatC = zeros(1, nbClass);
    nbTeFeatC = zeros(1, nbClass);
    classFId = zeros(1, nbClass);
    trFeat    = [];
    teFeat    = [];
    nbTrFeatF = [];
    nbTeFeatF = [];
    snrFlag   = snr(1) ~= snr(2);
    
    %%% Create waitbar
    h = waitbar(0, ['File being processed: : 1/',int2str(nbFile)], ...
                    'Name', 'Feature extraction in progress...');

	%%% for each class
    for i = 1:nbClass,

        % Extract file names for this class
        [~,fileName] = folderInventory([dbPath,className{i}]);

        %%% Preallocation
        nbTrFeat    = zeros(nbFileC(i), 1);
        nbTeFeat    = zeros(nbFileC(i), 1);
        classTrFeat = [];
        classTeFeat = [];
        classPath   = [dbPath,className{i},'/'];
        
        %%% For each file
        for j = 1:nbFileC(i),

            % Extract signal
            [signal,fs] = extractSignal([classPath,fileName{j}]);
            
            % Add noise to signal
            noisedSignal = addNoise(signal, snr(1));
            
            % Extract features from signal
            [fileTrFeat,nbTrFeat(j)] = extractSignalFeat(noisedSignal, fs, featExtractParam);
            
            % Concatenate features
            classTrFeat = [classTrFeat,fileTrFeat]; %#ok<AGROW>
            
            %%% if training and testing SNR are different, start again noising and extraction
            if snrFlag,
                
                % Add noise to signal
                noisedSignal = addNoise(signal, snr(2));
                
                % Extract and concatenate features from each signal    
                [fileTeFeat,nbTeFeat(j)] = extractSignalFeat(noisedSignal, fs, featExtractParam);
                
                % Concatenate features
                classTeFeat = [classTeFeat,fileTeFeat]; %#ok<AGROW>
                
            end
            
            %%% Update waitbar
            incId = sum(nbFileC(1:i-1))+j; % Compute absolute file index
            waitbarLabel = sprintf('File being processed: : %d/%d', incId, nbFile);
            waitbar(incId/nbFile, h, waitbarLabel);

        end %for j = 1:nbFile,
        

        %%% Concatenate all features
        trFeat       = [trFeat,classTrFeat]; %#ok<AGROW>
        nbTrFeatC(i) = sum(nbTrFeat);
        nbTrFeatF    = [nbTrFeatF;nbTrFeat]; %#ok<AGROW>
        
        if snrFlag,
            teFeat       = [teFeat,classTeFeat]; %#ok<AGROW>
            nbTeFeatC(i) = sum(nbTeFeat);
            nbTeFeatF    = [nbTeFeatF;nbTeFeat]; %#ok<AGROW>
        end
        
        % Class index in "file space"
        classFId(cid) = sum(nbFileC(1:cid-1)) + 1;
        
        % Class index in "training feature space"
%         classTrFId(cid) = sum(1:nbTrFeatC(cid-1)) + 1;
        
        % Class index in "testing feature space"
%         classTeFId(cid) = sum(1:nbTeFeatC(cid-1)) + 1;

    end %for i = 1:nbClass

    %%% Determine label for each features vectors
    [trLabel,nbTrFeat] = determineFeatLabel(nbClass, nbTrFeatC);
    if snrFlag,
        [teLabel,nbTeFeat] = determineFeatLabel(nbClass, nbTeFeatC);
    else
        teLabel  = trLabel;
        nbTeFeat = nbTrFeat;
    end
    
    % Remove waitbar
    delete(h); 
    
    %%% Compute some statistics
    

    %%% Build output structure
    db.nbClass      = nbClass;
    db.classFId     = classFId;
    db.className    = className;
    db.nbFile      	= nbFile;
    db.nbFileC      = nbFileC;
    db.dim          = size(trFeat, 1);
    db.realFeatFlag = true;
    
    db.trFeat       = trFeat;
    db.trLabel      = trLabel;
    db.nbTrFeat     = nbTrFeat;
    db.nbTrFeatF    = nbTrFeatF;
    db.nbTrFeatC    = nbTrFeatC;
    
    db.teFeat       = teFeat;
    db.teLabel      = teLabel;
    db.nbTeFeat     = nbTeFeat;
    db.nbTeFeatF    = nbTeFeatF;
    db.nbTeFeatC    = nbTeFeatC;
    
    
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Select the appropriate feature extraction
% ------------------------------------------------------------------------------------------------ %

function [fileFeat,nbFeat] = extractSignalFeat(signal, fs, featExtractParam)

    %%% Extract feature vectors for this file
    switch featExtractParam(1),

        % Spectrogram features
        case 1, [fileFeat,nbFeat] = extract_spectrogram(signal, fs, featExtractParam);

        % MFCC features
        case 2, [fileFeat,nbFeat] = extract_MFCC(signal, fs, featExtractParam);

    end
    
end


% FUNCTION --------------------------------------------------------------------------------------- %
% Generate the label vector associated with each feature.
% ------------------------------------------------------------------------------------------------ %

function [label,nbFeat] = determineFeatLabel(nbClass, nbFeatC)
    
    % Compute number of feature
    nbFeat = sum(nbFeatC);
    
    % Preallocation
    label = zeros(1, nbFeat); 
    
    % Initialization
    stop = 0; 
    
    %%% For each class
    for i = 1:nbClass,
        start = stop + 1;
        stop  = start + nbFeatC(i) - 1;
        label(start:stop) = i * ones(1, nbFeatC(i));
    end
    
end


% EoF -------------------------------------------------------------------------------------------- %




















