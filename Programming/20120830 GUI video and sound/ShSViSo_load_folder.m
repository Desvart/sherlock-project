function ShSViSo_load_folder(folderPath)
        


    %% Load video

    fileName = folderPath(end-10:end); % disp(fileName);
    vidObj = VideoReader([folderPath, '\', fileName, '.avi']);

    nFrames   = vidObj.NumberOfFrames;
    vidHeight = vidObj.Height;
    vidWidth  = vidObj.Width; 
    fps       = vidObj.FrameRate;
    fps       = 8e3;%nFrames / (1/40);

    vidFrame  = read(vidObj, 1);
    axes(findobj('Tag', 'viAxe'));

    image(vidFrame);
    set(gca, 'DataAspectRatio',    [1, 1, 1], ...
             'PlotBoxAspectRatio', [1, 1, 1]);
    axis(gca, 'off');
    axis(gca, 'image');



    %% Load sound

    matObj = matfile([folderPath, '\', fileName, '.mat']);
    fs     = matObj.fs; s = 200e3/8-3e3;
    signal = matObj.signal(1, s+(1:nFrames/fps*fs));
    nSamples = length(signal);

    tAxis  = (0:nSamples-1)/fs;

    axes(findobj('Tag', 'soAxe'));
    plot(tAxis, signal);
    line([0, 0], [min(signal), max(signal)], 'Color', 'red');
    axis tight;



    %% Display information

    infoStr = sprintf(['Video(%dx%d) : %d frames @ %d fps                ', ...
                       'Sound : %4.2f kSamples @ %d kSps                 ', ...
                       'Vi-So (%4.3f ms) : 1/%d - 1/%d'], ...
                       vidWidth, vidHeight, nFrames, fps, nSamples/1e3, fs/1e3, nFrames/fps*1e3, nFrames, nSamples);
    set(findobj('Tag', 'infoField'), 'String', infoStr);
    
    
    
    %% Save usefull variables
    
    setappdata(gcf, 'fs',      fs);
    setappdata(gcf, 'signal',  signal);
    setappdata(gcf, 'nSamples', nSamples);
    setappdata(gcf, 'tAxis',   tAxis);
    
    setappdata(gcf, 'vidObj', vidObj);
    setappdata(gcf, 'nFrames', nFrames);
    
    setappdata(gcf, 'iSample', 1);
    setappdata(gcf, 'iFrame', 1);
    setappdata(gcf, 'previousIFrame', 0);

    
end
% eof
