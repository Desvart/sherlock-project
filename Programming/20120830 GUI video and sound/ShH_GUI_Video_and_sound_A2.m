function ShS_GUI_Video_and_sound()
%
%
%
%

% Project   : Sherlock Holmes - GUI ViSo
% File vers.: Alpha 1 (2012.08.30)
%
% � 2012-2015 Pitch Corp.
%   Author :  Pitch

% Note : 
% - 

% Todo : 
% - 

% Log :
% A1 2012.08.30 - 2012.09.??
%   - Create function


    %% Clear workspace
    
    close all; clc;

    
    
    %% Define internal variables
    
%     screen_size = get(0, 'ScreenSize');

%     DEFAULTPATH   = '.\Database_ShH\Videos\ViSo\Temp_database\';
%     SCREENSIZE    = [1920, 1080]; DOUBLESCREEN  = false; % Full HD

    DEFAULTPATH   = '.\Temporary\Temp_database_2\';
    SCREENSIZE    = [1920, 1200]; DOUBLESCREEN  = true; % WUXGA
    
    workspaceSize = SCREENSIZE - [65, 38]; % pxl
    MARGIN        = 5; % pxl
    
    
    
    %% Create main figure
    
    iWidget = 0;
    
    if DOUBLESCREEN == true,
        figurePosition = [SCREENSIZE(1) + 9, 9];
    else
        figurePosition = [9, 9];
    end
    
    figure('Position',       [figurePosition, workspaceSize], ...
           'DockControls',   'off', ...
           'DoubleBuffer',   'on', ...
           'Name',           'Sherlock Homles - ViSo GUI (Video & Sound GUI)', ...
           'Color',          'white', ...
           'KeyPressFcn',    {@stepKey_callback}, ...
           'DeleteFcn',      {@close_figure_callback}, ...
           'CloseRequestFcn',{@close_figure_callback}, ...
           'Visible',        'off');
 
%                          'MenuBar',        'none', ...
              
	%% Add widgets
    
    %%% Load button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = MARGIN;
    widget(iWidget).y = MARGIN;
    widget(iWidget).w = 50;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   'Load', ...
              'Position', widgetPosition, ...
              'Callback', {@loadButton_callback});

    %%% Path field (editable)
	iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = MARGIN;
    widget(iWidget).w = 750;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hPathField = uicontrol('Style',    'edit', ...
                           'String',   DEFAULTPATH, ...
                           'Tag',      'pathField', ...
                           'Position', widgetPosition);

	%%% Search button to load folder path (open a search window)
	iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = MARGIN;
    widget(iWidget).w = 50;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   '...', ...
              'Position', widgetPosition, ...
              'Callback', {@searchButton_callback});

 	%%% Information field : information about video and sound files (size, fps, etc.)
	iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = MARGIN;
    widget(iWidget).w = workspaceSize(1)-widget(iWidget).x - MARGIN;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'text', ...
              'String',   'Info', ...
              'Tag',      'infoField', ...
              'Position', widgetPosition);
                      
	%%% Video display area
    iWidget = iWidget + 1;

    widget(iWidget).x = MARGIN;
    widget(iWidget).y = widget(iWidget-1).y + widget(iWidget-1).h + MARGIN;
    widget(iWidget).w = workspaceSize(1) - MARGIN*2;
    widget(iWidget).h = workspaceSize(2) - widget(iWidget).y - MARGIN - 400;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    axes('Units',    'Pixels', ...
         'Tag',      'viAxe', ...
         'YDir',     'reverse', ...
         'NextPlot', 'replacechildren', ...
         'Position', widgetPosition);
                      
	%%% Play/Pause button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = MARGIN;
    widget(iWidget).y = widget(iWidget-1).y + widget(iWidget-1).h + 5*MARGIN;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition     = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2)  = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   'P', ...
              'Position', widgetPosition, ...
              'Callback', {@playButton_callback});

	%%% Stop button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = widget(iWidget-1).y;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition     = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2)  = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   'S', ...
              'Position', widgetPosition, ...
              'Callback', {@stopButton_callback});
                      
	%%% Backward button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = MARGIN;
    widget(iWidget).y = widget(iWidget-2).y + widget(iWidget-2).h + MARGIN;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   '-', ...
              'Position', widgetPosition, ...
              'Callback', {@stepButton_callback, '-'});
                      
	%%% Forward button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = widget(iWidget-1).y;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   '+', ...
              'Position', widgetPosition, ...
              'Callback', {@stepButton_callback, '+'});
          
	%%% Zoom button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = MARGIN;
    widget(iWidget).y = widget(iWidget-2).y + widget(iWidget-2).h + MARGIN;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   'Z', ...
              'Position', widgetPosition, ...
              'Callback', {@zoomButton_callback});
          
	%%% Reset button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = widget(iWidget-1).y;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    uicontrol('Style',    'pushbutton', ...
              'String',   'R', ...
              'Position', widgetPosition, ...
              'Callback', {@resetButton_callback});
                      
	%%% Sound plot area
    iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + 5*MARGIN;
    widget(iWidget).y = widget(iWidget-5).y;
    widget(iWidget).w = workspaceSize(1) - widget(iWidget).x - MARGIN;
    widget(iWidget).h = 400 - 10*MARGIN;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    axes('Units',         'Pixels', ...
         'Tag',           'soAxe', ...
         'NextPlot',      'replaceChildren', ...
         'ButtonDownFcn', {@setCursor_callback}, ...
         'Position',      widgetPosition);
    
    
    
    %% Init GUI
    
%     folderPath = 'D:\Work\Projects\Ongoing\ABP011 2011-201x Sherlock Holmes\Data\Videos\20120900 Tag ViSo\ViSo 1.0\ML01_R00_N01\';
    folderPath = 'E:\Database_ShH\Videos\ViSo\Temp_database\';
    set(hPathField, 'String', folderPath);
    
    if ~exist('folderPath', 'var'),
        folderPath = get(hPathField, 'String');
        if ~isdir(folderPath),
            folderPath = uigetdir('./', 'Select a data set folder to work on...');
            set(hPathField, 'String', [folderPath, '\']);
        end
    end
    
    init_gui_A2();
    
    
    
    %% Make the GUI visible.
    
    set(gcf, 'Visible', 'on');
    
end 
% eof
