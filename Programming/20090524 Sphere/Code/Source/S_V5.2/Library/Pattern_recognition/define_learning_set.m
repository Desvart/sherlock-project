function chrono = define_learning_set()
% DEFINE_LEARNING_SET   
%
% Synopsis:     define_learning_set();

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.09  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

% LOAD_RAW_FEATURE      Generate or extract raw features that will be used for the learning process.
%                       The choise of generating model based raw features or extracting "real" raw
%                       features from an sound database is defined in config_.m file.
%
% Synopsis:     load_raw_feature()
%
% Inputs:   []
%
% Output:   chrono  = execution time of the function (s).

% Notes: 
    

    % --- Launch function chronometer
    chronoTic = tic;
    
    
    % --- Define the number of files used for training and testing sets
    learningStrategy = config_('learningStrategy');
    nFile            = feature_('nFile');
    nFilePerClass    = feature_('nFilePerClass');
    nClass           = feature_('nClass');
%     dbstop in define_learning_set at 34
    if learningStrategy,
        nTrainingFile = min(ceil(learningStrategy * nFile), nFile-1); % min = 1; max = nFile-1
        nTestingFile  = nFile - nTrainingFile;
        
        if nTestingFile ~= 1,
            nTrainingFilePerClass = min(ceil(learningStrategy * nFilePerClass), nFilePerClass - 1); % min = 1; max = nFile-1
            nTestingFilePerClass  = nFilePerClass - nTrainingFilePerClass;
        
        end
        
        nTraining = config_('nTraining');
        
    else
        nTrainingFile = nFile - 1;
        nTestingFile  = 1;
        nTraining     = nFile;

    end
    dbstop in define_learning_set at 56
    
    % --- Select file indices to build training and testing data sets
    if nTestingFile == 1, 
        [trainingSetId, testingSetId] = generate_training_set_id0(nTraining, nFile, nClass, nFilePerClass);
        
    else
        [trainingSetId, testingSetId] = generate_training_set_id1(nFilePerClass, nTestingFilePerClass, nTraining, nClass);
        
    end
    
%     setSizePerClass = compute_set_size_for_each_class(nTrainingFile, trainingFileId, nTestingFile, testingFileId, nTraining);
    
    
    % --- Transform all abolute file indexes in relative indexes
    % At the end of the process files are store in a cell array of this form:
    % learningSetId(nTraining, nClass, 2)
    % For each trainingId and for each class, the cell array is divided in two. In those two cells, 
    % there is the file index for the training and the testing parts.
    % IE: learningSetId{3, 2, 1} gives all the training (1) file indexes used for class 2 in 3rd 
    % training.
%     learningSetId = cell(nTraining, nClass, 2); % Preallocation
%     for iTraining = 1 : nTraining,
%         
%         % Preallocation loop
%         for iClass = 1 : nClass,
%             learningSetId{iTraining, iClass, 1} = zeros(1, setSizePerClass(iTraining, iClass, 1));
%             learningSetId{iTraining, iClass, 2} = zeros(1, setSizePerClass(iTraining, iClass, 2));
%             
%         end
% %         dbstop in define_learning_set at 80
%         % Training file loop
%         idPerClass  = zeros(1, nClass);
%         for iFile = 1 : nTrainingFile,
%             [classId, fileIdClassRef] = fileAbsId2RelId(trainingFileId(iFile, iTraining), nFilePerClass);
%             idPerClass(classId) = idPerClass(classId) + 1;
%             learningSetId{iTraining, classId, 1}(idPerClass(classId)) = fileIdClassRef;
% 
%         end
%         
%         % Testing file loop
%         idPerClass  = zeros(1, nClass);
%         for iFile = 1 : nTestingFile,
%             [classId, fileIdClassRef] = fileAbsId2RelId(testingFileId(iFile, iTraining), nFilePerClass);
%             idPerClass(classId) = idPerClass(classId) + 1;
%             learningSetId{iTraining, classId, 2}(idPerClass(classId)) = fileIdClassRef;
% 
%         end
%        
%     end
    dbstop in define_learning_set at 98
    % Save learningSetId in feature structure
%     feature_('learningSetId', learningSetId);

    
    % --- Store execution time of this function
    chrono = toc(chronoTic);
    
end


function [trainingSetId, testingSetId] = generate_training_set_id0(nTraining, nFile, nClass, nFilePerClass)
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

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    if config_('isRandom'),
        fileId = randperm(nFile);
        testingFileId = sort(fileId(1:min(nTraining, nFile)));
        
    else
        testingFileId = (1:min(nTraining, nFile))';
        
    end
    
    trainingSetId = cell(nTraining, nClass); % Preallocation
    testingSetId  = cell(nTraining, nClass); % Preallocation
    for iTraining = 1 : nTraining,
            for iClass = 1 : nClass,
                trainingSetId{iTraining, iClass} = 1:nFilePerClass(iClass);
                testingSetId{iTraining, iClass} = 0;
                
            end
            
            [classId, fileIdClassRef] = fileAbsId2RelId(testingFileId(iTraining), nFilePerClass);
            testingSetId{iTraining, classId} = fileIdClassRef;
            trainingSetId{iTraining, classId}(fileIdClassRef) = [];
        
    end
            
end   



function [trainingSetId, testingSetId] = generate_training_set_id1(nFilePerClass, nTestingFilePerClass, nTraining, nClass)
% GENERATE_TRAINING_SET_ID1
%
% Synopsis:     generate_training_set_id1(nTrainingFile, nTestingFile, nTraining, nFile);
%
% Inputs  :
% Outputs : trainingFileId  [int txf] Training file indentificator for each training loop. Each line
%                           corresponds to a training.
%           testingFileId   [int tx1] Testing file indentificator for each training loop. Each line
%                           corresponds to a training.

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.11  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    testingSetId = cell(nTraining, nClass); % Preallocation

    if config_('isRandom'),
        fileIdClassRef = cell(nTraining, nClass); % Preallocation
        
        for iTraining = 1 : nTraining,
            for iClass = 1 : nClass,
                tmp = randperm(nFilePerClass(iClass));
%                 for iTraining = 1 : nTraining,
%                     for iClass = 1 : nClass,
                fileIdClassRef{iTraining, iClass} = randperm(nFilePerClass(iClass));
                
            end
        end
        
        for iTraining = 1 : nTraining,
            for iClass = 1 : nClass,
                fileIdClassRef{iTraining, iClass} = randperm(nFilePerClass(iClass));
                testingSetId{iTraining, iClass} = sort(fileIdClassRef{iClass}(1:nTestingFilePerClass(iClass)));
                
            end
        end
        
    else       
        for iTraining = 1 : nTraining,
            for iClass = 1 : nClass,
                if nTestingFilePerClass(iClass) + iTraining - 1 <= nFilePerClass(iClass),
                    testingFileIdForThisClass = iTraining:(nTestingFilePerClass(iClass) + iTraining - 1);
                    
                else
                    testingFileIdForThisClass = [1:mod(nTestingFilePerClass(iClass) + iTraining - 1, ...
                                            nFilePerClass(iClass)), iTraining:nFilePerClass(iClass)];
                    
                end
                testingSetId{iTraining, iClass} = testingFileIdForThisClass;
                
            end
        end
    end
    
    trainingSetId = cell(nTraining, nClass); % Preallocation
    for iTraining = 1 : nTraining,
        for iClass = 1 : nClass,
            trainingSetId{iTraining, iClass} = search_in_matrix(1:nFilePerClass(iClass), testingSetId{iTraining, iClass}, 'diff');

        end
    end
end


function setSizePerClass = compute_set_size_for_each_class(nTrainingFile, trainingFileId, nTestingFile, testingFileId, nTraining)
% COMPUTE_SET_SIZE_FOR_EACH_CLASS
%
% Synopsis:     compute_set_size_for_each_class(nTrainingFile, trainingFileId, nTestingFile, testingFileId, nTraining);
%
% Inputs  :
% Outputs : 

% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.09  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    nFilePerClass    = feature_('nFilePerClass');
    nClass           = feature_('nClass');
    
    setSizePerClass = zeros(nTraining, nClass, 2); % Preallocation
    for iTraining = 1 : nTraining,
        for iFile = 1 : nTrainingFile,
            classId = fileAbsId2RelId(trainingFileId(iTraining, iFile), nFilePerClass);
            setSizePerClass(iTraining, classId, 1) = setSizePerClass(iTraining, classId, 1) + 1;

        end
        
        for iFile = 1 : nTestingFile,
            classId = fileAbsId2RelId(testingFileId(iTraining, iFile), nFilePerClass);
            setSizePerClass(iTraining, classId, 2) = setSizePerClass(iTraining, classId, 2) + 1;

        end
    end
end



function fileIdClassRef = generate_random_file_index(nTraining, nClass, nFilePerClass)

    fileIdClassRef = cell(nTraining, nClass); % Preallocation
    for iTraining = 1 : nTraining,
        for iClass = 1 : nClass,
            isVectorUnique = true;
            while isVectorUnique == true,
                %Generate a random vector index for this training and this class.
                tmp = randperm(nFilePerClass(iClass));

                % Check if this random vector have been already picked up
                for iTrainingChk = 1 : iTraining-1,
                        isVectorUnique = isVectorUnique & ~all(tmp == fileIdClassRef{iTrainingChk, iClass});
                        
                end
            end
            
            fileIdClassRef{iTraining, iClass} = tmp;
        end 
    end
end















