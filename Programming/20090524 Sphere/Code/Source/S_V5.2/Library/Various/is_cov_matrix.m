function isCovMatrix = is_cov_matrix(matrix)
% == Positive-definite matrix
% => sym
% => eigen-values are positive

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    isCovMatrix = false;
    if ~iscell(matrix),
        if ~isscalar(matrix),
            if ~ischar(matrix),
                if isreal(matrix),
                    matrixSize = size(matrix);
                    if length(matrixSize) == 2,
                        if matrixSize(1) == matrixSize(2),
                            if matrixSize(1) > 1,
                                if all(matrix == matrix'),
                                    if all(eig(matrix) > 0),
                                        isCovMatrix = true;
                                        
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end