function [crossvalIndex, nbSkipedLoop, cont] = EM_Error(trainingStrategy, crossvalIndex, nbSkipedLoop, nbFile)

    nbSkipedLoop = nbSkipedLoop + 1;
    disp('Skiped loop : EM-algorithm did not converge.');
    
    cont = 1;
    if crossvalIndex == nbFile,
        cont = 0;
    elseif trainingStrategy ~= 1,
        crossvalIndex = crossvalIndex - 1;
    end
        
end
