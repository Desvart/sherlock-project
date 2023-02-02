function play_(src, eventData)


    Data = guidata(gcf);
    
    %% Read signals
    
    iSample = Data.iSample + 1;
    
    
    %%% Conversion between sound index and video index
    nSamples = Data.nSamples;
    nFrames  = Data.nFrames;
    iFrame = iSample_to_iFrame(iSample, nSamples, nFrames);
    previousIFrame = iSample_to_iFrame(iSample-1, nSamples, nFrames);

    if iFrame == previousIFrame + 1,
        updateOnlyCursorFlag = true;
    else
        updateOnlyCursorFlag = false;
    end

    
    update_axes(iSample, iFrame, updateOnlyCursorFlag);
    
    
    Data.iFrame = iFrame;
    Data.iSample = iSample;
    guidata(gcf, Data);

    


end
