function [trFeat,teFeat,trFileId,teFileId] = selectFeatureSets(feat, learningParam)

    %%% Select file indices to build training and testing data sets
    if learningParam(1) == 0, % If we are in mode "one left and do all crossvalidation"
        [trFile,teFile] = generateFileList0(db, false);
	
    elseif learningParam(1) == 1, % If we are in mode "one left"
        [trFile,teFile] = generateFileList0(db, learningParam(2));
        
    elseif learningParam(1) > 0 && learningParam(1) < 1, % If we are in mode "normal"
        [trFile,teFile] = generateFileList(db, learningParam(1), learningParam(2));
    end
    
    % Extract training and testing features linked to selected training and testing files
    [trFeat,teFeat] = featSelection(db, trFile, teFile);
    
    % Normalize features (mean = 0; std = 1)
    [trFeat,teFeat] = featNormalization(trFeat, teFeat, plotFlag);
    
    % Map features in a better space representation and reduce feature dimension
    [trFeat,teFeat] = featReduction(trFeat, teFeat, reductionParam);

end
