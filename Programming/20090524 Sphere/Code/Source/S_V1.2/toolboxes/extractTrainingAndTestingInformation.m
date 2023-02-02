function [nbTrainingFile, nbTestingFile] = ...
                    extractTrainingAndTestingInformation(nbFilePerClass, trainingStrategy)

    %%% Number of signals for training and testing in each class
    switch trainingStrategy,
        case 'oneLeft',
            nbTrainingFile = sum(nbFilePerClass) - 1;
            nbTestingFile = 1;

        case 'fiftyFifty',
            nbTrainingFile = ceil(nbFilePerClass/2);
            nbTestingFile = nbFilePerClass - nbTrainingFile;
    end              
                   
end
