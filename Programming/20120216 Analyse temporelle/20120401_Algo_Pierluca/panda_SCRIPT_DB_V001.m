% Application algo Panda sur BdD
% 2012.04.03 - 2012.04.

%% Init script
close all; clear all; clc;
addpath('./Lib/');
fullscreen = get(0,'ScreenSize');
% diary('./Output/globalView.txt');


%% Script param

%%% Database root path
databasePath = '../../../Base_de_donnees/20111100_Witschi_DB1/';

%%% Signal sample size to evaluate movement frequency.
sampleSize   = 5; % sec.

%%% Output flag
plotFlag = true;
dispFlag = true;


%% Loop to iterate through all files of the entire database.
[~, folderName] = extract_folder_inventory(databasePath);

regQuery = 'P01|P03|P04|P05|P06|P07|P08|P09';
regAnswer = regexp(folderName, regQuery, 'match');
folderName = [regAnswer{:}];
nFolder = length(folderName);

tic;
hWaitbar = waitbar(0/(nFolder+1), sprintf('Please wait. Processing folder 1/%d...', nFolder));
% for iFolder = 1 : nFolder,
for iFolder = 1,
   
    iFolderName = folderName{iFolder};
    [~, fileName] = extract_folder_inventory([databasePath, iFolderName, '/V1.2/']);
    %regQuery = 'E00';
    regQuery = 'P[0-9]{2}+_M[0-9]{2}+_E[0-9]{2}_N[0-9]{2}+_T[0-9]{4}+_V1.mat';
    regAnswer = regexp(fileName, regQuery, 'match');
    fileName = [regAnswer{:}];
    nFile = length(fileName);      
    
    
    
    %%% Figure 1
    if plotFlag == true,
        hFig = figure('Name',  iFolderName, ...
                      'Position',[0 0 fullscreen(3) fullscreen(4)], ...
                      'color', 'white', ...
                      'Visible', 'off');
        nLine = 6;
        nCol  = 2;
    end
    
    if dispFlag == true,
        fprintf('\n%s :\n----------------------\n', iFolderName);
    end
    
    waitbarPos = get(hWaitbar, 'position');
    hWaitbar2 = waitbar(0/(nFile+1), sprintf('Please wait. Processing file 1/%d...', nFile), 'position', waitbarPos + [0, - 2*waitbarPos(4), 0, 0]);
    for iFile = 1 : min(nFile, nLine*nCol),
%     for iFile = 9:10,

        %% Load signal
        matObj = matfile([databasePath, iFolderName, '/V1.2/', fileName{iFile}]);
        fs     = matObj.fs;
        signal = matObj.signalPzt(1, 1:sampleSize*fs);
        signal = signal ./ max(signal); % Normalisation du signal
        
        energy = signal.^2;


        %% Panda ------------------------------------------------------------------------------------

        %% initialization
        abssig = abs(signal);

        % compute energy histogram, so we know what's useless
        [n,x] = hist(energy,512);
        n = n./sum(n);

        % 99% of the signal is basically useless, high energy is very limited
        thresh = x(1);
        i = 1;
        while sum(n(1:i)) < 0.99
            i = i+1;
            thresh = x(i);
        end
        % original magical constant ->
        roi_lower_bound = 0.01;
        % computed value, almost as good, but not quite ->
        % roi_lower_bound = thresh

        % initialize moving average
        width = 20;

        %%% DO TWO MOVING AVERAGES

        %%% blocks in the past -> accu
        %%% blocks in the future -> diff
        %%% ... may god forgive me for such variable names

        %%% diff is used to identify ROIs

        %%% sqrt(diff/accu) is used to identify maximal change, that is, the start
        %%% such values are contained in ratio_vec

        % contains past average
        accu = sum(abssig(1:width))/width;
        accu_vec = zeros(size(abssig));

        % contains future average
        diff = sum(abssig(width+(1:width)))/width;
        diff_vec = zeros(size(abssig));

        % approximate regions-of-interest vector
        roi = zeros(size(abssig));

        % identify regions of interest & starting points
        for i=(width+1):(length(abssig)-width),

            % is area not-boring? (moving average is above noise level)
            % magic value based on histogram, most values are <0.005, 3x for margin
            % can be generated automagically, but I couldn't be bothered to do it
            if diff > roi_lower_bound,
                roi(i-20) = 1;
            end

            diff = diff + (abssig(i+width)-abssig(i))/width;
            diff_vec(i) = diff;
            accu = accu + (abssig(i)-abssig(i-width))/width;
            accu_vec(i) = accu;
        end

        ratio_vec = sqrt(diff_vec./accu_vec);

        % dilate roi, if you fancy, I don't
        % width = 20;
        % dil_roi = roi;
        % accu = sum(roi(1:width));
        % for i=(width+1):(length(abssig)-1)
        %     if accu > 0
        %         dil_roi(i) = 1;
        %     end
        %     accu = accu + (roi(i+1)-roi(i-width));
        % end
        % roi = dil_roi;

        %% find each roi and operate on it

        % "here's da peak" vector
        peaks = zeros(size(abssig));

        % "hey, it starts here!" vector
        start = zeros(size(abssig));

        i = 1;
        roi_count = 0;
        while i < length(roi),

            % found a roi
            if roi(i)==1,

                roi_count = roi_count + 1;

                % identify start & end
                start_idx = i;
                while roi(i) == 1,
                    end_idx = i;
                    i=i+1;
                end

                %%%% HACK TO SKIP "WRONG" ROI PROBLEM
                if (end_idx - start_idx) < 200, % they're small, that's convenient
                    roi_count = roi_count -1 ;
                    roi(start_idx:end_idx) = zeros(1,end_idx-start_idx+1);
                    continue;
                end
                %%%%

                % find exact start, look for peak in sqrt(avg future values/avg past values)
                [~,start_loc]=findpeaks(ratio_vec(start_idx:end_idx),'npeaks',1,'sortstr','descend');

                % set start on signal (bingo!)
                start(start_loc+start_idx) = 1;

                % find peaks, write it yourself if you bother... and I'm sure you do :-)
                [val,loc]=findpeaks(energy(start_idx:end_idx),'npeaks',1,'sortstr','descend');

                % set peaks on signal
                peaks(loc+start_idx) = 1;

                % echo our success !
                display(['Roi #' num2str(roi_count) ' starting at idx: ' num2str(start_loc+start_idx) ' has peak of ' num2str(val) ' at idx: ' num2str(loc+start_idx)]);
            else
                i=i+1;
            end
        end

        %% Panda ------------------------------------------------------------------------------------

        %% Disp
%         if dispFlag == true,
%             fprintf('Mvt #%2.0d @ %2.0f alt/s = %4.0f éch. (sigma_max = %5.0f éch.; var. = %5.2f%%) \n', iFile, fs/tm, tm, tv, tv/tm*100);
%         end


        %% Plot
        if plotFlag,

           % plot everything
            figure,
            hold on;
            plot(signal,'b');
            plot(start,'g');
            plot(-0.5.*roi,'r');
            plot(peaks,'k');
%             plot(diff_vec,'c');
%             plot(accu_vec,'y');
        end
        
        pause();
        
    %%% Update waitbar
    waitbar(iFile/(nFile+1), hWaitbar2, sprintf('Please wait. Processing file %d/%d...', iFile, nFile));    
    end
    close(hWaitbar2);
    
    
    %% Save plots
%     set(hFig, 'visible', 'on');
%     saveas(hFig, ['./Output/mvt_freq_detection_P0', iFolderName, '.fig'],  'fig');
%     saveas(hFig, ['./Output/mvt_freq_detection_P0', iFolderName, '.tiff'], 'tiffn');
%     close(hFig);
    
    
%%% Update waitbar    
waitbar(iFolder/(nFolder+1), hWaitbar, sprintf('Please wait. Processing folder %d/%d...', iFolder, nFolder));
end
close(hWaitbar);

%%%
t = toc;
m = floor(t/60);
s = floor(t-m*60);
fprintf('Script executed in %d min %d sec.\n', m, s);



%% Close script
% diary off;
rmpath('./Lib/');

% eof