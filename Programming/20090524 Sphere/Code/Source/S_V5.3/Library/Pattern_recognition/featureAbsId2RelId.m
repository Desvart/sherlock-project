function [classId, fileIdClassRef, featureIdFileRef] = featureAbsId2RelId(featureId, nFilePerClass, nFeaturePerFile)
% FEATUREABSID2RELID    Convert a feature identificator from the feature domain to the class and 
%                       file domain.
%
% Synopsis:     [classId, fileIdClassRef, featureIdFileRef] = featureAbsId2RelId(featureId, nFilePerClass, nFeaturePerFile);
%
% Inputs:   featureId       [int 1x1] Feature identificator (in feature domain) that one want to 
%                           convert in feature identificator in class domain.
%           nFilePerClass   [int 1xc] Number of files per each class.
%           nFeaturePerFile [int 1xf] Number of features per each file.
%
% Output:   classId         [int 1x1] Class identificator to wich belong the input feature
%                           identificator.
%           fileIdClassRef  [int 1x1] File identificator of the input feature in the class domain.
%           featureIdFileRef[int 1x1] Feature indentificator of the input feature in the class 
%                           domain.


% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    [fileId, featureIdFileRef] = featureRef2fileRef(featureId, nFeaturePerFile);
    [classId, fileIdClassRef] = fileAbsId2RelId(fileId, nFilePerClass);

end


% EoF -------------------------------------------------------------------------------------------- %
