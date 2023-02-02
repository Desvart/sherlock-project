function select_file(filePath, handles)
    matObj = matfile(filePath);
    fs = matObj.fs;
    signal = matObj.signal(1, 1:fs);
    
    tAxis = (0:length(signal)-1)/fs;
    
%     dbstop in select_file at 10
    plot(handles.time, tAxis, signal);
    
    
    
    
    
    [stdft, tAxis, fAxis] = stdft_(signal, blackman(512, 'periodic'), 1/8, fs);
    
%     dbstop in select_file at 10
    pcolor(handles.timeFrequency, tAxis, fAxis, stdft);
    shading(handles.timeFrequency, 'flat');

    
end
