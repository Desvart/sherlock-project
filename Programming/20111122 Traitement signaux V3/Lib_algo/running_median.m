function signalFiltered = running_median(signal, sWindow)

    sSignal = length(signal);
    signalFiltered = zeros(1, sSignal);
    for i = sWindow : sSignal,
        signalFiltered(i) = median(signal(i-sWindow+1 : i));
    end
    
    signalFiltered(1:sWindow-1) = signalFiltered(sWindow+1+sWindow-2:-1:sWindow+1);
end
