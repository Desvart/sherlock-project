

function [trainingFile, testingFile] = generateFileList(training, database)

    strategy = training.strategy;

	% If we are in mode "one left and do all crossvalidation"
    if strategy == 0,
        [trainingFile, testingFile] = generateOneLeftFileList(database, 0);

	% If we are in mode "one left"
    elseif strategy == 1,
        [trainingFile, testingFile] = generateOneLeftFileList(database, training.randomFlag);
        
	% If we are in mode "normal"
    elseif strategy > 0 && strategy < 1,
        [trainingFile, testingFile] = generateNormalFileList(training, database);
                                       
    end
    
end



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nested function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ----------------------------------------------------------------------------------------
% Function : folderContents.m
% 
% Purpose  : A folder can contain sub-folders and files. This function counts the number
%            of elements (sub-folders and files) that are contained in a folder and gives 
%            their names.
%
% Inputs :  
%       folderPath  [string] 
%                   Path of the folder to analyse
%
% Outputs : 
%       nbElement   [scalar] 
%                   Number of elements found in the folder.
% 
%       elementName [cell : nbElement x 1] 
%                   Names of the elements found. Elements that names begin by the dot
%                   caracter (".") are considered as hidden files or folders and then are
%                   discarded by this function.
%
% 
% Author    : Pitch Corp.
% Date      : 16.07.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function [trainingFile, testingFile] = generateNormalFileList(training, database)
    

    %%% Extract relevant informations
    randomFlag              = training.randomFlag;
    nbFilePerClass          = database.nbFilePerClass;                     
    nbTrainingFilePerClass  = ceil(nbFilePerClass*training.strategy);       
    nbTestingFilePerClass   = nbFilePerClass - nbTrainingFilePerClass;
    
    
    %%% This loop generates the files index for the training and the testing parts.
    
    % Loop initialization
    cumulativNbFilePerClass = 0;
    lastTrainingIndex       = 0;
    lastTestingIndex        = 0;
    nbClass                 = database.nbClass;
    for i = 1 : nbClass,
        
        if randomFlag,
            randIndexForThisClass = cumulativNbFilePerClass + randperm(nbFilePerClass(i));
        else
            randIndexForThisClass = cumulativNbFilePerClass + (1:nbFilePerClass(i));
        end
        cumulativNbFilePerClass = cumulativNbFilePerClass + nbFilePerClass(i);
        
        firstTrainingIndex  = lastTrainingIndex + 1;
        lastTrainingIndex   = firstTrainingIndex + nbTrainingFilePerClass(i) - 1;
        
        trainingFileIndex(firstTrainingIndex:lastTrainingIndex) = randIndexForThisClass(1:nbTrainingFilePerClass(i));
                                   
        firstTestingIndex   = lastTestingIndex + 1;
        lastTestingIndex    = firstTestingIndex + nbTestingFilePerClass(i) - 1;
        
        testingFileIndex(firstTestingIndex:lastTestingIndex)  = randIndexForThisClass(nbTrainingFilePerClass(i)+1:end);
        
    end
                                                     

    %%% This part builds the cells containing the training and the testing files path
    %   based on the previously files index generation.
    
    filePath = database.filePath;
    
    trainingFile.nbFilePerClass = nbTrainingFilePerClass;
    trainingFile.nbFile         = sum(nbTrainingFilePerClass);
    trainingFile.path           = filePath(trainingFileIndex);
    trainingFile.nbClass        = nbClass;
    
    testingFile.nbFilePerClass  = nbTestingFilePerClass;
    testingFile.nbFile          = sum(nbTestingFilePerClass);
    testingFile.path            = filePath(testingFileIndex);
    testingFile.nbClass         = nbClass;

end


% ----------------------------------------------------------------------------------------
% Function : folderContents.m
% 
% Purpose  : A folder can contain sub-folders and files. This function counts the number
%            of elements (sub-folders and files) that are contained in a folder and gives 
%            their names.
%
% Inputs :  
%       folderPath  [string] 
%                   Path of the folder to analyse
%
% Outputs : 
%       nbElement   [scalar] 
%                   Number of elements found in the folder.
% 
%       elementName [cell : nbElement x 1] 
%                   Names of the elements found. Elements that names begin by the dot
%                   caracter (".") are considered as hidden files or folders and then are
%                   discarded by this function.
%
% 
% Author    : Pitch Corp.
% Date      : 16.07.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------

function [trainingFile, testingFile] = generateOneLeftFileList(database, randomFlag)
    
	%%% Extract relevant informations
    nbFilePerClass  = database.nbFilePerClass;
    nbFile          = database.nbFile;
    nbClass         = database.nbClass;
    filePath        = database.filePath;
    
    
    persistent testingFileIndex testingFileIndex_hist;
    
    if randomFlag,
        
        testingFileIndex = randi(nbFile); % Select a random integer value between 1 and nbFile
        % If this value has been previously already choosen, choose another one
        while any(testingFileIndex_hist == testingFileIndex),
            testingFileIndex = randi(nbFile);
        end
        testingFileIndex_hist = [testingFileIndex_hist, testingFileIndex]; % Stock old index in an array
        
    else
        
        % Initialization
        if isempty(testingFileIndex),
            testingFileIndex = 0;
        end
        % Increment index
        testingFileIndex = testingFileIndex + 1;
        
    end
    
    
    testingFile.path{1} = filePath{testingFileIndex};
    testingFile.nbFile  = 1;
    
    
    fileIndex           = 1:nbFile;
    trainingFileIndex   = fileIndex(fileIndex ~= testingFileIndex);
    trainingFile.path   = filePath(trainingFileIndex);
    trainingFile.nbFile = nbFile - 1;
    
    
    trainingFile.nbFilePerClass = nbFilePerClass;
    testingFile.nbFilePerClass  = zeros(1, nbClass);
    for i = 1 : nbClass,
        testingFileRelativeIndex = testingFileIndex - sum(nbFilePerClass(1:i-1));
        if testingFileRelativeIndex <= nbFilePerClass(i),
            trainingFile.nbFilePerClass(i) = nbFilePerClass(i) - 1;
            testingFile.nbFilePerClass(i) = 1;
            break;
        end
    end
    
    
    trainingFile.nbClass = nbClass;
    testingFile.nbClass  = nbClass;
    

end

% --------------------------------- End of file ------------------------------------------



















