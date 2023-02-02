clear all; clc;

data = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23;...
        0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23];
data = bsxfun(@plus, data, [100;200]);

nbClass = 2;
nbFilePerClass = 3;
nbFeaturePerClass = 12;
nbFeaturePerFile = 4;



nbTrainingFile = ceil(nbFilePerClass*2/3);
nbTestingFile = nbFilePerClass - nbTrainingFile;



fileIndex = randperm(nbFilePerClass);

trainingFileIndex = fileIndex(1:nbTrainingFile);
testingFileIndex  = fileIndex(nbTrainingFile+1:end);

trainingFeature = [];
for i = 1 : nbClass,
    
    first = (i-1)*nbFeaturePerClass + (trainingFileIndex-1)*nbFeaturePerFile + 1 ; 
    last  = first + nbFeaturePerFile - 1;
    for j = 1 : nbTrainingFile,
        trainingFeature = [trainingFeature data(:,first(j):last(j))];
    end

end
