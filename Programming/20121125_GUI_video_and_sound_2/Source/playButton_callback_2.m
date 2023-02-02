function playButton_callback_2(hSource, eventdata)

    folderPath = get(findobj('Tag', 'pathField'), 'String');
    fileName = folderPath(end-10:end); % disp(fileName);

    
    
    %% Load signal

    matObj  = matfile([folderPath, '\', fileName, '.mat']);
    fs      = matObj.fs; s = 200e3/8-3e3;
    signal  = matObj.signal(1, s+(1:121/8e3*fs));
    lSignal = length(signal);
   
    

    %% Load video

    vidObj = VideoReader([folderPath, '\', fileName, '.avi']);
    nFrames   = vidObj.NumberOfFrames;
    
    
    
    %% Read signals
    
    previousIFrame = 0;
    axes(findobj('Tag', 'soAxe'));
    for iSample = 0:lSignal-1,
        
        %%% Update signal cursor
        
%         hold off;
        tAxis  = 0:1/fs:(length(signal)-1)/fs;
%         hold on;
        plot(tAxis, signal);
        set(gca, 'NextPlot', 'add');
        line([iSample, iSample]/fs, [min(signal), max(signal)], 'Color', 'red');
        set(gca, 'NextPlot', 'replaceChildren');
        axis tight;
        
%         pause(0.001);
        
        %%% Conversion between sound index and video index
        iFrame = round((nFrames-1)/(lSignal-1)*iSample + 1);
        
        if iFrame == previousIFrame + 1,
            previousIFrame = iFrame;

           
            %%% Update video
            axes(findobj('Tag', 'viAxe'));
            vidFrame  = read(vidObj, iFrame);

            image(vidFrame);
            set(gca, 'DataAspectRatio', [1, 1, 1], ...
                     'PlotBoxAspectRatio',[1, 1, 1]);
            axis(gca, 'off');
            axis(gca, 'image');
            axes(findobj('Tag', 'soAxe'));
        end
        
        


    end
end
