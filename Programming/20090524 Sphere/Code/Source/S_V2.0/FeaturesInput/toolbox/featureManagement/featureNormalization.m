% ----------------------------------------------------------------------------------------
% Function : featureNormalization.m
% 
% Purpose  : This function normalizes extracted feature
%
%
% Inputs :  
%       signal
%       
%
% Outputs : 
%       
%
%
% Author    : Pitch Corp.
% Date      : 
% Copyright : Copyleft ;-)
% ----------------------------------------------------------------------------------------


function [feature, modelParam] = featureNormalization(feature, modelParam)
    % This normalization is done by shifting the mean of each dimension of the feature 
    % matrix to 0 and to compress or dilate the standard deviation of each dimension of 
    % the feature matrix to 1. This normalization is done over all training signals all 
    % classes. 
    %               normFeature = (feature - meanForEachDim) ./ stdForEachDim;
    %
    % Note : std(f) = sqrt(1/N*sum((fi-m)^2), i=[1,N]); with m = mean(f);
    %        So, if mean(f)=0 => std(f) = sqrt(mean(f.^2))
    %        This implementation is twice fast than the original std.
    
    %%% Substract mean
    meanNorm = mean(feature, 2);
    featureM = bsxfun(@minus, feature, meanNorm);
    
    %%% Divide by std
    stdNorm = sqrt(mean(featureM.^2, 2));
    feature = bsxfun(@rdivide, featureM, stdNorm);
    
    
    modelParam.meanNorm = meanNorm;
    modelParam.stdNorm = stdNorm;
    
end %function


% --------------------------------- End of file ------------------------------------------
