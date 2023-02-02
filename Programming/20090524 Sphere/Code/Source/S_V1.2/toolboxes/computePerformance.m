function [newConfusionMatrix, globalPerformance, stepPerformance] = ...
                                     computePerformance(nbTestingFilePerClass, membership)
    
    % Extract usefull values
	nbClass       = length(nbTestingFilePerClass);
    nbTestingFile = sum(nbTestingFilePerClass);
                
    %%% Determine Target Classification (a priori known classification)
    target = zeros(1, nbTestingFile); % Preallocation
    lastIndex = nbTestingFilePerClass(1);
    target(1:lastIndex) = ones(1, nbTestingFilePerClass(1)); % First class
    for j = 2:nbClass,
        
        %%% PROBLEM D?INDEX!!!!
        firstIndex = lastIndex + 1;
        lastIndex  = firstIndex + nbTestingFilePerClass(j) - 1;
        target(firstIndex:lastIndex) = j*ones(1, nbTestingFilePerClass(j));
    end

    %%% Calculate Confusion Matrix
    persistent confusionMatrix;
    if isempty(confusionMatrix), % Persistent initialization
        confusionMatrix = zeros(nbClass, nbClass); 
    end
    
    stepConfusionMatrix = zeros(nbClass, nbClass); % Preallocation
    
    for i = 1:nbClass,
        for j = 1:nbClass,
            stepConfusionMatrix(i,j) = sum(membership==i & target==j);
        end
    end
    
    % Update confusion matrix through crossvalidation
    confusionMatrix = stepConfusionMatrix + confusionMatrix;
    newConfusionMatrix = confusionMatrix;
    
    % Compute the recognition performance
    stepPerformance   = sum(diag(stepConfusionMatrix))/sum(sum(stepConfusionMatrix));
    globalPerformance = sum(diag(confusionMatrix))/sum(sum(confusionMatrix));
                
end
