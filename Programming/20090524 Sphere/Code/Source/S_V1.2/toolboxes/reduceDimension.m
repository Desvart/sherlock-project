function [feature, featureDim] = reduceDimension(feature, eigenVectors)

    feature = eigenVectors * feature;
    featureDim  = size(eigenVectors, 1);

end
