function [learningParam, nbIt] = computeAdvancedLearningParam(feat, learningParam)

    nbIt = learningParam.nbIt;
    learningParam.nbTrFile = floor(learningParam.strategy*feat.nbFile);
    learningParam.nbTeFile = feat.nbFile - learningParam.nbTrFile;

end


% EoF -------------------------------------------------------------------------------------------- %
