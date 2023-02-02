function iSample = iFrame_to_iSample(iFrame, nSamples, nFrames)

    iSample = round((iFrame-1)*(nSamples-1)/(nFrames-1)) + 1;

end