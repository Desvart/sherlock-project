function [classId, featureIdClassRef] = featureRef2ClassRef(featureId, nFeaturePerClass)
% FEATUREREF2CLASSREF   Convert a feature identificator from the feature domain to the class domain
%
% Synopsis:     [classId, featureIdClassRef] = featureRef2ClassRef(featureId, nFeaturePerClass);
%
% Inputs:   featureId       [int 1x1] Feature identificator (in feature domain) that one want to 
%                           convert in feature identificator in class domain.
%           nFeaturePerClass[int 1xc] Number of features per each class.
%
% Output:   classId         [int 1x1] Class identificator to wich belong the input feature
%                           identificator.
%           featureIdClassRef[int 1x1] Feature identificator of the input feature in the class 
%                           domain.


% Notes: This function is only an alias of "fileAbsId2RelId" function.

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    [classId, featureIdClassRef] = fileAbsId2RelId(featureId, nFeaturePerClass);

end


% EoF -------------------------------------------------------------------------------------------- %
