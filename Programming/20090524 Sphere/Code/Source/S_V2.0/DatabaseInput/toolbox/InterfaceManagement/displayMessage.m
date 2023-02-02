function displayMessage(id, confusionMatrix, globalPerformance, stepPerformance, className)

    error(nargchk(1, 5, nargin));

    persistent crossvalidationId;
    if isempty(crossvalidationId),
        crossvalidationId = 0;
    end
    
    switch id,
        
        case 1,
            display('                                                      ');
            display('% -------------------------------------------------- %');
            display('       Sound Recognition: Start Crossvalidation       ');
            display('% -------------------------------------------------- %');
            display('                                                      ');
            
        case 2,
            crossvalidationId = crossvalidationId + 1;
            display( '                   ')
            display( '                   ')
            display(['Iteration Nr. ', num2str(crossvalidationId), '.']);
            display( '------------------------------');
            
        case 3,
            display(['Global performance : ', num2str(globalPerformance*100), '%.']);
            display(['Step performance   : ', num2str(stepPerformance*100), '%.']);                                                         
            display( '                     ');
            display( 'Confusion matrix :');
            
            nbClass = size(confusionMatrix, 1);
            for i=1:nbClass,
                a = [];
                for j=1:nbClass,
                    a = [a, sprintf(' %3d', confusionMatrix(i,j))]; %#ok<AGROW>

                end
                display([sprintf('%10s : ', className{i}), a]);
            end
            
    end

end
