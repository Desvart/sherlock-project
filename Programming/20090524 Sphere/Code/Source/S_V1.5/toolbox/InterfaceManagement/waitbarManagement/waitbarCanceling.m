function bool = waitbarCanceling(h, crossValIndex, nbCrossvalidation)
    if getappdata(h, 'canceling'),
        beep;
        disp(['WARNING : Sound recognition process has been stopped at iteration ', ...
                           int2str(crossValIndex), '/', int2str(nbCrossvalidation), '.']);
        bool = 1;
    else
        bool = 0;
    end
    
end
