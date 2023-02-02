function update_axes(iSample, iFrame, updateOnlyCursorFlag)

    if nargin < 3,
        updateOnlyCursorFlag = false;
    end
    
    
    Handles = guihandles(gcf);
    Data = guidata(gcf);
    
    
    
    %%
    
    signal = Data.signal;
    fs = Data.fs;
    plot(Data.tAxis, signal);
    set(gca, 'NextPlot', 'add');
    signalMax = max(signal);
    signalMin = min(signal);
    
    area((10108:18266)/fs, signalMax*ones(1, 18267-10108), 'BaseValue', signalMin, 'FaceColor', [0, 1, 0]);
    area((50151:58152)/fs, signalMax*ones(1, 58153-50151), 'BaseValue', signalMin, 'FaceColor', [0, 1, 0]);
    area((90036:97684)/fs, signalMax*ones(1, 97685-90036), 'BaseValue', signalMin, 'FaceColor', [0, 1, 0]);
    plot(Data.tAxis, signal);
    line([iSample, iSample]/Data.fs,   [signalMin, signalMax+0.05], 'Color', 'red');
    disp(iSample);
    line([0, Data.nSamples-1]/Data.fs, [signalMax, signalMax],      'Color', 'black');
    set(gca, 'NextPlot', 'replaceChildren');
    axis tight;
    axis([0.03 0.12 signalMin signalMax+0.05]);
    
    
    %% Update information field
    
    infoStr = sprintf(['Video(%dx%d) : %d frames @ %d fps                ', ...
                       'Sound : %4.2f kSamples @ %d kSps                 ', ...
                       'Vi-So (%4.3f ms) : %d/%d - %d/%d'], ...
                       Data.vidWidth, Data.vidHeight, Data.nFrames, Data.fps, Data.nSamples/1e3, ...
                       Data.fs/1e3, Data.nFrames/Data.fps*1e3, Data.iFrame, Data.nFrames, ...
                       Data.iSample, Data.nSamples);
                   
    set(Handles.infoField, 'String', infoStr);
    
    
    
    
    %%
    
    if updateOnlyCursorFlag == false,
        axes(Handles.viAxe);
        vidFrame  = read(Data.vidObj, iFrame);

        vidFrame = histeq(vidFrame(:,:,1)); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         vidFrame = hist_p(vidFrame(:,:,1));
%         vidFrame = edge(vidFrame(:,:,1), 'canny');
        imshow(vidFrame);
%         image(vidFrame);
        set(gca, 'DataAspectRatio', [1, 1, 1], ...
                 'PlotBoxAspectRatio',[1, 1, 1]);
        axis(gca, 'off');
        axis(gca, 'image');

        axes(Handles.soAxe);
    end

end
