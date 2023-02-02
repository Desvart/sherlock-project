function [output1, output2] = stdft_extraction0(nSignalSample)
% STDFT_EXTRACTION0 This function compute the maximum number of features that extract_stdft can
%                   extract from a file having signalSize samples.
%
% Input
% Output

% Project Sphere: Alpha 0.5.2
% Author: Pitch Corp.  -  2011.08.14  -  Copyleft ;-)
% ------------------------------------------------------------------------------------------------ %
    
    N = length(config_('stdftWindow'));
    if nargin == 0 || (nargin == 1 && nargout == 2),
        stdftChannelName = config_('stdftChannelName');
        if ~isempty(stdftChannelName),
            featureDim = length(channel_selection(stdftChannelName)) - 1;
            
        else
            featureDim = N/2 + 1;
            
        end        
    end
    
    if nargin == 1,
        nFrameSample = N * config_('stdftShift');
        nFeatureMax = floor((nSignalSample(1)-N)/nFrameSample) + 1;
        
    end
    
    if nargin == 0 && nargout == 1,
        output1 = featureDim;
    end
    
    if nargin == 1 && nargout == 1,
        output1 = nFeatureMax;
    end
    
    if nargin == 1 && nargout == 2,
        output1 = nFeatureMax;
        output2 = featureDim;
    end
        
    
end


% EoF -------------------------------------------------------------------------------------------- %

