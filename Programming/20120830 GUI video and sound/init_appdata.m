function init_appdata()

    folderPath = get(findobj('Tag', 'pathField'), 'String');
    fileName = folderPath(end-10:end); % disp(fileName);

    
    
    %% Load signal

    matObj   = matfile([folderPath, '\', fileName, '.mat']);
    fs       = matObj.fs; s = 200e3/8-3e3;
    signal   = matObj.signal(1, s+(1:121/8e3*fs));
    nSamples = length(signal);
    tAxis    = (0:nSamples-1)/fs;
    
    
    setappdata(gcf, 'fs',      fs);
    setappdata(gcf, 'signal',  signal);
    setappdata(gcf, 'nSamples', nSamples);
    setappdata(gcf, 'tAxis',   tAxis);
   
    

    %% Load video

    vidObj = VideoReader([folderPath, '\', fileName, '.avi']);
    nFrames   = vidObj.NumberOfFrames;
    
    setappdata(gcf, 'vidObj', vidObj);
    setappdata(gcf, 'nFrames', nFrames);
    
    
    setappadata(gcf, 'iSample', 1);
    setappadata(gcf, 'iFrame', 1);
    setappadata(gcf, 'previousIFrame', 0);




end