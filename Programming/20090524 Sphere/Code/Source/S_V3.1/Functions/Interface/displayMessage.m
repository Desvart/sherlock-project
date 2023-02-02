function displayMessage(id, performance, className, nbCrossvalidation, nbMissedTraining)

    error(nargchk(1, 5, nargin));

    persistent crossvalidationId;
    if isempty(crossvalidationId),
        crossvalidationId = 0;
    end
    
    switch id,
        
        case 1,
            database = performance;
            str = num2str(database.nbFilePerClass(1));
            for i = 2 : database.nbClass,
                str = [str ' - ' num2str(database.nbFilePerClass(i))];
            end
            
            display('                                                      ');
            display('% -------------------------------------------------- %');
            display('       Sound Recognition: Start Crossvalidation       ');
            display('% -------------------------------------------------- %');
            display('                                                      ');
            display(['Number of class : ' num2str(database.nbClass)]);
            display(['Number of files : ' num2str(database.nbFile) ' (' str ')']);
            
        case 2,
            crossvalidationId = crossvalidationId + 1;
            display( '                   ')
            display( '                   ')
            display(['Iteration Nr. ', num2str(crossvalidationId), '.']);
            display( '------------------------------');
            
        case 3,
            display(['Global performance : ', num2str(performance.globalPerformance*100), '%.']);
            display(['Step performance   : ', num2str(performance.stepPerformance*100), '%.']);                                                         
            display( '                     ');
            display( 'Confusion matrix :');
            
            nbClass = size(performance.confusionMatrix, 1);
            for i=1:nbClass,
                a = [];
                for j=1:nbClass,
                    a = [a, sprintf(' %3d', performance.confusionMatrix(i,j))]; %#ok<AGROW>

                end
                if iscell(className),
                    display([sprintf('%10s : ', className{i}), a]);
                else
                    display([sprintf('%d : ', i), a]);
                end
            end
            
        case 4,
            display( '                     ');
            display(['Number of successful training : ', num2str(nbCrossvalidation-nbMissedTraining), '/', num2str(nbCrossvalidation)]);
            
    end

end
