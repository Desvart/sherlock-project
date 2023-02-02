function init_gui(deletePreviousDataFlag)
    
    fps = 17250;
    firstFrame = 2611; 
    lastFrame = 13600;

    %% Delete previous data
    
    if nargin == 1 && deletePreviousDataFlag == true,
    
       Data = guidata(gcf);
       delete(Data.timerObj);
       clear('Data');
       
    end

    

    %% Load data set path to work on
    
    Handles    = guihandles(gcf);
    folderPath = get(Handles.pathField, 'String');
    [filesName, nFiles] = list_folder_inventory(folderPath);
    fileName   = filesName{14};
%     fileName   = folderPath(end-12:end-1); 
    disp(fileName);

    
    
    %% Load video

    vidObj    = VideoReader([folderPath, fileName(1:end-4), '.mp4']);
%     nFrames   = vidObj.NumberOfFrames;
%     nFrames   = 7839 - 2410 + 1;
    nFrames   = lastFrame - firstFrame + 1;
    nFrames   = round(nFrames/19);
    vidHeight = vidObj.Height;
    vidWidth  = vidObj.Width; 
%     fps       = vidObj.FrameRate; %fps = 10e3; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fps       = fps/0.99471; 
    
    
    
    %% Load signal

    matObj   = matfile([folderPath, fileName(1:end-4), '.mat']);
    fs       = matObj.fs; %s = 200e3/8-3e3; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    nSamples = nFrames/fps*fs;
%     soStartIdx = (840/fps-700e-6)*fs;
    soStartIdx = round(firstFrame/fps*fs);
% 	soStartIdx = round(4686/fps*fs);
    signal   = matObj.signal(1, soStartIdx:(soStartIdx+nSamples-1));
%     signal   = matObj.signal(1, s+(1:121/8e3*fs)); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     nSamples = size(matObj, 'signal', 2); %nSamples = length(signal); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tAxis    = (0:nSamples-1)/fs;
    
    
    
    
   
    
    
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
%     Data.iFrame    = 4702-2880;
%     Data.iSample   = Data.iFrame/fps*fs;
    Data.zoom      = [1, nSamples];
    
    guidata(gcf, Data);
    
    

    %% Update axes (video and signal)
    
    update_axes(Data.iSample, Data.iFrame);


end
