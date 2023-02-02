function crossvalIndex = BadCovarianceIssue(errorFlag, crossvalIndex)

    if errorFlag,
        crossvalIndex = crossvalIndex - 1;
        break;
    end
    
end
