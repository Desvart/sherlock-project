
confMatEstimatorVec = nan(1, 2^19);
for i = 1 : 2^19,
    
    % Virtualy equilibrate confusion matrix
%     confusionMatEquilArr = bsxfun(@times, confusionMatrixArr(:,:,i),  nObsPerClassArr(end:-1:1)');
    confusionMatEquilArr = bsxfun(@times, confusionMatrixArr(:,:,i),  [1,1]);
        
    % Normalize confusion matrix
%     confusionMatEquilNormArr = confusionMatEquilArr / ( 2*prod(nObsPerClassArr) );
    confusionMatEquilNormArr = confusionMatEquilArr / ( sum(nObsPerClassArr) );

    % Compute positive and negative predictive values
%     positivePredictVal = (confusionMatEquilNormArr(1, 1) / sum(confusionMatEquilNormArr(:, 1)) - 1)^2;
%     negativePredictVal = (confusionMatEquilNormArr(2, 2) / sum(confusionMatEquilNormArr(:, 2)) - 1)^2;
    
    sensitivityVal = (confusionMatEquilNormArr(1, 1) / sum(confusionMatEquilNormArr(1, :)) - 1)^2;
    specificityVal = (confusionMatEquilNormArr(2, 2) / sum(confusionMatEquilNormArr(2, :)) - 1)^2;

    % Weighted positive and negative predictive values by probability that those value could be
    % random
%     positivePredictValWeighted = positivePredictVal + 0.5^2*(garbageProba(1));
%     negativePredictValWeighted = negativePredictVal + 0.5^2*(garbageProba(2));
    
    % Evaluate the confusion matrix estimator
%     confMatEstimator(i)    = positivePredictValWeighted + negativePredictValWeighted;
    confMatEstimatorVec(i)    = sensitivityVal + specificityVal;
    
    
end


plot(confMatEstimatorVec);

[confMatEstimatorSortedVec, idxSortedVec]   = sort(confMatEstimatorVec);
confMatEstimatorMinVec                      = confMatEstimatorSortedVec(1:34)
minIdxVec                                   = idxSortedVec(1:34)
