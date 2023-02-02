function isRealVector = is_real_vector(input)
% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %

    isRealVector = false;
    
    if ~iscell(input),
        if ~isscalar(input),
            if ~ischar(input),
                if isreal(input),
                    inputSize = size(input);
                    if length(inputSize) == 2,
                        if prod(inputSize) == max(inputSize),
                            isRealVector = true;
                            
                        end
                    end
                end
            end
        end
    end
end