function setCursor_callback(hObject,~)

    Data = guidata(gcf);

    pos = get(hObject,'CurrentPoint');
%     disp(['You clicked X:',num2str(pos(1)),', Y:',num2str(pos(2))]);

    iSample = find(abs(Data.tAxis - pos(1)) < 1e-5);
    iSample = iSample(round(end/2));
    iFrame = round((Data.nFrames-1)/(Data.nSamples-1)*iSample + 1);
    
    update_axes(iSample, iFrame);
    
    Data.iSample = iSample;
    Data.iFrame = iFrame;
    guidata(gcf, Data);


end
