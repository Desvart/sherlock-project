% function fileIdClassRef = generate_random_file_index(nTraining, nClass, nFilePerClass)
close all; clear all; clc;
nTraining = 120;
nClass = 1;
nFilePerClass = [5, 15, 12];
nTestingFilePerClass = [2, 7,8];

if nTraining > factorial(nFilePerClass) ./ ((nTestingFilePerClass)*())
    error();
end

    fileIdClassRef = cell(nTraining, nClass); % Preallocation
    for iTraining = 1 : nTraining,
        for iClass = 1 : nClass,
            isVectorUnique = false;
            while isVectorUnique == false,
                %Generate a random vector index for this training and this class.
                tmp = randperm(nFilePerClass(iClass));
                tmp = sort(tmp(1:nTestingFilePerClass(iClass)));

                % Check if this random vector have been already picked up
                if iTraining == 1,
                    break;
                end
                for iTrainingChk = 1 : iTraining-1,
                        isVectorUnique = ~all(tmp == testingSetId{iTrainingChk, iClass});
                        if isVectorUnique == false, 
                            break;
                        end
                end
            end
            
%             fileIdClassRef{iTraining, iClass} = tmp;
            testingSetId{iTraining, iClass} = tmp;
        end 
    end
% end