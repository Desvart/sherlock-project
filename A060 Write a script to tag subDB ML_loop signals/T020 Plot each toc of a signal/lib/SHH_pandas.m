function [degagementStartIdxArray, chuteStartIdxArray] = ...
                               SHH_pandas_B10(signal, stdWinSize, stdRatioThreshold, distThreshold)
% PANDAS_   Extract the start indexes of the two main impulse of each tocs (namely "degagement" and
% "chute" which are, respectively, the first and the third theoretical impulse present in a toc).
%
% Inputs :
% - signal              [dbl 1xn] Watch signal containing the tocs to analyse.
% - [stdWinSize]        [int 1x1] Size of the running std windows. Default value = 41
% - [stdRatioThreshold] [int 1x1] Threshold of stdRatio signal. Default value = 15
% - [distThreshold]     [int 1x1] Threshold distance to remove undesired potential intermediate 
%                       pulse.
%                       Default value = 1600 samples (= 8 ms @ fs = 20 kS/s)
%
% Outputs : 
% - degagementStartIdxArray     [int 1xm] Array containing all "degagement" first indexes
% - chuteStartIdxArray          [int 1xm] Array containing all "chute" first indexes
%
% See also movingstd, findpeaks

% Project : Sherlock Holmes - Pandas (Beta 1.0)
% 2012.08.10 - 2013.01.21
%
% � 2012-2015 Pitch Corp.
%   Author  : Pitch
%   with the gracious and invaluable assistance of P. Bors�.

% Log
% 2013.01.21    Test over database ViSo "Barillet" : test passed! (Beta 1.0 = A1.3.1)
% 2013.01.17    Bug fix and fine tuning (A1.3.0)
%               - Add a function (PANDAS_remove_middle_pulse) to remove behavior that detect a third 
%                 pulse between "d�gagement" and "chute" (the "UFO" one).
%               - Modify stdRatioThreshold default value from 20 to 15 (adaptation for signal 
%                 ML03_R00_B06_N01).
% 2013.01.15    Fixed bug that detect local double peaks in hard thresholding (A1.2.0)
% 2013.01.10    File restructuration (A1.0.0).
% 2012.08.10	File creation (Alpha 0.0.0).


    %% Manage inputs

    narginchk(1, 4);
    nargoutchk(1, 2);
    
    if nargin < 2,
        stdWinSize = 41; % Samples
    end
    
    if nargin < 3,
        stdRatioThreshold = 15; % Dimensionless ratio
    end
    
    if nargin < 4,
        distThreshold = 1600; % Samples
    end
    

    %% Select RoIs that contains start idx of two main impulses if each toc (namely "degagement" 
    % and "chute").
    
    [startRoiIdxArray, stopRoiIdxArray, nRoi, stdRatioSignal] = ...
                                        PANDAS_determine_roi(signal, stdWinSize, stdRatioThreshold);
                                    
                                                                  
    %% Detect precisely start location of impulsion in selected RoI
    
    preciseStartIdxArray = ...
          PANDAS_detecte_precise_start_idx(startRoiIdxArray, stopRoiIdxArray, nRoi, stdRatioSignal);
    

	%% Remove potential middle pulse and split results in two variables
    
    [degagementStartIdxArray, chuteStartIdxArray] = ...
                                    PANDAS_remove_middle_pulse(preciseStartIdxArray, distThreshold);
      

end % Main function - pandas_



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
    


    %% Manage inputs
    
    narginchk(1, 3);
    nargoutchk(4, 7);
    
    if any(signal < 0),
        signal = abs(signal);
    end

    % "Magic" constants
	distDoublePeaksThreshold = 20; % Samples (value determined by observation.)

    
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
    
    % Remove double peaks detection in hard thresholding
    distBetweenStartRoiArray = startRoiIdxArray(2:end) - startRoiIdxArray(1:end-1);
    startRoiIdxArray( find(distBetweenStartRoiArray < distDoublePeaksThreshold) + 1 ) = [];
    distBetweenStopRoiArray = startRoiIdxArray(2:end) - startRoiIdxArray(1:end-1);
    stopRoiIdxArray( distBetweenStopRoiArray < distDoublePeaksThreshold ) = [];
    
    nRoi = length(startRoiIdxArray);
    
    %%% Debug - START
%     figure; hold on;
%     plot(signal);
%     plot(stdRatioSignal, 'r');
%     plot(roi, 'g');
%     line([1, length(signal)], stdRatioSignalThreshold*[1, 1], 'Color', 'm');
    %%% Debug - STOP
    
end % Subfunction - PANDAS_determine_roi



function preciseStartIdxArray = ...
           PANDAS_detecte_precise_start_idx(startRoiIdxArray, stopRoiIdxArray, nRoi, stdRatioSignal)
% PANDAS_DETECTE_PRECISE_START_IDX   Determine precisely the start index that can be found in each
% RoIs. This start local is located where the moving std ratio signal is maximum.
%
% Inputs : 
% - startRoiIdxArray    [dbl 1xm] Array containing all RoIs first indexes
% - stopRoiIdxArray     [dbl 1xm] Array containing all RoIs last indexes
% - nRoi                [int 1x1] Number of RoIs detected
% - stdRatioSignal      [dbl 1xn] Signal used to dermine RoIs (ratio between backward and forward
%                       running std)
%
% Outputs :
% - preciseStartIdxArray    [int 1xm] Array containing all start indexe detected in each RoI. The
%                           first value is a "degagement" start index and is followed by the next
%                           impulse which is a "chute" and then a "degagement" and so on.
%
% See also findpeaks


    %% Manage inputs
    
	narginchk(4, 4);
    nargoutchk(1, 1);
    
    
    %%

    preciseStartIdxArray = zeros(1, nRoi); % Preallocation
    for iRoi = 1 : nRoi,
        
        % Extract start and stop index for this RoI
        startRoiIdx = startRoiIdxArray(iRoi);
        stopRoiIdx  = stopRoiIdxArray(iRoi);
        roiIdx      = startRoiIdx : stopRoiIdx;

        % Find relative index of exact start, look for peak in sqrt(avg future values/avg past 
        % values)    
        if length(roiIdx) >= 10,
            [~, startRelIdx] = findpeaks(stdRatioSignal(roiIdx), 'npeaks', 1, 'sortstr', 'descend');    
        else
            if stdRatioSignal(stopRoiIdx) > stdRatioSignal(startRoiIdx)
                startRelIdx = 1;
            else
                startRelIdx = 0;
            end    
        end

        % Store absolute index of exact start
        preciseStartIdxArray(iRoi) = startRoiIdx + startRelIdx - 1;

    end

end % Subfunction - PANDAS_detecte_precise_start_idx



function [degagementStartIdxArray, chuteStartIdxArray] = ...
                                     PANDAS_remove_middle_pulse(preciseStartIdxArray, distThreshold)
% PANDAS_REMOVE_MIDDLE_PULSE	Detect and remove potential middle pulse between the "d�gagement" 
% pulse and the "chute" pulse. This algorithm works only if first pulse of the signal is a
% "d�gagement" pulse.
%
% Inputs : 
% - preciseStartIdxArray    [int 1xm] Array containing all start indexe detected in each RoI.
% - distThreshold           [int 1x1] Threshold distance to remove undesired potential intermediate 
%                           pulse.
%
% Outputs :
% - degagementStartIdxArray     [int 1xm] Array containing all "degagement" first indexes
% - chuteStartIdxArray          [int 1xm] Array containing all "chute" first indexes


    %% Remove "UFO" pulse
    
    % Detect "UFO" pulse
    % Detection is based on distance between two consecutive pulses. If mean of left and right 
    % distance is smaller than a given threshold, then consider this pulse as an "UFO" pulse and 
    % discard it.
    distBetweenPreciseStartArray = preciseStartIdxArray(2:end) - preciseStartIdxArray(1:end-1);
    leftDistArray   = distBetweenPreciseStartArray(1:end-1);
    rightDistArray  = distBetweenPreciseStartArray(2:end);
    meanDistArray   = mean([leftDistArray; rightDistArray]);
    pulseToRemoveId = find(meanDistArray < distThreshold) + 1;
    
    % Remove "UFO" pulse
    preciseStartIdxCleanedArray = preciseStartIdxArray;
    preciseStartIdxCleanedArray(pulseToRemoveId) = [];
    
        
    %% Split results in two variables
    
    degagementStartIdxArray = preciseStartIdxCleanedArray(1:2:end);
    chuteStartIdxArray      = preciseStartIdxCleanedArray(2:2:end);
    

end % Subfunction - PANDAS_remove_middle_pulse

% eof
