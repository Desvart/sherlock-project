%%

clear all;
clc;
close all;


%% Param.

TIME_BASE_CORRECTION_FACTOR      = 0.99471;
PANDAS_WIN_SIZE                  = 41;
PANDAS_THRESHOLD                 = 15;
WORKSPACE_SIZE_CORRECTION_FACTOR = [18, 90]; % pxl
FIGURE_POSITION_OFFSET_FACTOR    = 9; % pxl
MAIN_AXES_POSITION               = [2.5, 3.5, 96, 96] / 100; % normalized
SIGNAL_OFFSET                    = 0.005;
Y_LIM                            = [0, 5.5];
N_TOC                            = 12;
N_TAG_PER_TOC                    = 0; % Default = 8
N_DIGIT                          = 6; % tRes = 3e.6; @ fs = 20 kS/s
ZOOM_AXE_POSITION                = [1920/12, 1920/8, 1920*0.9, 850];
TOC_WIDTH                        = 20e-3; % seconds
PROJECT_PATH                     = '.\\Ongoing\ABP011_Sherlock_Holmes\';
DATABASE_RPATH                   = 'Data\Videos\ViSo\ViSo_2_0\ML_Influence_du_barillet\';
FILE_FNAME                       = 'ML03_R00_B06_N01.mat';
START_TOC_ID                     = 1;



for iMvt = 1 : 3,
    for iBar = 1:6,

        % Load signal
        load([PROJECT_PATH, DATABASE_RPATH, 'ML0', int2str(iMvt), '_R00_B0', int2str(iBar), '_N01.mat']);
        
        % Compute signal magnitude and time axis
        signal = abs(signal);
        tAxis = (0:length(signal)-1)/fs;
        tAxis = tAxis ./ TIME_BASE_CORRECTION_FACTOR;

        % Detect d�gagement start
        degagementStartIdxArray = pandas_(signal, PANDAS_WIN_SIZE, PANDAS_THRESHOLD);

        % Compute figure position and size
        screenPosition = get(0, 'ScreenSize');
        screenSize     = screenPosition(3:4);
        workspaceSize  = screenSize - WORKSPACE_SIZE_CORRECTION_FACTOR; % pxl
        figurePosition = [screenSize(1) + FIGURE_POSITION_OFFSET_FACTOR, FIGURE_POSITION_OFFSET_FACTOR]; % pxl

        % Build figure and main axe
        hFig = figure('Position', [figurePosition, workspaceSize], ...
                      'color',    'w', ...
                      'Name',     FILE_FNAME);
        hAx  = axes('Units',      'normalized', ...
                    'Position',   MAIN_AXES_POSITION);
        hold on;

        % Plot signal
        plot(tAxis, signal + SIGNAL_OFFSET); 

        % Plot pandas detected impulse starts
        plot(tAxis(degagementStartIdxArray), signal(degagementStartIdxArray) + SIGNAL_OFFSET, '*r');

        % Adapt signal plot
        axis tight;

    end
end

% %% Init
% 
% % Load signal
% load([PROJECT_PATH, DATABASE_RPATH, FILE_FNAME]);
% 
% % Compute signal magnitude and time axis
% signal = abs(signal);
% tAxis = (0:length(signal)-1)/fs;
% tAxis = tAxis ./ TIME_BASE_CORRECTION_FACTOR;
% 
% % Detect d�gagement start
% degagementStartIdxArray = pandas_(signal, PANDAS_WIN_SIZE, PANDAS_THRESHOLD);
% 
% % Compute figure position and size
% screenPosition = get(0, 'ScreenSize');
% screenSize     = screenPosition(3:4);
% workspaceSize  = screenSize - WORKSPACE_SIZE_CORRECTION_FACTOR; % pxl
% figurePosition = [screenSize(1) + FIGURE_POSITION_OFFSET_FACTOR, FIGURE_POSITION_OFFSET_FACTOR]; % pxl
% 
% % Build figure and main axe
% hFig = figure('Position', [figurePosition, workspaceSize], ...
%               'color',    'w', ...
%               'Name',     FILE_FNAME);
% hAx  = axes('Units',      'normalized', ...
%             'Position',   MAIN_AXES_POSITION);
% hold on;
% 
% % Plot signal
% plot(tAxis, signal + SIGNAL_OFFSET); 
% 
% % Plot pandas detected impulse starts
% plot(tAxis(degagementStartIdxArray), signal(degagementStartIdxArray) + SIGNAL_OFFSET, '*r');
% 
% % Adapt signal plot
% axis tight;
% ylim(Y_LIM);
% 
% % Axis labels
% xlabel('Time [s]');
% ylabel('Magnitude [-]');
% 
% % Load data cursor object
% dcm_obj = datacursormode(gcf); 
% 
% % Start text
% fprintf('Start tagging signal ''%s''\n\n', FILE_FNAME);
% 
% 
% %%
% 
% tagArray = zeros(N_TOC, N_TAG_PER_TOC); % Prealloc
% for iToc = START_TOC_ID : N_TOC,
%     
%     set(gca,'units','pixels');
%     pos = get(gca,'position');
%     xLim = get(gca,'xlim');
%     yLim = get(gca,'ylim');
% 
%     
%     %% Zoom on selected toc
%     
%     % Compute toc x position in pixel
%     xInAxes   = (tAxis(degagementStartIdxArray(iToc)));
%     xInPixels = pos(1) + pos(3) * (xInAxes-xLim(1))/(xLim(2)-xLim(1))-1;
%     
%     % Compute wen width to see all toc impulses
%     largPxl   = pos(3) * (TOC_WIDTH-xLim(1))/(xLim(2)-xLim(1));
%     
%     % Compute wen height to see all toc impulses
%     maxi      = max(signal(degagementStartIdxArray(iToc)+(0:TOC_WIDTH*fs)));
%     maxiPxl   = pos(4) * (maxi-yLim(1)) / (yLim(2)-yLim(1)) + 5; % 5 = offset to see boundaries
% 
%     % Build and plot wen and zoom axes
%     [h1, h2] = magnifyOnFigure2(gcf, ...
%             'units',                        'pixels', ...
%             'initialPositionSecondaryAxes', ZOOM_AXE_POSITION, ...
%             'initialPositionMagnifier',     [xInPixels, 0, largPxl, maxiPxl], ...
%             'mode',                         'manual', ...
%             'displayLinkStyle',             'none', ...
%             'edgeColor',                    'red', ...
%             'secondaryAxesFaceColor',       [0.91, 0.91, 0.91]);
% 
% 
% 	%% Detect user tags
%     
%     if N_TAG_PER_TOC > 0,
%         
%         nDetectedTag = 0; % init
%         while nDetectedTag ~= N_TAG_PER_TOC,
% 
%             pause();
% 
%             % Extract data cursor position
%             info_struct = getCursorInfo(dcm_obj);
%             if ~isempty(info_struct),
%                 tagPosition = [info_struct.Position];
%                 tagXPosition = tagPosition(end-1:-2:1);
% 
%                 % If not enough or too much tag are detected, try again
%                 nDetectedTag = length(tagXPosition);
%                 if nDetectedTag ~= N_TAG_PER_TOC,
%                     fprintf('Wrong number of tags (%d detected, should be %d).\n', nDetectedTag, N_TAG_PER_TOC);
%                 end
%             end
%         end
%     
%         % Sort and save detected tags
%         tagXPosition = sort(tagXPosition)';
%         tagArray(iToc, :) = tagXPosition;
%         
%     else
%         pause();
%     end
%     
%     
%     %% Plot detected tags
%     
%     if N_TAG_PER_TOC > 0,
%         fprintf('Toc %d\t', iToc);
%         fprintf(['%1.', int2str(N_DIGIT), 'f\t'], tagArray(iToc, :));
%         fprintf('\n');
%     end
% 
%     
%    %% Delete zoom and wen
%     
%     delete(h1);
%     delete(h2);
%              
% end
% 
% 
% %% Display tagging results
% 
% if N_TAG_PER_TOC > 0,
%     
%     % Remove time base correction factor from tags
%     tagArrayWithoutCorr = tagArray .* TIME_BASE_CORRECTION_FACTOR;
% 
%     % Display results
%     fprintf('\nEnd of tagging process for file ''%s''\n', FILE_FNAME);
%     fprintf('Tags detected (original time) :\n');
%     for iToc2 = 1 : size(tagArrayWithoutCorr, 1),
%         fprintf('Toc %d\t', iToc2);
%         fprintf(['%1.', int2str(N_DIGIT), 'f\t'], tagArrayWithoutCorr(iToc2, :));
%         fprintf('%d\t', boolTag(iToc2, :));
%         fprintf('\n');
%     end
%     fprintf('End of tagging process for file ''%s''\n', FILE_FNAME);
% 
% end
% 
% % eof
