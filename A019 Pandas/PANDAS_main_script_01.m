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
STD_WIN_SIZE               = 41;   % Size of the window used for the running STD 41
STD_RATIO_SIGNAL_THRESHOLD = 20;    % Factor used to compare forward and backward STD (3 is an empirical value)
EXP_DEC_FACTOR             = 0.05; % Factor used to build the exponential decreasing threshold to eliminate too close impulsion.

% addpath(DATABASEPATH);
% matObj = SHH_get_matObj_A2([1,1], DATABASEPATH);
% signal = matObj{1}.signal;
% fs     = matObj{1}.fs;

signal = abs(signal);
nSamples = length(signal);
    
    
    

%% Determine, roughly, regions of interest (RoI)

[startRoiIdxArray, stopRoiIdxArray, nRoi, stdRatioSignal, stdBackward, stdForward, roi] = ...
                             PANDAS_determine_roi(signal, STD_WIN_SIZE, STD_RATIO_SIGNAL_THRESHOLD);


%%% Plot intermediate figure;
    figure; hold on; 
    plot(signal(1:fs), 'k'); 
    plot(stdBackward(1:fs), 'r'); 
    plot(stdForward(1:fs)); 
    plot(roi(1:fs), 'g'); 
    plot((stdRatioSignal(1:fs)-1)/max(stdRatioSignal(1:fs))+1, 'm--');
    
    line([0, nSamples], STD_RATIO_SIGNAL_THRESHOLD/max(stdRatioSignal(1:fs))*[1, 1]+1, 'color', 'k')
    
    plot(startRoiIdxArray(startRoiIdxArray<fs), roi(startRoiIdxArray(startRoiIdxArray<fs)), '*r');
    plot(stopRoiIdxArray(stopRoiIdxArray<fs), roi(stopRoiIdxArray(stopRoiIdxArray<fs)), '*k');

%%%
start = zeros(1, nSamples);      % "Hey it starts here!" vector
startIdxArray = zeros(1, nRoi);
expThreshold = zeros(1, nSamples);     % exponential decreasing threshold vector


expMagFactor = 0;

top_last = 0;

for iRoi = 1 : nRoi,
    
    startRoiIdx = startRoiIdxArray(iRoi);
    stopRoiIdx  = stopRoiIdxArray(iRoi);
    roiIdx      = startRoiIdx : stopRoiIdx;
    
    % Find relative index of exact start, look for peak in sqrt(avg future values/avg past values)    
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
    startIdxArray(iRoi) = startRoiIdx + startRelIdx - 1;
    
end





for iStart = 1 : nRoi,
    if startIdxArray(iStart) < fs,
        line(startIdxArray(iStart)*[1, 1], [0 1]);
    end
end



%%% M�thode toute bizarre pour obtenir les d�buts de chaque toc, afin de pouvoir d�terminer le
%%% niveau de bruit (avant le 1er d�but) et la fin du signal (selon le niveau de SNR).
%%% Ensuite analyse toc par toc.

a = startIdxArray(2:end)-startIdxArray(1:end-1);
a(a<max(a)/2) = 0;
roi = a > 0;
figure; plot(signal); hold on; 
plot(startIdxArray([true,roi(1:end-1)]), signal(startIdxArray([true,roi(1:end-1)])), '*r'); 
plot(startIdxArray, 0.1*ones(1, length(startIdxArray)), '*g');






%     if iRoi >1,
%         expAxis = startRoiIdxArray(iRoi-1)+startRelIdx : startRoiIdxArray(iRoi);
%         expAmpl = expMagFactor .* exp(-EXP_DEC_FACTOR*(expAxis-(startRoiIdxArray(iRoi-1)+startRelIdx))) / max(stdRatioSignal(1:fs)) + 1;
%         plot(expAxis, expAmpl, 'c');
%     end
%     
%     if stdRatioSignal(startRoiIdx+startRelIdx) > (expMagFactor*exp(-EXPDECFACTOR*((startRoiIdx+startRelIdx)-top_last)));
%         
%         expMagFactor = 2*stdRatioSignal(startRoiIdx+startRelIdx);
%         top_last = startRoiIdx+startRelIdx;
% 
%         % set start on signal (bingo!)
%         start(top_last) = 1;
%         %display(['Roi #' num2str(roi_count) ' starting at idx: ' num2str(start_loc+start_idx)]);
%     end
% 
% 
% 
% 
% 
% % while i < length(roi)
% for iSample = 1 : nSamples,
%     
%     if roi(iSample) == 1,
%         
%         nRoi = nRoi + 1;
%         
%         % identify start & end
%         startRoiIdx = iSample;
%         
%         while roi(iSample) == 1
%             stopRoiIdx = iSample;
%             iSample = iSample + 1;
% %             min_top(iSample) = AExp*exp(-CEXP*(iSample-top_last));
%         end
%  
%         if (stopRoiIdx - startRoiIdx < 2)
%                 if(stdRatioSignal(stopRoiIdx) > stdRatioSignal(startRoiIdx))
%                     startRelIdx = 1;
%                 else
%                     startRelIdx = 0;
%                 end    
%         else
%                 % find exact start, look for peak in sqrt(avg future values/avg past values)
%                 [~, startRelIdx] = findpeaks(stdRatioSignal(startRoiIdx:stopRoiIdx), 'npeaks', 1, ...
%                                                                              'sortstr', 'descend');
%         end
%         
%         if ratio_vec(startRoiIdx+startRelIdx) > (expMagFactor*exp(-EXPDECFACTOR*((startRoiIdx+startRelIdx)-top_last)));
%         
%             expMagFactor = 2*ratio_vec(startRoiIdx+startRelIdx);
%             top_last = startRoiIdx+startRelIdx;
%             
%             % set start on signal (bingo!)
%             start(top_last) = 1;
%             %display(['Roi #' num2str(roi_count) ' starting at idx: ' num2str(start_loc+start_idx)]);
%         end
%     else
%         iSample=iSample+1;
%         min_top(iSample) = expMagFactor * exp(-EXPDECFACTOR*(iSample-top_last));
%     end
% end
% 
% % plot everything
% figure,
% hold on;
% plot(signal,'b');
% plot(-0.5.*start,'r');
% plot(0.5*roi,'k');
% plot(0.01*ratio_vec+0.1,'c');
% plot(0.01*min_top+0.1,'g');
% 
% 
% 
% 
% 
% 
% 
% rmpath(DATABASEPATH);
% 
% %eof
a = get(0, 'ScreenSize');
signal = abs(signal);
SCREENSIZE    = [1920, 1200]; DOUBLESCREEN  = true; % WUXGA    
workspaceSize = SCREENSIZE - [65, 38]; % pxl
figurePosition = [SCREENSIZE(1) + 9, 9];
figure('Position',       [figurePosition, workspaceSize]);

plot(signal); hold on;
plot(d, signal(d), '*r');
iToc = 1;

for iToc = 1 : 12,
    set(gca,'units','pixels');
    pos = get(gca,'position');
    xlim = get(gca,'xlim');
    ylim = get(gca,'ylim');

    a = get(gcf,'position');
    x_in_axes = d(iToc);
    x_in_pixels = pos(1) + pos(3) * (x_in_axes-xlim(1))/(xlim(2)-xlim(1));

    [h1, h2] = magnifyOnFigure2(gcf, ...
            'units',                        'pixels', ...
            'initialPositionSecondaryAxes', [1600/5, 1600/3, 1600*0.8, 200], ...
            'initialPositionMagnifier',     [x_in_pixels, 1, 20, 100], ...
            'mode',                         'interactive', ...
            'displayLinkStyle',             'none', ...
            'edgeColor',                    'red', ...
            'secondaryAxesFaceColor',       [0.91, 0.91, 0.91]);
        
    pause();
    
    delete(h1);
    delete(h2);
             
end
        
        
        
        
        
        
