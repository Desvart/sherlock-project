%% Compute and display accuracy estimation 

confusionMatrixNorm = confusionMatrix1 ./ nFiles;

% Preallocation
overallVector   = nan(1, nClasses + 1); 
kappaVector     = nan(1, nClasses + 1);
shortVector     = nan(1, nClasses + 1);
helldenVector   = nan(1, nClasses + 1);

for iClass = 1 : nClasses,
    
    pkk = confusionMatrixNorm(iClass, iClass);
    rk = sum(confusionMatrixNorm(iClass, 1:nClasses));
    ck = sum(confusionMatrixNorm(1:nClasses, iClass));

    
    %%% Overall method
    % 
    
    overallVector(iClass) = pkk / rk;
    
    
    %%% Cohen method (Kappa value)
    % the proportion of agreement after chance agreement is removed from consideration
    % K = 0 when obtained agreement equals chance agreement. 
    % K = 1 for perfect agreement. 
    % K < 0 if obtained agreement is less than chance agreement.
    
    kappaVector(iClass) =  (pkk - rk*ck) / (ck -rk*ck);
    
    
    %%% Short method
    % Not affected by sample size
    % S = 0 for no positive matches; 
    % S = 1 for perfect agreement. 
    
    shortVector(iClass) =  pkk / (rk + ck - pkk);
    
    
    %%% Hellden method
    % Estimate of the "mean accuracy" -- the probability that a randomly chosen pixel of a 
    % specific class (k) will be properly classified    
    
    helldenVector(iClass) = 2*pkk / (rk + ck);
    
end


p0 = sum(diag(confusionMatrixNorm(1:end-1, 1:end-1)));
c0 = sum(confusionMatrixNorm(1:end-1, 1:end-1), 1);
r0 = sum(confusionMatrixNorm(1:end-1, 1:end-1), 2);
pc = c0 * r0; 

overallVector(end) = p0;
shortVector(end)   = p0 / (2 - p0);
helldenVector(end) = p0;
kappaVector(end)   = (p0 - pc) / (1 - pc);


%%% Display accuracy critera

accuracyCriteriaNameVector          = {''; 'Overall'; 'Hellden'; 'Short'; 'Kappa'};
accuracyTableHeader                 = {'', 'Without default', 'With default', 'Overall'};
nAccuracyCriterias                  = length(accuracyCriteriaNameVector);
accuracyCellMatrix                  = cell(nAccuracyCriterias, nClasses+2);

accuracyMatrix = nan(nAccuracyCriterias, nClasses + 1); % Prealloc.
for iAccuracyCriteria = 2 : nAccuracyCriterias,
    accuracyVarString                    = lower(accuracyCriteriaNameVector{iAccuracyCriteria});
    accuracyVarName                      = [accuracyVarString, 'Vector'];
    accuracyMatrix(iAccuracyCriteria, :) = eval(accuracyVarName);
end

accuracyCellMatrix(1, :)            = accuracyTableHeader;
accuracyCellMatrix(:, 1)            = accuracyCriteriaNameVector;
accuracyCellMatrix(2:end, 2:end)    = num2cell(accuracyMatrix(2:end, :));

disp(accuracyCellMatrix);
