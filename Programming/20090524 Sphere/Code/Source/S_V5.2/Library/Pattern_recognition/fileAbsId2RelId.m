function [classId, fileIdClassRef] = fileAbsId2RelId(fileId, nFilePerClass)
% FILEABSID2RELID   Convert a file identificator from the file domain to the class domain
%
% Synopsis:     [classId, fileIdClassRef] = fileAbsId2RelId(fileId, nFilePerClass);
%
% Inputs:   fileId          [int 1x1] File identificator (in file domain) that one want to 
%                           convert in file identificator in class domain.
%           nFilePerClass   [int 1xc] Number of files per each class.
%
% Output:   classId         [int 1x1] Class identificator to wich belong the input file
%                           identificator.
%           [fileIdClassRef][int 1x1] File identificator of the input file in the class domain.


% Notes: 

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.06  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    nFilePerClassCumSum = [0, cumsum(nFilePerClass)];
    classId = find(nFilePerClassCumSum >= fileId, 1) - 1;
    
    if nargout == 2,
        fileIdClassRef = fileId - nFilePerClassCumSum(classId);
    end

end


% EoF -------------------------------------------------------------------------------------------- %
