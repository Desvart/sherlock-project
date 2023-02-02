function [database, nbCrossvalidation, h] = initScript(inputFlag, databasePath, strategy, nbCrossvalidation)

    %%% Extract relevant informations of the database
    if inputFlag,
        database = databaseQuery(databasePath);
    else
        database = generateFeature2D();
%         database = generateFeature3D();
    end

    %%% Compute nb crossvalidation for training strategy 1
    if strategy == 0 && inputFlag ~= 0, % Do all crossvalidation
        nbCrossvalidation = database.nbFile;
    else
        
    end

    %%% Display script header
    displayMessage(1);

    %%% Build wait bar
    h = waitbarCreation(nbCrossvalidation);
%     h = 0;

end
