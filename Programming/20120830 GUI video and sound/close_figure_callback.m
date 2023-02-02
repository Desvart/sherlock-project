function close_figure_callback(src, eventdata)

    timerObjList = timerfind();
    nTimers = length(timerObjList);
    for iTimer = 1 : nTimers,
        stop(timerObjList(iTimer));
        delete(timerObjList(iTimer));
    end
    delete(gcf);



end