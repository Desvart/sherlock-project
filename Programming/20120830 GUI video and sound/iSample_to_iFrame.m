function iFrame = iSample_to_iFrame(iSample, nSamples, nFrames)

    iFrame = round((nFrames-1)/(nSamples-1)*iSample + 1);
    
end