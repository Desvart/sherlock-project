function init_gui(deletePreviousDataFlag)
    


    %% Delete previous data
    
    if nargin == 1 && deletePreviousDataFlag == true,
    
       Data = guidata(gcf);
       delete(Data.timerObj);
       clear('Data');
       
    end

    

    %% Load data set path to work on
    
    Handles    = guihandles(gcf);
    folderPath = get(Handles.pathField, 'String');    
    fileName   = folderPath(end-12:end-1); % disp(fileName);

    
    
    %% Load signal

    matObj   = matfile([folderPath, fileName, '.mat']);
    fs       = matObj.fs; %s = 200e3/8-3e3; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    signal   = matObj.signal(1, :);
%     signal   = matObj.signal(1, s+(1:121/8e3*fs)); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nSamples = size(matObj, 'signal', 2); %nSamples = length(signal); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tAxis    = (0:nSamples-1)/fs;
    
    
    
    %% Load video

    vidObj    = VideoReader([folderPath, fileName, '.avi']);
    nFrames   = vidObj.NumberOfFrames;
    vidHeight = vidObj.Height;
    vidWidth  = vidObj.Width; 
    fps       = vidObj.FrameRate; %fps = 8e3; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
    
    
    %% Set timer
    
    timerObj = timer('TimerFcn',      {@play_}, ...
                     'ExecutionMode', 'fixedrate', ...
                     'StartDelay',    0.5, ...
                     'Period',        0.001, ...
                     'BusyMode',      'queue', ...
                     'Tag',           'timerObj');
    
    
    
%     %% Update information field
%     
%     infoStr = sprintf(['Video(%dx%d) : %d frames @ %d fps                ', ...
%                        'Sound : %4.2f kSamples @ %d kSps                 ', ...
%                        'Vi-So (%4.3f ms) : 1/%d - 1/%d'], ...
%                        vidWidth, vidHeight, nFrames, fps, nSamples/1e3, fs/1e3, ...
%                        nFrames/fps*1e3, nFrames, nSamples);
%                    
%     set(Handles.infoField, 'String', infoStr);
    
   
    
    %% Save global data
    
    Data.signal    = signal;
    Data.fs        = fs;
    Data.tAxis     = tAxis;
    Data.nSamples  = nSamples;
    
    Data.vidObj    = vidObj;
    Data.nFrames   = nFrames;
    Data.fps       = fps;
    Data.vidWidth  = vidWidth;
    Data.vidHeight = vidHeight;
    
    Data.timerObj  = timerObj;
    
    Data.iSample   = 1;
    Data.iFrame    = 1;
    Data.zoom      = [1, nSamples];
    
    guidata(gcf, Data);
    
    

    %% Update axes (video and signal)
    
    update_axes(1, 1);


end
