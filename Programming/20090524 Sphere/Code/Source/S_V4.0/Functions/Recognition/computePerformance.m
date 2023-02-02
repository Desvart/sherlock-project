% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function performance = computePerformance(testingFile, membership)
    
    % Extract usefull values
    nbTestingFilePerClass = testingFile.nbFilePerClass;
	nbClass       = testingFile.nbClass;
    nbTestingFile = testingFile.nbFile;

    
    % -------------------------------------------------------------------------------------------- %
    % Determine Target Classification (a priori known classification)
    % -------------------------------------------------------------------------------------------- %
    
    target    = zeros(1, nbTestingFile); % Preallocation
    lastIndex = 0;
    
    for j = 1 : nbClass,
        
        firstIndex = lastIndex + 1;
        lastIndex  = firstIndex + nbTestingFilePerClass(j) - 1;
        target(firstIndex:lastIndex) = j*ones(1, nbTestingFilePerClass(j));
        
    end
    
    
    % -------------------------------------------------------------------------------------------- %
    % Calculate Confusion Matrix
    % -------------------------------------------------------------------------------------------- %
    
    persistent confusionMatrix;
    if isempty(confusionMatrix), % Persistent initialization
        confusionMatrix = zeros(nbClass, nbClass); 
    end
    
    stepConfusionMatrix = zeros(nbClass, nbClass); % Preallocation
    
    for i = 1:nbClass,
        for j = 1:nbClass,
            stepConfusionMatrix(j,i) = sum(membership==i & target==j);
        end
    end
    
    % Update confusion matrix through crossvalidation
    confusionMatrix    = stepConfusionMatrix + confusionMatrix;
%     performance.newConfusionMatrix = confusionMatrix;
    performance.confusionMatrix = confusionMatrix;
    
    
    % -------------------------------------------------------------------------------------------- %
    % Compute the recognition performance
    % -------------------------------------------------------------------------------------------- %
    
    performance.stepPerformance   = sum(diag(stepConfusionMatrix))/sum(sum(stepConfusionMatrix));
    performance.globalPerformance = sum(diag(confusionMatrix))/sum(sum(confusionMatrix));
                
end
