% ------------------------------------------------------------------------------------------------ %
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %


function [trainingFeature, testingFeature, perfprop] = featureAccess(input, training, database, model)
    
    if input.inputFlag
        [trainingFile, testingFile] = generateFileList(training, database);
        trainingFeature = featureExtraction(trainingFile, training.trainingSNR, model);
        testingFeature  = featureExtraction(testingFile,  training.testingSNR,  model);
        
    else
        switch input.inputMode,
            
            case 2,
                % nbClass, nbFilePerClass, nbFeaturePerFile, {alpha, mu, sigma}
                [trainingFeature, testingFeature] = generateFeature2D();
                
            case 3,
                [trainingFeature, testingFeature] = generateFeature3D();
        end
        
    end
    
    perfprop.nbFilePerClass = testingFeature.nbFilePerClass;
    perfprop.nbClass        = testingFeature.nbClass;
    perfprop.nbFile         = testingFeature.nbFile;
    
    

    
end
