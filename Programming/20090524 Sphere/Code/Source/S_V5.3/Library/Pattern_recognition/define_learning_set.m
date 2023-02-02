function chrono = define_learning_set()
% DEFINE_LEARNING_SET   
%
% Synopsis:     define_learning_set();

% Notes: 

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.01  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    % --- Launch function chronometer and display process status
    chrono = tic;
    process_status();
    
%     dbstop in define_learning_set0 at 18
    % --- Define the number of files used for training and testing sets
    learningStrategy = config_('learningStrategy');
    nFile            = database_('nFile');
    nFilePerClass    = database_('nFilePerClass');
    nClass           = database_('nClass');
%     dbstop in define_learning_set at 34

    if learningStrategy == 1,
        nTrainingFile = min(ceil(learningStrategy * nFile), nFile-1); % min = 1; max = nFile-1
        nTestingFile  = nFile - nTrainingFile;
        
    end
    
    if learningStrategy > 0 && learningStrategy < 1,
        nTrainingFilePerClass = min(ceil(learningStrategy * nFilePerClass), nFilePerClass - 1); % min = 1; max = nFile-1
        nTestingFilePerClass  = nFilePerClass - nTrainingFilePerClass;
        nTrainingFile = sum(nTrainingFilePerClass);
        nTestingFile  = sum(nTestingFilePerClass);
    end
    
    nTraining = config_('nTraining');
    
    if learningStrategy == 0,
        nTrainingFile = nFile - 1;
        nTestingFile  = 1;
        nTraining     = nFile;
        
    end

%     dbstop in define_learning_set at 48
    % --- Select file indices to build training and testing data sets
    if nTestingFile == 1, 
        [trainingFileId, testingFileId] = generate_training_set_id0(nTraining, nFile);
        [trainingFileIdPerClass, trainingFileLabel] = convert_absolute_ID_set_to_relative(trainingFileId, nTraining, nClass, nTrainingFile, nFilePerClass);
        [testingFileIdPerClass, testingFileLabel]  = convert_absolute_ID_set_to_relative(testingFileId, nTraining, nClass, nTestingFile, nFilePerClass);
        
    else
        [trainingFileIdPerClass, testingFileIdPerClass] = generate_training_set_id1(nFilePerClass, nTestingFilePerClass, nTraining, nClass);
        [trainingFileId, trainingFileLabel] = convert_relative_ID_set_to_absolute(trainingFileIdPerClass, nTraining, nClass, nTrainingFile, nFilePerClass);
        [testingFileId, testingFileLabel] = convert_relative_ID_set_to_absolute(testingFileIdPerClass, nTraining, nClass, nTestingFile, nFilePerClass);
        
    end
    
%     dbstop in define_learning_set0 at 62
    % --- Save learningFileId in feature structure
    database_('trainingFileId',         trainingFileId);
    database_('trainingFileLabel',      trainingFileLabel);
    database_('testingFileId',          testingFileId);
    database_('testingFileLabel',       testingFileLabel);
    database_('trainingFileIdPerClass', trainingFileIdPerClass);
    database_('testingFileIdPerClass',  testingFileIdPerClass);

    
    % --- Display process status
    process_status(toc(chrono));
    
end


function [trainingSetId, testingSetId] = generate_training_set_id0(nTraining, nFile)
% GENERATE_TRAINING_SET_ID0
%
% Synopsis:     generate_training_set_id0(nTrainingFile, nTestingFile, nTraining);
%
% Inputs  :
% Outputs : trainingFileId  [int txf] Training file indentificator for each training loop. Each line
%                           corresponds to a training.
%           testingFileId   [int tx1] Testing file indentificator for each training loop. Each line
%                           corresponds to a training.

% Notes: 

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.01  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    if config_('isRandom'),
        fileId = randperm(nFile);
        testingSetId = sort(fileId(1:min(nTraining, nFile)))';
        
    else
        testingSetId = (1:min(nTraining, nFile))';
        
    end
    
    trainingSetId = zeros(nTraining, nFile-1); % Preallocation
    for iTraining = 1 : nTraining,
        trainingFileId = 1:nFile;
        trainingFileId(trainingFileId == testingSetId(iTraining)) = [];
        trainingSetId(iTraining, :) = trainingFileId;
    end
            
end   


function [fileSetIdPerClass, fileSetLabel] = convert_absolute_ID_set_to_relative(fileSetId, nTraining, nClass, nSetFile, nFilePerClass)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.01  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    fileSetIdPerClass = cell(nTraining, nClass);
    fileSetLabel = zeros(nTraining, nSetFile);
    for iTraining = 1 : nTraining,
        inc = zeros(1, nClass);
        for iSetFile = 1 : nSetFile,
            [classId, fileIdClassRef] = fileAbsId2RelId(fileSetId(iTraining, iSetFile), nFilePerClass);
            inc(classId) = inc(classId) + 1;
            fileSetIdPerClass{iTraining, classId}(inc(classId)) = fileIdClassRef;
            fileSetLabel(iTraining, iSetFile) = classId;
        end
    end
    
end   



function [trainingSetIdPerClass, testingSetIdPerClass] = generate_training_set_id1(nFilePerClass, nTestingFilePerClass, nTraining, nClass)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.08.23  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    trainingSetIdPerClass = cell(nTraining, nClass);
    testingSetIdPerClass = cell(nTraining, nClass);
    for iClass = 1 : nClass,
        perm = generate_permutation_without_order(nFilePerClass(iClass), nTestingFilePerClass(iClass), nTraining);
        for iTraining = 1 : nTraining,
            testingSetIdPerClass{iTraining, iClass}  = perm(iTraining, :);
            trainingSetIdPerClass{iTraining, iClass} = search_in_matrix(1:nFilePerClass(iClass), testingSetIdPerClass{iTraining, iClass}, 'diff');
            
        end
    end

end





function [fileSetId, fileSetLabel] = convert_relative_ID_set_to_absolute(fileSetIdPerClass, nTraining, nClass, nSetFile, nFilePerClass)
    
% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.01  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    startId = cumsum([0, nFilePerClass]);
    fileSetId    = zeros(nTraining, nSetFile);
    fileSetLabel = zeros(nTraining, nSetFile);
    for iTraining = 1 : nTraining,
        stop = 0;
        for iClass = 1 : nClass,
            start = stop + 1;
            stop  = start + length(fileSetIdPerClass{iTraining, iClass}) - 1;
            fileSetId(iTraining, start:stop) = startId(iClass) + fileSetIdPerClass{iTraining, iClass};
            fileSetLabel(iTraining, start:stop) = iClass * ones(1, length(fileSetIdPerClass{iTraining, iClass}));
        end
    end

end


