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
    
    close all;

    
    
    %% Define internal variables
    
%     screen_size = get(0, 'ScreenSize');
    SCREENSIZE    = [1920, 1200]; % WUXGA
%     SCREENSIZE    = [1920, 1080]; % Full HD
    DOUBLESCREEN  = true;
%     DEFAULTPATH   = '.\ABP011 2011-201x Sherlock Holmes\Database\Videos\20120900_ARH_nv_horizon\P01_M01_R01';
    DEFAULTPATH   = '.\ABP011 2011-201x Sherlock Holmes\Database\Videos\20120900_ARH_nv_horizon\P01_M01_R01';
    workspaceSize = SCREENSIZE - [65, 38]; % pxl
    MARGIN        = 5; % pxl
    
    
    
    %% Create main figure
    
    iWidget = 0;
    
    if DOUBLESCREEN == true,
        figurePosition = [SCREENSIZE(1) + 9, 9];
    else
        figurePosition = [9, 9];
    end
    hFig = figure('Position',       [figurePosition, workspaceSize], ...
                  'DockControls',   'off', ...
                  'MenuBar',        'none', ...
                  'Name',           'Sherlock Homles - ViSo GUI (Video & Sound GUI)', ...
                  'DeleteFcn',      @close_figure, ...
                  'Visible',        'off');
 
              
              
	%% Add widgets
    
    %%% Load button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = MARGIN;
    widget(iWidget).y = MARGIN;
    widget(iWidget).w = 50;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hLoad             = uicontrol('Style',    'pushbutton', ...
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
    hPath             = uicontrol('Style',    'edit', ...
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
    hSearch           = uicontrol('Style',    'pushbutton', ...
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
    hInfo             = uicontrol('Style',    'text', ...
                                  'String',   'Info', ...
                                  'Tag',      'infoField', ...
                                  'Position', widgetPosition);
                      
	%%% Video display area
    iWidget = iWidget + 1;

    widget(iWidget).x = MARGIN;
    widget(iWidget).y = widget(iWidget-1).y + widget(iWidget-1).h + MARGIN;
    widget(iWidget).w = workspaceSize(1) - MARGIN*2;
    widget(iWidget).h = workspaceSize(2) - widget(iWidget).y - MARGIN - 200;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hVi               = axes('Units',    'Pixels', ...
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
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hPlay             = uicontrol('Style',    'pushbutton', ...
                                  'String',   'P', ...
                                  'Position', widgetPosition, ...
                                  'Callback', {@playButton_callback});
                      
	%%% Zoom button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = widget(iWidget-1).y;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hZoom             = uicontrol('Style',    'pushbutton', ...
                                  'String',   'Z', ...
                                  'Position', widgetPosition, ...
                                  'Callback', {@zoomButton_callback});
                      
	%%% Backward button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = MARGIN;
    widget(iWidget).y = widget(iWidget-2).y + widget(iWidget-2).h + MARGIN;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hBackward         = uicontrol('Style',    'pushbutton', ...
                                  'String',   '-', ...
                                  'Position', widgetPosition, ...
                                  'Callback', {@backwardButton_callback});
                      
	%%% Forward button
    iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + MARGIN;
    widget(iWidget).y = widget(iWidget-1).y;
    widget(iWidget).w = 20;
    widget(iWidget).h = 20;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hForward          = uicontrol('Style',    'pushbutton', ...
                                  'String',   '+', ...
                                  'Position', widgetPosition, ...
                                  'Callback', {@forwardButton_callback});
                      
	%%% Sound plot area
    iWidget = iWidget + 1;
    
    widget(iWidget).x = widget(iWidget-1).x + widget(iWidget-1).w + 5*MARGIN;
    widget(iWidget).y = widget(iWidget-3).y;
    widget(iWidget).w = workspaceSize(1) - widget(iWidget).x - MARGIN;
    widget(iWidget).h = 200 - 10*MARGIN;
    
    widgetPosition    = [widget(iWidget).x, widget(iWidget).y, widget(iWidget).w, widget(iWidget).h];
    widgetPosition(2) = workspaceSize(2) - widgetPosition(2) - widgetPosition(4);
    hSo               = axes('Units',    'Pixels', ...
                             'Tag',      'soAxe', ...
                             'NextPlot', 'replaceChildren', ...
                             'Position', widgetPosition);
    
    
                         
    %% Declare timer
                         
	timerObj = timer('TimerFcn', @play_pause, 'Period', 0.001, 'Tag', 'hTimer');
    setappdata(gcf, 'timerObj', timerObj);
    
    
    %% Init global variables
    
%     init_appdata();
    
    
    
    %% Make the GUI visible.
    
    set(hFig, 'Visible', 'on');
    
end 
% eof
