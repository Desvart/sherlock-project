function confusionMatArr = cross_validation_loop(allObsArr, fileLabelVector, nFeats)

    %%% nFiles
    % tFileId
    % lFileId
    % nObsPerFile
    % fileLabelVector
    % obsLabelVector
    % allObsArr
    % nTFiles
    %%% nObsPerFile
    % nCarKept
    % nFeats

    %% Init loop
    
    [nFiles, nObsPerFile, nCars] = size(allObsArr);
    nClasses = max(fileLabelVector);
    
    
    
    
    %%% Init loop

    nXValLoops = nFiles;


    obsLabelArray               = repmat(fileLabelVector, 1, nObsPerFile)';
    obsLabelVector              = obsLabelArray(:);

    nFilesPerClassArr = nan(1, nClasses); % Prealloc.
    for iClass = 1 : nClasses,
        nFilesPerClassArr(iClass) = length(find(fileLabelVector == iClass));
    end

    priorProbaArray = nFilesPerClassArr / nFiles;

    nTFiles = 1;
    nLFiles = nFiles - nTFiles;

    nTObs   = nTFiles * nObsPerFile;
    nLObs   = nLFiles * nObsPerFile;
    

    fileELabelVec = nan(nXValLoops, 1);
    
%     fprintf('Start cross-validation loop (#%d) :\n', nXValLoops);
    
    
    
    %% Start cross-validation loop
    
    for iXValLoop = 1 : nXValLoops,

        
        
        %% Display index of loop bewing processed
        
%         if iXValLoop ~= nXValLoops,
%             fprintf('%2.0d - ', iXValLoop);
%             if ~mod(iXValLoop , 10),
%                 fprintf('\n');
%             end
%         else
%             fprintf('%2.0d\n ', iXValLoop);
%         end



        %% Create the learning and testing sets and their corresponding labels
        % Select one file to be used as the testing file for this cross-validation loop. Then all the
        % other files are used for the learning process.


        %%% Determine training and learning file and observation indexes

        tFileId         = iXValLoop;
        lFileId         = [1 : (iXValLoop-1), (iXValLoop+1) : nFiles]';

        repmatTFileId   = ((tFileId-1)*nObsPerFile) * ones(1, nObsPerFile);
        repmatLFileId   = ((lFileId-1)*nObsPerFile) * ones(1, nObsPerFile);
        tObsId          = bsxfun(@plus, repmatTFileId, 1:nObsPerFile);
        lObsId          = bsxfun(@plus, repmatLFileId, 1:nObsPerFile);


        %%% Build training and learning file and observation label vectors

        tFileLabel      = fileLabelVector(tFileId);
        lFileLabel      = fileLabelVector(lFileId);

        tObsLabelVector = obsLabelVector(tObsId, :);
        lObsLabelVector = obsLabelVector(lObsId, :); 


        %%% Create training and testing observation array

        tObsArray       = reshape(allObsArr(tFileId, :, :), nTFiles*nObsPerFile, nCars);
        lObsArray       = reshape(allObsArr(lFileId, :, :), nLFiles*nObsPerFile, nCars);



        %% Put learning and testing sets (and toc labels) in vector format and normalize them.
        % Normalization is done to avoid numerical anomalies when computing covariance matrix and its
        % inverse.

        %%% Normalize learning features cloud

        lFeatMeanVector         = nanmean(lObsArray, 1);
        lFeatCovMatrix          = nancov( lObsArray);
        lFeatStdVector          = sqrt(diag(lFeatCovMatrix))';

        lObsMeanNormArray       = bsxfun(@minus,   lObsArray,         lFeatMeanVector);
        lObsNormArray           = bsxfun(@rdivide, lObsMeanNormArray, lFeatStdVector);



        %% Apply some space transformation and space reduction on feature vectors
        % In this case a simple PCA is applied and only 2 or 3 most important dimensions are kept.


        %%% Proceed to learning mapping

        covMat = nancov(lObsNormArray);
        [eigenVec, eigenVal] = eig(covMat);  % Eigen analysis of feature covariance matrix
        eigenVal = diag(eigenVal);
        norm = diag(1./sqrt(eigenVal(end : -1 : end-nFeats+1))); % Normalize basis matrix
        pcaMappingMat = norm*eigenVec(:, end : -1 : end-nFeats+1)'; % Compute basis matrix

        lObsNormMapRedArray = lObsNormArray * pcaMappingMat'; % Feature projection on new basis



    %     lObsNormMapRedArray             = lObsNormMapArray(:, 1:nFeats);


        %%% Regroup observations of same class

        lObsRedMapNormCellArray         = cell(1, nClasses); % Prealloc

        for iClass = 1 : nClasses,
            lObsRedMapNormCellArray{iClass} = lObsNormMapRedArray(lObsLabelVector == iClass, :);
        end



        %% Proceed to learning process (Bayes model)
        % For all learning files of the without default class, compute the means for each dimensions.
        % Then compute the covariance matrix. Do the same things to the learning files of the with
        % defautl class. meansClass1Vector, covClass1Array, meansClass2Vector and covClass2Array are the
        % Bayesian model.

        preallocMuVect      = nan(nFeats, 1);
        preallocSigmaArray  = nan(nFeats, nFeats);
        model               = struct('muVector',      {preallocMuVect,     preallocMuVect}, ...
                                     'sigmaArray',    {preallocSigmaArray, preallocSigmaArray});

        for iClass = 1 : nClasses,
            model(iClass).muVector      = nanmean(lObsRedMapNormCellArray{iClass});
            model(iClass).sigmaArray    = nancov( lObsRedMapNormCellArray{iClass}); 
        end



        %% Proceed to testing process
        % For each toc of the testing file, compute the discriminant function (Mahalanobis distance). 
        % Then the decision rule is to attribute the toc to the class in which it has the maximum 
        % discriminant value.
        % Do that for all toc of the testing file and then, choose to attribute the file to the class
        % where most of the tocs belong. If there is as many tocs in one class and the other, then
        % choose with the cumulative belonging probability of each toc.


        %%% Normalize and apply maping on testing observations

        tObsMeanNormArray       = bsxfun(@minus,   tObsArray,         lFeatMeanVector);
        tObsNormArray           = bsxfun(@rdivide, tObsMeanNormArray, lFeatStdVector);

        tObsNormMapArray        = tObsNormArray * pcaMappingMat';
        tObsNormMapRedArray     = tObsNormMapArray(:, 1:nFeats);



        %% Determine the discriminant value for each toc of the testing file

        mahalanobisDistArray    = nan(nObsPerFile, nClasses); % Preallocation
        discriminantValueArray  = nan(nObsPerFile, nClasses); % Preallocation

        for iClass = 1 : nClasses,

            muVector     = model(iClass).muVector;
            sigmaArray   = model(iClass).sigmaArray;

            discriminantValueClassTerm = -1/2 * log(det(sigmaArray)) + log(priorProbaArray(iClass));

            tObsMinusMeanArray = bsxfun(@minus, tObsNormMapRedArray, muVector);
            for iObs = 1 : nObsPerFile,
    %             tObsMinusMeanArray                  = tObsArray(iObs, :)' - muVector;
                tObsMinusMean = tObsMinusMeanArray(iObs, :);
                mahalanobisDistArray(iObs, iClass)  = tObsMinusMean * (sigmaArray \ tObsMinusMean');
            end

            discriminantValueClassTermVector = repmat(discriminantValueClassTerm, nObsPerFile, 1);
            discriminantValueArray(:, iClass) = -1/2 * mahalanobisDistArray(:, iClass) + discriminantValueClassTermVector;

        end


        %%% Deduce toc estimate belonging

        [tocBelongingProbaVector, tocEstimateBelongingVector] = max(discriminantValueArray, [], 2);


        %%% Deduce belonging probability for the testing file

        nTocsBelongingToClassX = nan(1, nClasses); % Preallocation

        for iClass = 1 : nClasses,
            nTocsBelongingToClassX(iClass) = sum(tocEstimateBelongingVector == iClass);
        end

        [nTocsMaxBelongingToOneClass, fileEstimateBelonging] = max(nTocsBelongingToClassX);
        
        if sum(nTocsBelongingToClassX == nTocsMaxBelongingToOneClass) == 1,
            % If there is no ambiguity about file class belonging
            
            fileELabelVec(iXValLoop) = fileEstimateBelonging;
            
        else
            % If there is an ambiguity about file class belonging, i.e. there is as many tocs belonging to
            % a class than another. In this case, it's the cumulative probability of all tocs belonging to
            % each that is used to determine the file class belonging.
            
            classBelongingCumProba = nan(1, nClasses); % Preallocation
            
            for iClass = 1 : nClasses,
                belongingProbaForThisClassVector    = ...
                                          tocBelongingProbaVector(tocEstimateBelongingVector == iClass);
                classBelongingCumProba(iClass)      = sum(belongingProbaForThisClassVector);
                [~, fileEstimateBelonging]          = max(classBelongingCumProba);
                fileELabelVec(iXValLoop)  = fileEstimateBelonging;
            end
            
        end


    end % iLoop = 1 : nLoops,


    
    %% Compute confusion matrix
    % Lines     = true class belonging
    % Columns   = estimate class belonging 

    confusionMatArr = zeros(nClasses, nClasses); % Preallocation
    
    for iFile = 1 : nFiles,
        newValue = confusionMatArr(fileLabelVector(iFile), fileELabelVec(iFile)) + 1;
        confusionMatArr(fileLabelVector(iFile), fileELabelVec(iFile)) = newValue;
    end
    
 

end


% eof
