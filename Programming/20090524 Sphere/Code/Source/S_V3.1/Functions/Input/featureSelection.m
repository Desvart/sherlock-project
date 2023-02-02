function [trainingFile, testingFile] = featureSelection(reco, database)

    strategy = reco.strategy;

	% If we are in mode "one left and do all crossvalidation"
    if strategy == 0,
        [trainingFile, testingFile] = generateOneLeftFileList(database, 0);

	% If we are in mode "one left"
    elseif strategy == 1,
        [trainingFile, testingFile] = generateOneLeftFileList(database, reco.randomFlag);
        
	% If we are in mode "normal"
    elseif strategy > 0 && strategy < 1,
        [trainingFile, testingFile] = generateNormalFileList(reco, database);
                                       
    end

end


function [trainingFile, testingFile] = generateNormalFileList(reco, database)
% TODO : change preallocation to have a good one and not an increasing signal in the loop
    
    %%% Extract data from structures
    data                = database.data;
    nbClass             = database.nbClass;
    nbFilePerClass      = database.nbFilePerClass;
    nbFeaturePerClass   = database.nbFeaturePerClass;
    nbFeaturePerFile    = database.nbFeaturePerFile;
    
    %%% Compute the number of file needed for training and testing
    nbTrainingFilePerClass  = ceil(nbFilePerClass*reco.strategy);
    nbTestingFilePerClass   = nbFilePerClass - nbTrainingFilePerClass;
    
    trainingFeature = []; % Preallocation
    trainingTarget  = []; % Preallocation
    testingFeature  = []; % Preallocation
    testingTarget   = []; % Preallocation
    for i = 1 : nbClass,
        
        %%% Generate an index list of all files
        if reco.randomFlag,
            fileIndex = randperm(nbFilePerClass(i));
        else
            fileIndex = 1:nbFilePerClass(i);
        end

        %%% Select index list for training and testing file
        trainingFileIndex = fileIndex(1:nbTrainingFilePerClass(i));
        testingFileIndex  = fileIndex(nbTrainingFilePerClass(i)+1:end);

        %%% Training feature extraction
        first = (i-1)*nbFeaturePerClass(i) + (trainingFileIndex-1)*nbFeaturePerFile(1) + 1 ; 
        last  = first + nbFeaturePerFile(1) - 1;
        for j = 1 : nbTrainingFilePerClass(i),
            trainingFeature = [trainingFeature data(:,first(j):last(j))];
        end
        
        %%% Training target
        trainingTarget = [trainingTarget, i*ones(1, nbTrainingFilePerClass(i)*nbFeaturePerFile(1))];

        %%% Testing feature extraction
        first = (i-1)*nbFeaturePerClass(i) + (testingFileIndex-1)*nbFeaturePerFile(1) + 1 ; 
        last  = first + nbFeaturePerFile(1) - 1;
        for j = 1 : nbTestingFilePerClass(i),
            testingFeature = [testingFeature data(:,first(j):last(j))];
        end
        
        %%% Testing target
        testingTarget = [testingTarget, i*ones(1, nbTestingFilePerClass(i)*nbFeaturePerFile(1))];
        
    end
    
    %%% Build output structure for training feature
    trainingFile.data               = trainingFeature;
    trainingFile.target             = trainingTarget;
     
    trainingFile.nbClass            = nbClass;
    trainingFile.nbFile             = sum(nbTrainingFilePerClass);
    trainingFile.nbFeature          = trainingFile.nbFile * nbFeaturePerFile(1);
    trainingFile.nbDim              = database.nbDim;
    
    trainingFile.nbFilePerClass     = nbTrainingFilePerClass;
    trainingFile.nbFeaturePerFile   = nbFeaturePerFile(1)*ones(1, trainingFile.nbFile);
    trainingFile.nbFeaturePerClass  = trainingFile.nbFeaturePerFile * nbTrainingFilePerClass(1);
    
    
    
    %%% Build output structure for testing feature
    testingFile.data                = testingFeature;
    testingFile.target              = testingTarget;
    
    testingFile.nbClass             = nbClass;
    testingFile.nbFile              = sum(nbTestingFilePerClass);
    testingFile.nbFeature           = testingFile.nbFile * nbFeaturePerFile(1);
    testingFile.nbDim               = database.nbDim;

    testingFile.nbFilePerClass      = nbTestingFilePerClass;
    testingFile.nbFeaturePerFile    = nbFeaturePerFile(1)*ones(1, testingFile.nbFile);
    testingFile.nbFeaturePerClass   = testingFile.nbFeaturePerFile * nbTestingFilePerClass(1);
    
end


function [trainingFile, testingFile] = generateOneLeftFileList(database, randomFlag)

    %%% Extract data from structures
    data                = database.data;
    target              = database.target;
    nbClass             = database.nbClass;
    nbFilePerClass      = database.nbFilePerClass;
    nbFeaturePerClass   = database.nbFeaturePerClass;
    nbFeaturePerFile    = database.nbFeaturePerFile;
    
    %%% Compute the number of file needed for training and testing
    persistent c f c_hist f_hist;
    if isempty(c),
        c = 1;
        f = 0;
    end
    
    if randomFlag,
        
        c = randi(nbClass);
        f = randi(nbFilePerClass(c));
        while any(f_hist(c_hist == c) == f),
            c = randi(nbClass);
            f = randi(nbFilePerClass(c));
        end
        c_hist = [c_hist c];
        f_hist = [f_hist f];
        
    else
        
        f_old = f;
        f = mod(f, nbFilePerClass(c)) + 1;
        c = c + floor((f_old)/nbFilePerClass(c));
        
    end
    
    nbTrainingFilePerClass      = nbFilePerClass;
    nbTrainingFilePerClass(c)   = nbTrainingFilePerClass(c) - 1;
    nbTestingFilePerClass       = zeros(1, nbClass);
    nbTestingFilePerClass(c)    = nbTestingFilePerClass(c) + 1;
    
    first = sum(nbFeaturePerClass(1:c-1)) + (f-1)*nbFeaturePerFile(1) + 1;
    last  = first + nbFeaturePerFile(1) - 1;
    
    trainingFeature = data(:,[1:first last:end]);
    trainingTarget  = target([1:first last:end]);
    testingFeature  = data(:, first:last);
    testingTarget   = target(first:last);
    
    
    
    
    %%% Build output structure for training feature
    trainingFile.data               = trainingFeature;
    trainingFile.target             = trainingTarget;
     
    trainingFile.nbClass            = nbClass;
    trainingFile.nbFile             = sum(nbTrainingFilePerClass);
    trainingFile.nbFeature          = trainingFile.nbFile * nbFeaturePerFile(1);
    trainingFile.nbDim              = database.nbDim;
    
    trainingFile.nbFilePerClass     = nbTrainingFilePerClass;
    trainingFile.nbFeaturePerFile   = nbFeaturePerFile(1)*ones(1, trainingFile.nbFile);
    trainingFile.nbFeaturePerClass  = trainingFile.nbFeaturePerFile * nbTrainingFilePerClass(1);
    
    
    
    %%% Build output structure for testing feature
    testingFile.data                = testingFeature;
    testingFile.target              = testingTarget;
    
    testingFile.nbClass             = nbClass;
    testingFile.nbFile              = sum(nbTestingFilePerClass);
    testingFile.nbFeature           = testingFile.nbFile * nbFeaturePerFile(1);
    testingFile.nbDim               = database.nbDim;

    testingFile.nbFilePerClass      = nbTestingFilePerClass;
    testingFile.nbFeaturePerFile    = nbFeaturePerFile(1)*ones(1, testingFile.nbFile);
    testingFile.nbFeaturePerClass   = testingFile.nbFeaturePerFile * nbTestingFilePerClass(1);



end
