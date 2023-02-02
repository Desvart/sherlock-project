function init_appdata_A2(data)
    


    %% Load data set path to work on
    
    handles = guihandles(gcf);

    folderPath = get(handles.pathField, 'String');
    if ~isdir(folderPath),
        folderPath = uigetdir('./', 'Select a data set folder to work on...');
%         set(findobj('Tag', 'pathField'), 'String', folderPath);
        set(handles.pathField, 'String', [folderPath, '\']);
    end
    
    fileName = folderPath(end-11:end-1); % disp(fileName);

    
    
    %% Load signal

    matObj   = matfile([folderPath, fileName, '.mat']);
    data.fs       = matObj.fs; s = 200e3/8-3e3;
    data.signal   = matObj.signal(1, s+(1:121/8e3*fs));
    data.nSamples = length(signal);
    data.tAxis    = (0:nSamples-1)/fs;
    
    
    
    %% Load video

    data.vidObj  = VideoReader([folderPath, fileName, '.avi']);
    data.nFrames = data.vidObj.NumberOfFrames;
    
    data.iSample        = 1;
    data.iFrame         = 1;
    data.previousIFrame = 0;

    
    
    %% Safe global data
    
    guidata(gcf, data);


end