function [startRoiIdxArray, stopRoiIdxArray, nRoi, stdRatioSignal, stdBackward, stdForward, roi] = ...
                                   PANDAS_determine_roi(signal, stdWinSize, stdRatioSignalThreshold)
% PANDAS_DETERMINE_ROI   Determine roughly the regions of interest (RoI: start location of each
%   impulsion) by comparing the value of a forward standard deviation and a backward one. A sample
%   belong to a RoI if the forward std is x times higher than the backward std.
%
% Inputs :
% - signal                      [dbl 1xn] Absolute value of the watch signal.
% - [stdWinSize]                [int 1x1] Size of the running std windows. Default value = 41
% - [stdRatioSignalThreshold]   [int 1x1] Threshold of stdRatio signal. Default value = 3
%
% Outputs : 
% - startRoiIdxArray    [dbl 1xm] Array containing all RoIs first indexes
% - stopRoiIdxArray     [dbl 1xm] Array containing all RoIs last indexes
% - nRoi                [int 1x1] Number of RoIs detected
% - stdRatioSignal      [dbl 1xn] Signal used to dermine RoIs (ratio between backward and forward
%                       running std)
% - [stdBackward]       [dbl 1xn] Backward running std signal
% - [stdForward]        [dbl 1xn] Fackward running std signal
% - [roi]               [bool 1xn] RoI signal
%
% See also movingstd

% Project : Sherlock Holmes - Pandas (Alpha 2.3)
% 2012.08.10 - 2013.01.09
%
% � 2012-2015 Pitch Corp.
%   Author : Pitch
%   with the gracious and invaluable assistance of P. Bors�.
    


    %% Manage inputs
    
    narginchk(1, 3);
    nargoutchk(4, 7);
    
    if any(signal < 0),
        signal = abs(signal);
    end
    
    if nargin < 2,
        stdWinSize = 41;
    end
    
    if nargin < 3,
        stdRatioSignalThreshold = 3;
    end


    
    %% Compute backward and forward moving standard deviation.
    
    stdBackward = movingstd(signal, stdWinSize, 'backward');
    stdForward  = [stdBackward(stdWinSize:end), zeros(1, stdWinSize-1)];

    
    
    %% Compute threshold as a simple threshold through the ratio of backward std and forward std
    
    roi = stdForward > (stdRatioSignalThreshold .* stdBackward);

    stdRatioSignal = stdForward ./ stdBackward;
    stdRatioSignal(1) = 1;
   


    %% Detect RoI borders
    
    roiBorder = roi(1:end-1) - roi(2:end);
    startRoiIdxArray = find(roiBorder == -1) + 1;
    stopRoiIdxArray  = find(roiBorder == +1);

    % Remove borders that are too close from the signal beginning
    startRoiIdxArray(startRoiIdxArray < stdWinSize/2) = [];
    stopRoiIdxArray(stopRoiIdxArray   < stdWinSize/2) = [];
    
    % Remove borders that are too close from the signal end
    startRoiIdxArray(startRoiIdxArray > stopRoiIdxArray(end)) = [];
    
    nRoi = length(startRoiIdxArray);
    
    

end
% eof
