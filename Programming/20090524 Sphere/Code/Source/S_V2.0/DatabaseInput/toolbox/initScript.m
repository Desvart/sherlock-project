function [className, filePath, nbCrossvalidation, nbFile, h] = initScript(toolboxPath, databasePath, trainingStrategy, nbCrossvalidation)

    %%% Load path
    addpath(genpath(toolboxPath));

    %%% Extract relevant informations of the database
    [className, filePath] = extractDatabaseInformation(databasePath);

    %%% Compute nb crossvalidation for training strategy 1
    nbFile = length(filePath) - 1;
    if trainingStrategy == 1, % Do all crossvalidation
        nbCrossvalidation = nbFile;
    end

    %%% Display script header
    displayMessage(1);

    %%% Build wait bar
    h = waitbarCreation(nbCrossvalidation);

end
