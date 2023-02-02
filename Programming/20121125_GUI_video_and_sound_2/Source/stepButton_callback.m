function stepButton_callback(hSrc, eventData, backwardOrForward)

    Data = guidata(gcf);
    nSamples = Data.nSamples;
    nFrames  = Data.nFrames;
    
    iSample = Data.iSample;
    iFrame  = Data.iFrame;
    
    oldFrame = iFrame;
    switch backwardOrForward,
        case '+',   while iFrame == oldFrame,
                        iSample = iSample + 1;
                        if iSample > nSamples,
                            iSample = nSamples;
                            iFrame = nFrames;
                            break;
                        end
                        iFrame = iSample_to_iFrame(iSample, nSamples, nFrames);
                    end
        case '-',  while iFrame == oldFrame,
                        iSample = iSample - 1;
                        if iSample < 1,
                            iSample = 1;
                            iFrame = 1;
                            break;
                        end
                        iFrame = iSample_to_iFrame(iSample, nSamples, nFrames);
                    end
        otherwise, error('');
    end
    
 
    Data.iFrame = iFrame;
    Data.iSample = iSample;
    
    guidata(gcf, Data);
    
    
    update_axes(iSample, iFrame);

end
