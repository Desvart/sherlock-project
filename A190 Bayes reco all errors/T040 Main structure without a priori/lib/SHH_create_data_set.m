function [learningSetFileId, learningSetFileTarget, testingSetFileId , testingSetFileTarget, ...
          learningSetTocId, learningSetTocTarget, testingSetTocId , testingSetTocTarget] = ...
                                          SHH_create_data_set(nFiles, iLoop, classE00, nTocsPerFile)

                                         
    allFileTarget = ones(1, nFiles);
    allFileTarget(classE00) = 0;
    allTocTarget = repmat(allFileTarget, nTocsPerFile, 1);
                                         
                                         
    learningSetFileId = [1:iLoop-1, iLoop+1:nFiles];
    testingSetFileId  = iLoop;
    
    learningSetFileTarget = allFileTarget(learningSetFileId);
    testingSetFileTarget = allFileTarget(testingSetFileId);
    
    
    learningSetTocId = bsxfun(@plus, ((learningSetFileId-1)*nTocsPerFile)'*ones(1, nTocsPerFile), 1:nTocsPerFile)';
    testingSetTocId  = bsxfun(@plus, ((testingSetFileId-1)*nTocsPerFile)'*ones(1, nTocsPerFile), 1:nTocsPerFile)';
    
    
    learningSetTocTarget = allTocTarget(:, learningSetFileId);
    testingSetTocTarget  = allTocTarget(:, testingSetFileId);
    
end