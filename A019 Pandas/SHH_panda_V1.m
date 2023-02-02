% Script : PANDAS
%
% Description : 
% Pandas algorithms is one of the developpments of Sherlock Holmes project. Main goal 
% is to precisely determine the beginning of each impulsions in a "classic" mecanical wrist watch 
% signal or mecanical wrist movement signal.
%
% Algorithm :
%   1. Determine roughly the regions of interest (RoI: start location of each impulsion) by 
%   comparing the value of a forward standard deviation and a backward one. A sample belong to a RoI
%   if the forward std is 3 times higher than the backward std. (factor 3 is empirical)
%   2. Determine the precise location of the start location of each impulsion by extracting the
%   absolute maxium of each RoI of the ratio between the backward std and the forward std.
%   3. If two consecutive starts are too close to each other, we decide to keep or not the second
%   start based on an decreasing exponential threshold. The magnitude of the exponential threshold
%   depends of the ratio curve at the first start location and the decreasing coefficient is a
%   empirically determined constant (0.05).
%
% See also SHH_get_matObj, movingstd, findpeaks
%
% Project : Sherlock Holmes - Pandas (Alpha 1)
% 2012.08.10 - 2012.08.14
%
% � 2012-2015 Pitch Corp.
%   Author : Pitch
%   with the gracious and invaluable assistance of P. Bors�.

% Note : PANDAS stands for "Precise Annotations for Non-Deterministic Annoying Signals"

% Todo :

close all;
% clear all;
clc;

% DATABASEPATH = 'd:\Work\Projects\Ongoing\ABP011 2011-201x Sherlock Holmes\Database\Sounds\20111100_ARH\ARH_DB4_2\';
SSTDWIN      = 41;   % Size of the window used for the running STD
STDCMPFACTOR = 3;    % Factor used to compare forward and backward STD
EXPDECFACTOR = 0.05; % Factor used to build the exponential decreasing threshold to eliminate too close impulsion.

% addpath(DATABASEPATH);
% matObj = SHH_get_matObj_A2([1,1], DATABASEPATH);
% signal = matObj{1}.signal;
% fs     = matObj{1}.fs;

signal = abs(signal);
lSignal = length(signal);

%%% STD
stdB = movingstd(signal, SSTDWIN, 'backward');
stdF = [stdB(SSTDWIN:end), zeros(1, SSTDWIN-1)];
% stdF2 = movingstd(signal, STDWIDTH, 'forward');

%%% Approximate RoI
roi = stdF > (STDCMPFACTOR * stdB);

stdRatio = stdF./stdB;
stdRatio(1) = 1;

%%% Plot intermediate figure;
figure; hold on; 
plot(signal(1:fs), 'k'); 
plot(stdB(1:fs), 'r'); 
plot(stdF(1:fs)); 
plot(roi(1:fs), 'g'); 
plot((stdRatio(1:fs)-1)/max(stdRatio(1:fs))+1, 'm--');
% plot(stdRatio(1:fs), 'm--');


%%% Detect border of RoI
roiBorder = roi(1:end-1) - roi(2:end);
startRoiIdx = find(roiBorder == -1) + 1;
stopRoiIdx  = find(roiBorder == +1);

startRoiIdx(startRoiIdx < SSTDWIN/2) = [];
stopRoiIdx(stopRoiIdx < SSTDWIN/2) = [];
nRoi = length(startRoiIdx);

plot(startRoiIdx(startRoiIdx<fs), roi(startRoiIdx(startRoiIdx<fs)), '*r');
plot(stopRoiIdx(stopRoiIdx<fs), roi(stopRoiIdx(stopRoiIdx<fs)), '*k');


%%%
start = zeros(1, lSignal);      % "Hey it starts here!" vector
expThreshold = zeros(1, lSignal);     % exponential decreasing threshold vector


expMagFactor = 0;

top_last = 0;

for iRoi = 1 : nRoi,
    
    if (stopRoiIdx - startRoiIdx < 2)
            if(stdRatio(stopRoiIdx) > stdRatio(startRoiIdx))
                start_loc = 1;
            else
                start_loc = 0;
            end    
    else
            % find exact start, look for peak in sqrt(avg future values/avg past values)
            [~, start_loc] = findpeaks(stdRatio(startRoiIdx:stopRoiIdx), 'npeaks', 1, ...
                                                                         'sortstr', 'descend');
    end
    
    if stdRatio(startRoiIdx+start_loc) > (expMagFactor*exp(-EXPDECFACTOR*((startRoiIdx+start_loc)-top_last)));
        
        expMagFactor = 2*stdRatio(startRoiIdx+start_loc);
        top_last = startRoiIdx+start_loc;

        % set start on signal (bingo!)
        start(top_last) = 1;
        %display(['Roi #' num2str(roi_count) ' starting at idx: ' num2str(start_loc+start_idx)]);
    end
    
end

% while i < length(roi)
for iSample = 1 : lSignal,
    
    if roi(iSample) == 1,
        
        nRoi = nRoi + 1;
        
        % identify start & end
        startRoiIdx = iSample;
        
        while roi(iSample) == 1
            stopRoiIdx = iSample;
            iSample = iSample + 1;
%             min_top(iSample) = AExp*exp(-CEXP*(iSample-top_last));
        end
 
        if (stopRoiIdx - startRoiIdx < 2),
                if(stdRatio(stopRoiIdx) > stdRatio(startRoiIdx)),
                    start_loc = 1;
                else
                    start_loc = 0;
                end    
        else
                % find exact start, look for peak in sqrt(avg future values/avg past values)
                [~, start_loc] = findpeaks(stdRatio(startRoiIdx:stopRoiIdx), 'npeaks', 1, ...
                                                                             'sortstr', 'descend');
        end
        
        if ratio_vec(startRoiIdx+start_loc) > (expMagFactor*exp(-EXPDECFACTOR*((startRoiIdx+start_loc)-top_last)));
        
            expMagFactor = 2*ratio_vec(startRoiIdx+start_loc);
            top_last = startRoiIdx+start_loc;
            
            % set start on signal (bingo!)
            start(top_last) = 1;
            %display(['Roi #' num2str(roi_count) ' starting at idx: ' num2str(start_loc+start_idx)]);
        end
    else
        iSample=iSample+1;
        min_top(iSample) = expMagFactor * exp(-EXPDECFACTOR*(iSample-top_last));
    end
end

% plot everything
figure;
hold on;
plot(signal,'b');
plot(-0.5.*start,'r');
plot(0.5*roi,'k');
plot(0.01*ratio_vec+0.1,'c');
plot(0.01*min_top+0.1,'g');







rmpath(DATABASEPATH);

%eof
