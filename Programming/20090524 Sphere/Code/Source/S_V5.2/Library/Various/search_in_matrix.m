function matchingValue = search_in_matrix(matrix, elementToSearch, typeOfComparison)
% COMPARE_MATRIX
%
% Synopsis:     compare_matrix(vect1, vect2, 'sim');
%               compare_matrix(vect1, vect2, 'diff');
%
% Inputs  :
% Outputs : 

% Notes: DRAFT FUNCTION TO UPDATE TO CLEAN FUNCTION

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.10  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

%     clear all; close all; clc;
%     matrix = 2:5;
%     elementToSearch = [2,4];
%     typeOfComparison = 'diff';


    matrix     = matrix(:); % make A a row
    elementToSearch = elementToSearch(:); % make A a row
    m         = max([matrix; elementToSearch]);
    x1        = zeros(m,1);
    x2        = zeros(m,1);
    x1(matrix) = ones(length(matrix),1);
    x2(elementToSearch) = ones(length(elementToSearch),1);
    
    if strcmp(typeOfComparison, 'diff'),
        matchingIndex = (x1&~x2)';
        
    elseif strcmp(typeOfComparison, 'sim'),
        matchingIndex = (x1&x2)';
        
    end
    
    matchingValue = find(matchingIndex);
    
end
