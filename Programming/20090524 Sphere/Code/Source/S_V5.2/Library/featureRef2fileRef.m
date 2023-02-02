function [fileId, featureIdFileRef] = featureRef2fileRef(featureId, nFeaturePerFile)
% FEATUREREF2FILEREF   Convert a feature identificator from the feature domain to the file domain
%
% Synopsis:     [fileId, featureIdFileRef] = featureRef2fileRef(featureId, nFeaturePerFile);
%
% Inputs:   featureId       [int 1x1] Feature identificator (in feature domain) that one want to 
%                           convert in feature identificator in file domain.
%           nFeaturePerFile [int 1xf] Number of features per each file.
%
% Output:   fileId          [int 1x1] File identificator to wich belong the input feature
%                           identificator.
%           featureIdFileRef[int 1x1] Feature identificator of the input feature in the file domain.


% Notes: This function is only an alias of "fileAbsId2RelId" function.

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    [fileId, featureIdFileRef] = fileAbsId2RelId(featureId, nFeaturePerFile);

end


% EoF -------------------------------------------------------------------------------------------- %
