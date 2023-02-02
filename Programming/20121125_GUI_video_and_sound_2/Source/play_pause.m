function play_pause(src, eventData)
    
    Data = guidata(gcf);
    Handles = guihandles(gcf);
    
    %% Read signals
    
    iSample = Data.iSample + 1;

    %%% Update signal cursor
    signal = Data.signal;
    plot(Data.tAxis, signal);
    set(gca, 'NextPlot', 'add');
    line([iSample, iSample]/Data.fs, [min(signal), max(signal)+0.05], 'Color', 'red');
    set(gca, 'NextPlot', 'replaceChildren');
    axis tight;

    %%% Conversion between sound index and video index
    nSamples = Data.nSamples;
    nFrames  = Data.nFrames;
    iFrame = iSample_to_iFrame(iSample, nSamples, nFrames);
    previousIFrame = iSample_to_iFrame(iSample-1, nSamples, nFrames);

    if iFrame == previousIFrame + 1,

        %%% Update video
        axes(Handles.viAxe);
        vidFrame  = read(Data.vidObj, iFrame);

        image(vidFrame);
        set(gca, 'DataAspectRatio', [1, 1, 1], ...
                 'PlotBoxAspectRatio',[1, 1, 1]);
        axis(gca, 'off');
        axis(gca, 'image');

        axes(Handles.soAxe);
    end

    Data.iFrame = iFrame;
    Data.iSample = iSample;
    guidata(gcf, Data);
    
end