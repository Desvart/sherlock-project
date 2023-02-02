function mappedFeature = apply_mapping(feature, mapping)

% Project Sphere: Alpha 0.5.3
% Author: Pitch Corp.  -  2011.09.05  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ % 

    %%% Substract mean
    featureM = bsxfun(@minus, feature, mapping(1, :)');
    
    %%% Divide by std
    featureN = bsxfun(@rdivide, featureM, mapping(2, :)');
    
    %%% Feature projection on new basis
    mappedFeature = mapping(3:end, :) * featureN;


end