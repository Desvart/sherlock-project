% ----------------------------------------------------------------------------------------
% Function : Testing_Bayes.m
% 
% Purpose  : This function does the testing part of a sound recognition process. The
%            probability density functions (PDF) of the features inputed are modelized 
%            by single gaussians (Bayes modelization).
%
%
% Inputs :  
%       signal
%       
%
% Outputs : 
%       
%
%
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [membership, certainties] = ...
            Testing_Bayes(testingFile, testingSNR, featureType, ...
                               PCAEigenVectors, LDAEigenVectors, meanMatrix, bigCovMatrix)

    
    % ------------------------------------------------------------------------------------
    % Function initialization
    % ------------------------------------------------------------------------------------
    
    % First line of 'testingFile' contains the number of file per class used for training
    nbTestingFilePerClass   = testingFile{1};
    nbClass         = length(nbTestingFilePerClass);
    nbTestingFile   = sum(nbTestingFilePerClass);
    nbFrameByClass  = zeros(1, nbClass); % Preallocation
    
    
    % ------------------------------------------------------------------------------------
    % Features extraction
    % ------------------------------------------------------------------------------------
    
    [feature, nbFrameByFile] = featureExtraction(testingFile, testingSNR, featureType);
    totNbFrame = size(feature, 2);
    
    
    % ------------------------------------------------------------------------------------
    % Features normalization (mean = 0; std = 1)
    % ------------------------------------------------------------------------------------
    
    feature = featureNormalization(feature);
   
    
    % ------------------------------------------------------------------------------------
    % Features dimension reduction
    % ------------------------------------------------------------------------------------
    
    %%% Principal Component Analysis (PCA)
    if PCAEigenVectors ~= 0,
        [feature, featureDim] = reduceDimension(feature, PCAEigenVectors);
    end
    
    %%% Linear Discriminant Analysis (LDA)
    if LDAEigenVectors ~= 0,
        [feature, featureDim] = reduceDimension(feature, LDAEigenVectors);
    end
    
    % ------------------------------------------------------------------------------------
    % Bayes Classification
    % ------------------------------------------------------------------------------------

    %%% Compute Bayes distance 
    %   [AD Thesis pp. 67-69]
    pseudoBayesDist = zeros(nbClass, size(feature, 2)); % Preallocation
    for i = 1 : nbClass,
        
        % Extract PDF parameters (mean and cov) for actual class
        meanVector = meanMatrix(i,:)';
        covMatrix  = reshape(bigCovMatrix(i,:), featureDim, featureDim);
        
        centeredFeature = feature - meanVector*ones(1, totNbFrame);
        
        pseudoBayesDist(i, :) = log(det(covMatrix)) + ...
                                    (diag(centeredFeature'*(covMatrix\centeredFeature)))';
    end
    
    [dummy, frame_membership] = min([pseudoBayesDist; Inf*ones(1, totNbFrame)]);


    % ------------------------------------------------------------------------------------
    % Determine class membership for each sound
    % ------------------------------------------------------------------------------------

    membership  = zeros(1, nbTestingFile);       % Preallocation
    certainties = zeros(nbClass, nbTestingFile); % Preallocation
    
    % Loop for each sound
    for i = 1 : nbTestingFile, 

        start = sum(nbFrameByFile(1:i-1))+1; % Index of first frame of current sound
        stop  = sum(nbFrameByFile(1:i));     % Index of last frame of current sound

        % Determine number of frames belonging to each class
        nbFrameBelongingToEachClass = zeros(1, nbClass); % Preallocation
        for j = 1 : nbClass,
            nbFrameBelongingToEachClass(j) = sum(frame_membership(start:stop)==j);
        end

        % See which class is the winner
        [dummy, membership(i)] = max(nbFrameBelongingToEachClass);

        % Calculate certainties
        certainties(:, i) = nbFrameBelongingToEachClass / sum(nbFrameBelongingToEachClass);
    end
               
end %function


% --------------------------------- End of file -----------------------------------------
