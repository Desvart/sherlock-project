function [trainingFile, testingFile] = ...
            generateTrainingAndTestingFileList(trainingStrategy, fileRootPathPerClass, ...
                        nbFilePerClass, nbTrainingFilePerClass, nbTestingFilePerClass, fileExtension_Size)
                    
                    
                    % persistent
                    
nbClass = length(nbFilePerClass);
                  
   %%% Generate indexes of the files to use for training and testing
    switch trainingStrategy,
        case 'oneLeft',
            % TO BE FILLED
            
        case 'fiftyFifty',
            fileIndexPerClass = cell(1, nbClass); % Preallocation
            for i = 1 : nbClass, 
                fileIndexPerClass{i} = randperm(nbFilePerClass(i)); % Random determination
                fileIndexPerClass{i} = 1 : nbFilePerClass(i);       % No random determination
            end
            
        otherwise,
            error('Unknown training strategy.');   
    end
    
    %%% Build the file list for training
    trainingFile = cell(sum(nbTrainingFilePerClass)+1, 1); % Preallocation
    trainingFile{1} = nbTrainingFilePerClass;
    for i = 1 : nbClass,
        trainingIndex                = fileIndexPerClass{i}(1:nbTrainingFilePerClass(i));
        firstId                      = sum(nbTrainingFilePerClass(1:i-1)) + 1;
        lastId                       = firstId + nbTrainingFilePerClass(i)-1;
        trainingFile((firstId:lastId)+1) = ...
                    genereateFileList(fileRootPathPerClass{i}, trainingIndex, fileExtension_Size);
    end
    
    %%% Build the file list for testing
    testingFile = cell(sum(nbTestingFilePerClass)+1, 1); % Preallocation
    testingFile{1} = nbTestingFilePerClass;
    for i = 1 : nbClass,
        testingIndex                 = fileIndexPerClass{i}(nbTrainingFilePerClass(i)+1:end);
        firstId                      = sum(nbTestingFilePerClass(1:i-1)) + 1;
        lastId                       = firstId + nbTestingFilePerClass(i)-1;
        testingFile((firstId:lastId)+1) = ...
                    genereateFileList(fileRootPathPerClass{i}, testingIndex, fileExtension_Size);
    end
    
end



% ----------------------------------------------------------------------------------------
% Function : genereateFileList.m
% 
% Purpose  : This function builds a list of file path sort by the list of index given in
%            input. The files are assumed to have format 'nameXXX.wav, where : 
%            name is the core of the name (always the same, no length constraint)
%            XXX is a N digit number, wich values are listed in the vector 'index'. The N
%            size is 'fileExtension_Size-4'.
%            The returned matrix 'filenames' holds one name per line.
%
% Inputs :  
%       fileRootPath    [string] Root path of the files belonging to the class. Ex.:
%                       './small_database/cris/scream'
%
%       index           [vector] list of indexes to extract
%
%       fileExtension_Size [scalar] Size of files extension (000.wav = 7; 0000.wav = 8)
%       
%
% Outputs : 
%       fileList        [cell matrix] List of file path, one per row.
%       
%
%
% Author    : Pitch Corp.
% Date      : 6.06.2010
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [fileList] = genereateFileList(fileRootPath, index, fileExtension_Size)
    
    nbFile = length(index);
    fileList = cell(nbFile, 1); % Preallocation
    for i = 1 : nbFile,
        indexShortStr   = int2str(index(i));
        indexSize       = length(indexShortStr);
        zeroPadding     = int2str(10^(fileExtension_Size-4-indexSize));
        indexStr        = [zeroPadding(2:end), indexShortStr, '.wav'];
        fileList{i}     = [fileRootPath, indexStr];
    end
    
end %function


% --------------------------------- End of file ------------------------------------------
