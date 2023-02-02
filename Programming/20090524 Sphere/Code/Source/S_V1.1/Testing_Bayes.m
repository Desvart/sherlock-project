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
                                             PCABasis, LDABasis, meanMatrix, bigCovMatrix)

    
    % ------------------------------------------------------------------------------------
    % Function initialization
    % ------------------------------------------------------------------------------------
    
    % First line of 'testingFile' contains the number of file per class used for training
    nbTestingFile   = testingFile{1};
    nbClass         = length(nbTestingFile);
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
    % Reduction of features dimension (PCA + LDA)
    % ------------------------------------------------------------------------------------
    
    [feature, featureDim] = featureReduction(feature, PCABasis, LDABasis);
    
    
    % ------------------------------------------------------------------------------------
    % Bayes Classification
    % ------------------------------------------------------------------------------------

    %%% Compute Bayes distance
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
    % Determine Class Membership for each sound
    % ------------------------------------------------------------------------------------

    membership  = zeros(1, nbTestingFile);       % Preallocation
    certainties = zeros(nbClass, nbTestingFile); % Preallocation
    
    % Loop for each sound
    for i = 1 : nbTestingFile, 

        start = sum(nbFrameByFile(1:i-1))+1; % Index of first frame of current sound
        stop  = sum(nbFrameByFile(1:i));     % Index of last frame of current sound

        % Determine number of frames belonging to each class
        bilan = zeros(1, nbClass); % Preallocation
        for j = 1 : nbClass,
            bilan(j) = sum(frame_membership(start:stop)==j);
        end

        % See which class is the winner
        membership(i) = find(bilan == max(bilan));

        % Calculate certainties
        certainties(:, i) = bilan / sum(bilan);
    end
               
end %function


% --------------------------------- End of file -----------------------------------------
