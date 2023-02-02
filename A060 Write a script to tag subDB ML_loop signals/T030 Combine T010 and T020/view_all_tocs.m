% This script cycle through all 'ML156-*' files present in a given folder, extracts starting index
% of the unlocking event of each toc and plot each toc in a zoom.

% Author : Pitch
% Date   : 2013.05.28 - 2013.05.30



%% Clean Matlab environment

close all;
clear all;
clc;

addpath('.\lib\');



%% Script parameters

%%% Path
PROJECTROOTPATH     = '.\\Ongoing\Sherlock Holmes ABP011\';
DATABASEPATH        = [PROJECTROOTPATH, 'Data\Database\ML\subDB ML_loop\'];

STARTNAMESTR        = 'ML156-';

%%% Non standard axes borders definition
MAIN_AXE_POSITION           = [0.025, 0.037, 0.97, 0.94];   % [Left, Bottom, Width, Heigh] Norm.

%%% Zoom axes parameters
ZOOM_AXE_RELATIVE_POSITION  = [0.04,  0.15,  0.95, 0.76];   % [Left, Bottom, Width, Heigh] Norm.
Y_LIM                       = [-0.01, 6];                   % [min, max] norm (max value : 1)

%%% Global variables
N_TOCS_PER_SIGNAL           = 10;           % tocs/signal
MVT_FREQ                    = 5;            % alt/s

%%% Pandas script paramters
PANDAS_WIN_SIZE             = 41;           % Samples
PANDAS_STD_THRESHOLD        = 15;           % - (ratio)
PANDAS_DIST_THRESHOLD       = 1600;         % Samples

%%%
TOC_START_DELAY             =  0.5e-3;      % s
TOC_DURATION                = 22e-3;        % s



%% Extract signal file full names and full path

%%% Extract folder elements
dirStruct           = dir(DATABASEPATH);
dirElemNameArray    = {dirStruct(:).name}';
nDirElem            = length(dirElemNameArray);

%%% Filtered signal file names from other files
idx                 = cellfun(@(x)( ~isempty(x) ), regexp(dirElemNameArray, STARTNAMESTR));
fileFNamesArray     = dirElemNameArray(idx);
nFiles              = length(fileFNamesArray);

%%% Build signal file full path
databasePathCArray  = repmat({DATABASEPATH}, nFiles, 1);
fileFPathArray      = strcat(databasePathCArray(:), fileFNamesArray(:));



%% For loop to cycle through all signal files

for iFile = 1 : nFiles,

    
    
    %% Some simple proprocessings
    fileFName           = fileFNamesArray{iFile};
    fileName            = fileFName( 1 : (strfind(fileFName, '.')-1) );



    %% Load signal

    fileFPath           = fileFPathArray{iFile};
    matObj              = matfile(fileFPath);
    fs                  = matObj.fs;
    signal              = matObj.signal;

    %%% Extract some useful properties
    signalLength        = length(signal);
    tAxis               = 1:signalLength;



    %% Create a full screen figure in right monitor with minimum borders

    %%% Extract screen size
    screenPosition      = get(0, 'ScreenSize'); % pxl
    screenSize          = screenPosition(3:4);  % pxl
    dblScreenSize       = screenSize .* [2, 1]; % Hypothesis : same size double screens (pxl)

    %%% Compute figure position
    figureLocation      = [dblScreenSize(1)/2, 0];
    figureSize          = screenSize;

    %%% Build figure object
    hFig                = figure(   'OuterPosition',    [figureLocation, figureSize], ...
                                    'Color',            'white', ...
                                    'Name',             fileFName);

    %%% Build main axes object
    hAx                 = axes(     'Units',            'normalized', ...
                                    'Position',         MAIN_AXE_POSITION); %#ok<LAXES>
    hold on;

    %%% Compute zoom axe position
    zoomAxeLocation     = figureSize .* ZOOM_AXE_RELATIVE_POSITION(1:2);
    zoomAxeSize         = figureSize .* ZOOM_AXE_RELATIVE_POSITION(3:4);
    zoomAxePosition     = [zoomAxeLocation, zoomAxeSize];

    
    
    %% Plot signal

    %%% Plot this toc
    signal = abs(signal);
    plot(tAxis, signal);

    %%% Change plot properties
    axis tight;
    ylim(Y_LIM);

    %%% Plot label
    xlabel('Time [Samples]');
    ylabel('Normalized magnitude [V]');
    
    
    
    %% Extract unlocking start, plot them on signal and if not adapted, change the value online to 
    %  adapt. When values are correct, save them and quit.
    
    % Init while loop
    pandasWinSize           = PANDAS_WIN_SIZE;
    pandasStdThreshold      = PANDAS_STD_THRESHOLD;
	pandasDistThreshold     = PANDAS_DIST_THRESHOLD;
    unlockingStartIdxArray  = 0;
    tocLength               = TOC_DURATION*fs;
    
    while true,
        
        %%% Locate the starting index of each unlocking
        unlockingStartIdxArray = SHH_pandas(signal, pandasWinSize, pandasStdThreshold, ...
                                            pandasDistThreshold);

        %%% Plot detected unlocking start index
        hUnlockingPlot = plot(unlockingStartIdxArray, signal(unlockingStartIdxArray), '*r');
        
        %%% Plot toc estimate length
        tocLengthX  = unlockingStartIdxArray + tocLength;
        tocLengthY  = max(abs(signal)) * 0.5 * ones(1, length(tocLengthX));
        hLengthPlot = stem(tocLengthX, tocLengthY);
        set(hLengthPlot, 'Color', 'red', 'MarkerFaceColor', 'red', 'Marker', 'square')
        
        %%% User interface
        dispStr1    = 'Are unlocking start index wright ? [y, [winSize stdThresh distThresh tocDuration]]\n';
        dispStr2    = 'Default value : %d S - %d S - %d S - %2.0f ms\n Input : ';
        dispStr     = sprintf([dispStr1, dispStr2], PANDAS_WIN_SIZE, PANDAS_STD_THRESHOLD, ...
                                                    PANDAS_DIST_THRESHOLD, TOC_DURATION*1e3);
        inStr       = input(dispStr, 's');
        splitStr    = regexp(inStr, ' ', 'split');
        nUserInputs = length(splitStr);
        
        %%% Depending of the user input accept those unlocking start index or recompute them with
        %   some new values.
        if nUserInputs == 4,
            pandasWinSize       = str2double(splitStr{1});
            pandasStdThreshold  = str2double(splitStr{2});
            pandasDistThreshold = str2double(splitStr{3});
            tocLength           = str2double(splitStr{4})/1e3*fs;
            delete(hUnlockingPlot);
            delete(hLengthPlot);
        elseif nUserInputs == 1 && ( strcmp(splitStr{1}, 'y') || isempty(splitStr{1}) ),
            delete(hLengthPlot);
            break;
        else
            str = '"%s" is an unknown input.\n';
            fprintf(str, inStr);
        end
        
    end

    

    %% For loop to display each toc

    lastIndexToPlot = 0;
    % for iToc = 1 : 1,
    for iToc = 1 : N_TOCS_PER_SIGNAL,



        %% Display title on main axes

        str = sprintf('%s - Toc %d', fileName, iToc);
        title(str, 'interpreter', 'none');



        %% Extract this toc signal

        %%% Estimate toc start (i.e.: some samples before unlocking start index)
        unlockingStartIdx       = unlockingStartIdxArray(iToc);
        tocStartDelay           = TOC_START_DELAY*fs;
        tocStartIdx             = max( unlockingStartIdxArray(iToc) - tocStartDelay, 1 );

        %%% Estimate toc end
        tocDuration             = tocLength*fs;
        tocEndIdx               = min( tocStartIdx + tocLength, signalLength );

        %%% Extract portion of signal containing this toc
        signalToPlot            = signal(tocStartIdx:tocEndIdx);



        %% Plot this toc on zoom axes

        %%% Get various axes properties
        set(gca, 'units', 'pixels');
        pos         = get(gca, 'position');
        xLim        = get(gca, 'xlim');
        yLim        = get(gca, 'ylim');

        %%% Compute toc x position in pixel
        xInAxes     = tAxis(tocStartIdx);
        xInPixels   = pos(1) + pos(3) * (xInAxes-xLim(1))/(xLim(2)-xLim(1))-1;

        %%% Compute wen width to see all toc impulses
        largPxl     = pos(3) * (tocLength-xLim(1))/(xLim(2)-xLim(1));

        %%% Compute wen height to see all toc impulses
        maxi        = max( signal( tocStartIdx + (0:tocLength) ) );
        maxiPxl     = pos(4) * (maxi-yLim(1)) / (yLim(2)-yLim(1)) + 5; % 5 = offset to see boundaries

        %%% Build and plot wen and zoom axes
        [h1, h2]    = magnify_on_figure(gcf, ...
                                        'units',                        'pixels', ...
                                        'initialPositionSecondaryAxes', zoomAxePosition, ...
                                        'initialPositionMagnifier',     [xInPixels, 0, largPxl, maxiPxl/2], ...
                                        'mode',                         'manual', ...
                                        'displayLinkStyle',             'none', ...
                                        'edgeColor',                    'red', ...
                                        'secondaryAxesFaceColor',       [91, 91, 91]/100); % Soft grey 



        %% Display toc main information and pause script to allow user to tag displayed toc.
        
        dispStr     = 'Toc #%d : unlockingStartIdx = %d (%3.1f ms)  -- tocLength = %d S (%2.1f ms)';
        str         = sprintf(dispStr, iToc, unlockingStartIdx, unlockingStartIdx/fs*1e3, ...
                                       tocLength, tocDuration*1e3);
        disp(str)
        
        while true,
            inStr = input('', 's');
            if isempty(inStr),
                break;
            end
        end

        

        %% Delete zoom and wen

        delete(h1);
        delete(h2);


    end

    close(hFig);
    
end



%% Clean Matlab environment

rmpath('.\lib\');



%%% eof
