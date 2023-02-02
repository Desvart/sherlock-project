% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [trainingFeature, testingFeature, perfprop] = featureAccess(input, reco, database, model)
    
    if input.inputFlag
        [trainingFile, testingFile] = generateFileList(reco, database);
        trainingFeature = featureExtraction(trainingFile, reco.trainingSNR, model);
        testingFeature  = featureExtraction(testingFile,  reco.testingSNR,  model);
        
    else
        [trainingFeature, testingFeature] = featureSelection(reco, database);
        
    end
    
    perfprop.nbFilePerClass = testingFeature.nbFilePerClass;
    perfprop.nbClass        = testingFeature.nbClass;
    perfprop.nbFile         = testingFeature.nbFile;
    
    

    
end
