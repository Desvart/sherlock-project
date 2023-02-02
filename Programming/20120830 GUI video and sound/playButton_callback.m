function playButton_callback(hSource, eventdata)

%     Data = guidata(gcf);
    timerObj = timerfind('Tag', 'timerObj');
    disp('Get');
    get(timerObj)
    if strcmp(get(timerObj, 'Running'), 'off'),
        start(timerObj);
        disp('Start');
        get(timerObj)
    else
        stop(timerObj);
        disp('Stop');
        get(timerObj)
    end
    
%     global timerObj;
% 
%     if strcmp(get(timerObj, 'Running'), 'off'),
%         start(timerObj);
%     else
%         stop(timerObj);
%     end
    
end
